/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.PurchaseDAO;
import enums.NotificationType;
import enums.PassStatus;
import enums.SaleChannel;
import enums.TicketStatus;
import java.time.LocalDate;
import java.time.LocalDateTime;
import model.MonthlyPass;
import model.Notification;
import model.Route;
import model.Ticket;

/**
 *
 * @author Administrator
 */
public class PurchaseService {

    private RouteService routeService;
    private MonthlyPassService monthlyPassService;

    public PurchaseService() {
        routeService = new RouteService();
        monthlyPassService = new MonthlyPassService();
    }

    public void processPurchase(Integer accountID, int routeId, String ticketType, int passTypeID, String imageProof) throws Exception {
        PurchaseDAO purchaseDAO = new PurchaseDAO();
        System.out.println("====== PROCESS PURCHASE ======");
        System.out.println("ticketType = " + ticketType);
        System.out.println("passTypeID = " + passTypeID);
        System.out.println("==============================");
        // Vé lượt
        if ("luot".equals(ticketType)) {

            Route route = routeService.getRouteById(routeId);

            // Build Ticket
            Ticket ticket = buildTicket(accountID, routeId, route.getTicketPrice());

            // Build Notification
            Notification noti = buildNotification(
                    accountID,
                    "Mua vé lượt thành công",
                    "Bạn đã thanh toán vé lượt tuyến số " + route.getRouteNumber() + " thành công."
            );

            purchaseDAO.executePurchaseTicket(ticket, noti);
            return;
        }

// Vé tháng
        if ("thang".equals(ticketType) || "lien_chuyen".equals(ticketType)) {

            Integer targetRouteId
                    = "lien_chuyen".equals(ticketType) ? null : routeId;

            long price
                    = monthlyPassService.calculatePassPrice(targetRouteId, passTypeID);

            MonthlyPass pass
                    = buildMonthlyPass(
                            accountID,
                            targetRouteId,
                            passTypeID,
                            price,
                            imageProof
                    );

            Notification noti = buildNotification(
                    accountID,
                    "Đăng ký vé tháng thành công",
                    targetRouteId != null
                            ? "Bạn đã đăng ký thành công vé tháng tuyến số " + targetRouteId + "."
                            : "Bạn đã đăng ký thành công vé tháng liên tuyến."
            );

            purchaseDAO.executePurchaseMonthlyPass(pass, noti);
            return;
        }

        // ==========================================
        // NGOẠI LỆ: Dữ liệu rác lọt qua bộ lọc
        // ==========================================
        throw new Exception("Dữ liệu giao dịch không hợp lệ, không thể xác định loại vé.");
    }

    private Ticket buildTicket(int accountID, int routeId, long price) {
        Ticket ticket = new Ticket();
        ticket.setAccountID(accountID);
        ticket.setRouteID(routeId);
        ticket.setTicketCode("TK-" + routeId + "-" + System.currentTimeMillis());
        ticket.setPrice(price);
        ticket.setSaleChannel(SaleChannel.ONLINE);
        ticket.setStatus(TicketStatus.UNUSED);
        ticket.setPurchasedAt(LocalDateTime.now());
        ticket.setTripID(null);
        return ticket;
    }

    private MonthlyPass buildMonthlyPass(int accountID, Integer routeId, int passTypeID,
            long price, String imageProof) {
        MonthlyPass pass = new MonthlyPass();
        pass.setAccountID(accountID);
        pass.setRouteID(routeId);
        pass.setPassTypeID(passTypeID);
        pass.setPassCode("PASS-" + System.currentTimeMillis());
        LocalDate today = LocalDate.now();
        pass.setStartDate(today);
        pass.setEndDate(today.plusMonths(1));
        pass.setPrice(price);
        pass.setStatus(PassStatus.PENDING);
        pass.setImageProof(imageProof);
        return pass;
    }

    private Notification buildNotification(int accountID, String title, String content) {
        Notification noti = new Notification();
        noti.setAccountID(accountID);
        noti.setNotificationType(NotificationType.TICKET);
        noti.setTitle(title);
        noti.setContent(content);
        noti.setIsRead(false);
        noti.setCreatedAt(LocalDateTime.now());
        return noti;
    }
}
