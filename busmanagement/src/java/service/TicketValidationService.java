package service;

import dal.TicketDAO;
import dal.TripDAO;
import enums.TicketStatus;
import java.time.LocalDate;
import model.Ticket;
import model.Trip;

public class TicketValidationService {
    private final TicketDAO ticketDAO;
    private final TripDAO tripDAO;

    public TicketValidationService() {
        this.ticketDAO = new TicketDAO();
        this.tripDAO = new TripDAO();
    }

    /**
     * Xác thực vé trước khi check-in hành khách (Spec Sprint 6 – Mục III.4):
     * 1. Vé phải tồn tại
     * 2. Vé phải ở trạng thái UNUSED
     * 3. Tuyến đường của vé phải trùng với tuyến của chuyến đi
     * 4. Ngày chạy của chuyến đi phải là hôm nay (đúng ngày chạy)
     */
    public Ticket validateTicketForCheckIn(String ticketCode, int tripID) {
        
        ticketDAO.updateExpiredTickets(); 
        if (ticketCode == null || ticketCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã vé không được để trống.");
        }

        Ticket ticket = ticketDAO.getByCode(ticketCode.trim());
        if (ticket == null) {
            throw new IllegalArgumentException("Mã vé không tồn tại trên hệ thống.");
        }

        Trip trip = tripDAO.getById(tripID);
        if (trip == null) {
            throw new IllegalArgumentException("Chuyến đi #" + tripID + " không tồn tại.");
        }

        // 1. Kiểm tra trạng thái vé
        if (ticket.getStatus() != TicketStatus.UNUSED) {
            throw new IllegalArgumentException("Vé không ở trạng thái chưa sử dụng (Trạng thái hiện tại: " + ticket.getStatus() + ").");
        }

        // 2. Kiểm tra tuyến đường
        if (ticket.getRouteID() != trip.getRouteID()) {
            throw new IllegalArgumentException("Tuyến đường của vé không trùng khớp với chuyến đi này (Vé thuộc tuyến #" + ticket.getRouteID() + ").");
        }

        // 3. Kiểm tra đúng ngày chạy (Spec Sprint 6 – checklist TicketValidationService)
        LocalDate today = LocalDate.now();
        if (trip.getTripDate() == null || !trip.getTripDate().equals(today)) {
            throw new IllegalArgumentException("Vé chỉ hợp lệ vào đúng ngày chạy của chuyến đi (Ngày chạy: "
                    + (trip.getTripDate() != null ? trip.getTripDate() : "Không xác định") + ").");
        }

        return ticket;
    }
}
