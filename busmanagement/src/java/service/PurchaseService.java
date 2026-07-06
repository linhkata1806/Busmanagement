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

    public void processPurchase(int accountID, int routeId, String ticketType,
            int passTypeID, String imageProof) throws Exception {
        // 1. Lấy thông tin tuyến xe qua RouteService (Service gọi RouteService 
        Route route = routeService.getRouteById(routeId);
        if (route == null) {
            throw new Exception("Tuyến xe không tồn tại hoặc đã bị gỡ bỏ.");
        }
        PurchaseDAO purchaseDAO = new PurchaseDAO();
        // 3. Xử lý theo loại vé
        switch (ticketType) {
            case "luot": {
                Ticket ticket = buildTicket(accountID, routeId, route.getTicketPrice());
                Notification noti = buildNotification(accountID,
                        "Mua vé lượt thành công",
                        "Bạn đã thanh toán vé lượt tuyến số " + route.getRouteNumber() + " thành công.");
                purchaseDAO.executePurchaseTicket(ticket, noti);
                break;
            }
            case "thang": {
                long price = monthlyPassService.calculatePassPrice(routeId, passTypeID);
                MonthlyPass pass = buildMonthlyPass(accountID, routeId, passTypeID, price, imageProof);
                Notification noti = buildNotification(accountID,
                        "Đăng ký vé tháng thành công",
                        "Bạn đã đăng ký vé tháng cho tuyến số " + route.getRouteNumber() + " thành công.");
                purchaseDAO.executePurchaseMonthlyPass(pass, noti);
                break;
            }
            case "lien_chuyen": {
                long price = monthlyPassService.calculatePassPrice(null, passTypeID);
                MonthlyPass pass = buildMonthlyPass(accountID, null, passTypeID, price, imageProof);
                Notification noti = buildNotification(accountID,
                        "Đăng ký vé liên tuyến thành công",
                        "Bạn đã đăng ký thành công vé liên tuyến đi toàn mạng lưới.");
                purchaseDAO.executePurchaseMonthlyPass(pass, noti);
                break;
            }
            default:
                throw new Exception("Loại vé không hợp lệ.");
        }

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
