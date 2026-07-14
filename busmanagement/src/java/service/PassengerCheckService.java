package service;

import dal.TicketDAO;
import enums.TicketStatus;
import java.sql.Connection;
import java.sql.SQLException;
import model.Ticket;

public class PassengerCheckService {

    private final TicketDAO ticketDAO;
    private final TicketValidationService validationService;

    public PassengerCheckService() {
        this.ticketDAO = new TicketDAO();
        this.validationService = new TicketValidationService();
    }

    public void checkInPassenger(String inputCode, int tripID) throws Exception {
        if (inputCode == null || inputCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã vé/Token không được để trống.");
        }

        String code = inputCode.trim();

        dal.TripDAO tripDAO = new dal.TripDAO();
        model.Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến đi #" + tripID + " không tồn tại.");
        }

        dal.BusDAO busDAO = new dal.BusDAO();
        model.Bus bus = busDAO.getBusById(trip.getBusID());
        int currentPassengers = ticketDAO.countTicketsByTrip(tripID);
        if (bus != null && bus.getCapacity() > 0 && currentPassengers >= bus.getCapacity()) {
            throw new IllegalArgumentException("Xe đã đạt số lượng tối đa (" + bus.getCapacity() + " người). Không thể soát thêm!");
        }

        // BIỂN BÁO ĐIỀU HƯỚNG MỚI: Dựa vào tiền tố để rẽ nhánh
        if (code.startsWith("TK-")) {
            // NHÁNH 1: LUỒNG KIỂM TRA VÉ NGÀY (TICKET)
            processTicketCheckIn(code, tripID, trip);
        } else {
            // NHÁNH 2: LUỒNG KIỂM TRA VÉ THÁNG (MONTHLY PASS BẰNG QR TOKEN)
            processMonthlyPassCheckIn(code, tripID, trip);
        }
    }

    // --- TÁCH HÀM XỬ LÝ VÉ NGÀY ---
    private void processTicketCheckIn(String code, int tripID, model.Trip trip) throws Exception {
        Ticket ticket = ticketDAO.getByCode(code);
        if (ticket == null) {
            throw new IllegalArgumentException("Mã vé ngày không tồn tại.");
        }

        // Gọi Service validation cũ của cậu (Không đổi logic)
        validationService.validateTicketForCheckIn(code, tripID);

        Connection conn = ticketDAO.getConnection();
        try {
            conn.setAutoCommit(false);
            ticketDAO.setConnection(conn);

            Ticket freshTicket = ticketDAO.getByCode(code);
            if (freshTicket == null || freshTicket.getStatus() != TicketStatus.UNUSED) {
                throw new IllegalArgumentException("Vé lượt đã được sử dụng hoặc không khả dụng.");
            }
            if (ticketDAO.hasPassengerConflict(freshTicket.getAccountID(), tripID, trip.getTripDate().toString())) {
                throw new IllegalArgumentException("Khách này đang được check-in trên 1 xe khác cùng khung giờ!");
            }

            boolean success = ticketDAO.checkInTicket(freshTicket.getTicketID(), tripID, TicketStatus.CHECKED_IN.name());
            if (!success) {
                throw new Exception("Lỗi hệ thống: Không thể cập nhật trạng thái vé lượt.");
            }

            conn.commit();
        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    // --- TÁCH HÀM XỬ LÝ VÉ THÁNG ---
    private void processMonthlyPassCheckIn(String token, int tripID, model.Trip trip) throws Exception {
        dal.MonthlyPassDAO monthlyPassDAO = new dal.MonthlyPassDAO();

        // DAO đã hỗ trợ tìm bằng QRCodeToken thông qua lệnh OR trong SQL
        model.MonthlyPass pass = monthlyPassDAO.getByCode(token);
        if (pass == null) {
            throw new IllegalArgumentException("Mã Token QR Thẻ tháng không hợp lệ.");
        }

        if (pass.getStatus() != enums.PassStatus.APPROVED) {
            throw new IllegalArgumentException("Thẻ tháng chưa được duyệt hoặc đã bị khóa.");
        }

        java.time.LocalDate today = java.time.LocalDate.now();
        if (today.isBefore(pass.getStartDate()) || today.isAfter(pass.getEndDate())) {
            throw new IllegalArgumentException("Thẻ tháng đã hết hạn hoặc chưa có hiệu lực.");
        }

        if (trip.getTripDate() == null || !trip.getTripDate().equals(today)) {
            throw new IllegalArgumentException("Chuyến xe này không khởi hành trong ngày hôm nay.");
        }

        // Logic cũ: RouteID = NULL là liên tuyến, nếu có RouteID thì phải khớp tuyến
        if (pass.getRouteID() != null && pass.getRouteID() != trip.getRouteID()) {
            throw new IllegalArgumentException("Thẻ tháng này KHÔNG áp dụng cho tuyến xe số " + trip.getRouteID());
        }

        if (ticketDAO.countPassengerCheckIn(pass.getAccountID(), tripID) > 0) {
            throw new IllegalArgumentException("Thẻ tháng này đã được quẹt trên xe rồi, không quẹt lại!");
        }

        if (ticketDAO.hasPassengerConflict(pass.getAccountID(), tripID, trip.getTripDate().toString())) {
            throw new IllegalArgumentException("Khách này đang quẹt thẻ trên 1 xe khác cùng khung giờ!");
        }

        // Cập nhật LastUsedAt
        if (!monthlyPassDAO.updateLastUsed(pass.getPassID())) {
            throw new Exception("Lỗi hệ thống: Không thể ghi nhận thời gian dùng thẻ.");
        }

        // Sinh vé ảo (0 đồng) để đếm số lượng người trên xe
        Ticket t = new Ticket();
        t.setAccountID(pass.getAccountID());
        t.setTripID(tripID);
        t.setRouteID(trip.getRouteID());
        // Đánh dấu vé ảo bằng chữ MP (Monthly Pass) để dễ phân biệt
        t.setTicketCode("MP-" + pass.getPassID() + "-" + System.currentTimeMillis());
        t.setPrice(0);
        t.setSaleChannel(enums.SaleChannel.ON_BUS);
        t.setStatus(enums.TicketStatus.CHECKED_IN);
        t.setPurchasedAt(java.time.LocalDateTime.now());

        ticketDAO.insert(t);

        // Đóng dấu UsedAt
        Ticket newTicket = ticketDAO.getByCode(t.getTicketCode());
        if (newTicket != null) {
            ticketDAO.checkInTicket(newTicket.getTicketID(), tripID, enums.TicketStatus.CHECKED_IN.name());
        }
    }
}
