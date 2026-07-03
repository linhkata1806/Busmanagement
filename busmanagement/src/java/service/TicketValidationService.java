package service;

import dal.TicketDAO;
import dal.TripDAO;
import enums.TicketStatus;
import model.Ticket;
import model.Trip;

public class TicketValidationService {
    private final TicketDAO ticketDAO;
    private final TripDAO tripDAO;

    public TicketValidationService() {
        this.ticketDAO = new TicketDAO();
        this.tripDAO = new TripDAO();
    }

    public Ticket validateTicketForCheckIn(String ticketCode, int tripID) {
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

        if (ticket.getStatus() != TicketStatus.UNUSED) {
            throw new IllegalArgumentException("Vé không ở trạng thái chưa sử dụng (Trạng thái hiện tại: " + ticket.getStatus() + ").");
        }

        if (ticket.getRouteID() != trip.getRouteID()) {
            throw new IllegalArgumentException("Tuyến đường của vé không trùng khớp với chuyến đi này (Vé thuộc tuyến #" + ticket.getRouteID() + ").");
        }

        return ticket;
    }
}
