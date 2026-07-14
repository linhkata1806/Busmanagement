/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.TicketDAO;
import dto.TicketDTO;
import enums.SaleChannel;
import enums.TicketStatus;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import model.Ticket;
import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class TicketService {

    private TicketDAO ticketDAO ;

    public TicketService() {
        ticketDAO= new TicketDAO();
    }

 
    //========customer(xu ly mua ve)
    public void buySingleTicket(int accountID, int routeId, long ticketPrice, String ticketType) throws Exception {
        Ticket ticket = new Ticket();

        ticket.setAccountID(accountID);
        ticket.setRouteID(routeId);

        ticket.setTicketCode(generateTicketCode(routeId));

        ticket.setPrice(ticketPrice);
        ticket.setSaleChannel(SaleChannel.ONLINE);
        ticket.setStatus(TicketStatus.UNUSED); // BỔ SUNG: Vé mới mua bắt đầu ở trạng thái UNUSED
        ticket.setPurchasedAt(LocalDateTime.now());
        ticket.setTripID(null);
        if (!ticketDAO.insert(ticket)) {
            throw new Exception("Lỗi hệ thống: Không thể ghi nhận vé vào cơ sở dữ liệu.");
        }

    }

    private String generateTicketCode(int routeId) {
        return "TK-" + routeId + "-" + System.currentTimeMillis();
    }
    //====custome(lay danh sach ve)
    public int countTicketsByAccount(int accountID) {
        return ticketDAO.countTicketsByAccount(accountID);
    }

    public List<TicketDTO> getTicketsByAccount(int accountID, int offset, int limit) {
        ticketDAO.updateExpiredTickets(); 
        return ticketDAO.getTicketsByAccount(accountID, offset, limit);
    }

    public int countTicketsByTrip(int tripID) {
        return ticketDAO.countTicketsByTrip(tripID);
    }

    public List<model.Ticket> getTicketsByTrip(int tripID, int offset, int limit) {
        return ticketDAO.getTicketsByTrip(tripID, offset, limit);
    }
}
