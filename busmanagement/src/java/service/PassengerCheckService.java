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

    public void checkInPassenger(String code, int tripID) throws Exception {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã vé/thẻ không được để trống.");
        }
        dal.TripDAO tripDAO = new dal.TripDAO();
        model.Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến đi #" + tripID + " không tồn tại.");
        }

        dal.BusDAO busDAO = new dal.BusDAO();
        model.Bus bus = busDAO.getBusById(trip.getBusID());
        int currentPassengers = ticketDAO.getTicketsByTrip(tripID).size();
        if (bus != null && bus.getCapacity() > 0 && currentPassengers >= bus.getCapacity()) {
            throw new IllegalArgumentException("Xe đã đạt số lượng hành khách tối đa (" + bus.getCapacity() + " người). Không thể soát thêm!");
        }
        Ticket ticket = ticketDAO.getByCode(code.trim());
        if (ticket != null) {
            // It is a regular ticket
            Ticket validatedTicket = validationService.validateTicketForCheckIn(code, tripID);

            Connection conn = ticketDAO.getConnection();
            try {
                conn.setAutoCommit(false);
                ticketDAO.setConnection(conn);

                Ticket freshTicket = ticketDAO.getByCode(code.trim());
                if (freshTicket == null || freshTicket.getStatus() != TicketStatus.UNUSED) {
                    throw new IllegalArgumentException("Vé đã bị thay đổi trạng thái hoặc không khả dụng.");
                }
                if (ticketDAO.hasPassengerConflict(freshTicket.getAccountID(), tripID, trip.getTripDate().toString())) {
                    throw new IllegalArgumentException("Hành khách này đã check-in trên một chuyến xe khác chạy song song cùng khung giờ!");
                }
                boolean success = ticketDAO.checkInTicket(freshTicket.getTicketID(), tripID, TicketStatus.CHECKED_IN.name());
                if (!success) {
                    throw new Exception("Lỗi hệ thống: Không thể cập nhật trạng thái soát vé.");
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
        } else {
            // It might be a monthly pass
            dal.MonthlyPassDAO monthlyPassDAO = new dal.MonthlyPassDAO();
            model.MonthlyPass pass = monthlyPassDAO.getByCode(code.trim());
            if (pass == null) {
                throw new IllegalArgumentException("Mã vé/thẻ không tồn tại trên hệ thống.");
            }

            // Validate Monthly Pass
            if (pass.getStatus() != enums.PassStatus.APPROVED) {
                throw new IllegalArgumentException("Thẻ tháng chưa được duyệt hoặc không hợp lệ.");
            }
            java.time.LocalDate today = java.time.LocalDate.now();
            if (today.isBefore(pass.getStartDate()) || today.isAfter(pass.getEndDate())) {
                throw new IllegalArgumentException("Thẻ tháng đã hết hạn hoặc chưa có hiệu lực.");
            }

            if (trip == null) {
                throw new IllegalArgumentException("Chuyến đi #" + tripID + " không tồn tại.");
            }

            // Vé tháng cũng chỉ đi đúng ngày chạy
            if (trip.getTripDate() == null || !trip.getTripDate().equals(today)) {
                throw new IllegalArgumentException("Thẻ tháng chỉ hợp lệ check-in vào ngày xe chạy.");
            }

            if (pass.getRouteID() != null && pass.getRouteID() != trip.getRouteID()) {
                throw new IllegalArgumentException("Thẻ tháng không áp dụng cho tuyến đường này.");
            }
            int hasCheckedInPass = ticketDAO.countPassengerCheckIn(pass.getAccountID(), tripID);
            if (hasCheckedInPass > 0) {
                throw new IllegalArgumentException("Thẻ tháng này đã thực hiện soát vé trên chuyến xe này rồi!");
            }

            if (ticketDAO.hasPassengerConflict(pass.getAccountID(), tripID, trip.getTripDate().toString())) {
                throw new IllegalArgumentException("Hành khách dùng thẻ tháng này hiện đã leo lên một xe khác chạy cùng khung giờ!");
            }

            // Check if already checked in to avoid double check-in?
            // To do this simply, we assume lastUsedAt prevents rapid double scans if we want,
            // but the requirements say "chưa có check in vé tháng".
            // Update last used time
            boolean ok = monthlyPassDAO.updateLastUsed(pass.getPassID());
            if (!ok) {
                throw new Exception("Lỗi hệ thống khi cập nhật thẻ tháng.");
            }

            // Insert a virtual ticket so it shows up in checked-in list
            Ticket t = new Ticket();
            t.setAccountID(pass.getAccountID());
            t.setTripID(tripID);
            t.setRouteID(trip.getRouteID());
            t.setTicketCode(code.trim() + "-" + System.currentTimeMillis());
            t.setPrice(0);
            t.setSaleChannel(enums.SaleChannel.ON_BUS);
            t.setStatus(enums.TicketStatus.CHECKED_IN);
            t.setPurchasedAt(java.time.LocalDateTime.now());

            ticketDAO.insert(t);

            // To make sure UsedAt is recorded properly for the dashboard list:
            Ticket newTicket = ticketDAO.getByCode(t.getTicketCode());
            if (newTicket != null) {
                ticketDAO.checkInTicket(newTicket.getTicketID(), tripID, enums.TicketStatus.CHECKED_IN.name());
            }
        }
    }
}
