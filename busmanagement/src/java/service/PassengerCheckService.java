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

    public void checkInPassenger(String ticketCode, int tripID) throws Exception {
        // Validate ticket first (will throw IllegalArgumentException if invalid)
        Ticket ticket = validationService.validateTicketForCheckIn(ticketCode, tripID);

        Connection conn = ticketDAO.getConnection();
        try {
            conn.setAutoCommit(false);

            // Re-bind connection to DAO to ensure transaction consistency
            ticketDAO.setConnection(conn);

            // Double check state inside transaction for concurrency safety
            Ticket freshTicket = ticketDAO.getByCode(ticketCode.trim());
            if (freshTicket == null || freshTicket.getStatus() != TicketStatus.UNUSED) {
                throw new IllegalArgumentException("Vé đã bị thay đổi trạng thái hoặc không khả dụng.");
            }

            // Perform check-in update: Status -> CHECKED_IN, TripID -> tripID
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
    }
}
