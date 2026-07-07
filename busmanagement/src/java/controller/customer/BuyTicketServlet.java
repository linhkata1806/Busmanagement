/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Route;
import service.MonthlyPassService;
import service.PurchaseService;
import service.RouteService;

/**
 *
 * @author Administrator
 */
public class BuyTicketServlet extends HttpServlet {

    private RouteService routeService;
    private MonthlyPassService monthlyPassService;
    private PurchaseService purchaseService;

    @Override
    public void init() throws ServletException {
        routeService = new RouteService();
        monthlyPassService = new MonthlyPassService();
        purchaseService = new PurchaseService();
    }

    // ==========================================
    // GET: LẤY THÔNG TIN TUYẾN & HIỂN THỊ FORM XÁC NHẬN
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        try {
            String routeIdRaw = request.getParameter("routeId");
            String ticketType = request.getParameter("ticketType"); // luot, thang, lien_chuyen
            // 1. Kiểm tra nếu tham số bị trống
            if (routeIdRaw == null || routeIdRaw.isEmpty()) {
                session.setAttribute("errorMsg", "Vui lòng chọn một tuyến xe cụ thể để tiến hành mua vé.");
                response.sendRedirect(request.getContextPath() + "/route-list");
                return;
            }
            // 2. Ép kiểu ID tuyến
            int routeId = Integer.parseInt(routeIdRaw);
            // 3. Lấy thông tin tuyến xe qua Service
            Route route = routeService.getRouteById(routeId);
            // 4. Kiểm tra xem tuyến xe có tồn tại không
            if (route == null) {
                session.setAttribute("errorMsg", "Tuyến xe bạn yêu cầu không tồn tại hoặc đã dừng vận hành.");
                response.sendRedirect(request.getContextPath() + "/route-list");
                return;
            }
            // 5. Tính giá hiển thị trên form
            long displayPrice;
            switch (ticketType) {
                case "luot":
                    displayPrice = (long) route.getTicketPrice();
                    break;
                case "thang":
                    displayPrice = 100_000L;
                    break;
                case "lien_chuyen":
                    displayPrice = 200_000L;
                    break;
                default:
                    displayPrice = (long) route.getTicketPrice();
            }
            // 6. Đẩy dữ liệu qua trang hóa đơn
            request.setAttribute("ticketType", ticketType);
            request.setAttribute("displayPrice", displayPrice);
            request.setAttribute("route", route);
            request.setAttribute("currentDate", new java.util.Date());
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã số tuyến xe trên đường dẫn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/route-list");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Hệ thống gặp sự cố khi tải thông tin tuyến: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/route-list");
        }
    }

    // ==========================================
    // POST: XỬ LÝ MUA VÉ — CHỈ GỌI SERVICE, KHÔNG CHẠM DB
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        String action = request.getParameter("action");
        String routeIdRaw = request.getParameter("routeId");
        String ticketType = request.getParameter("ticketType");
        String passTypeIdRaw = request.getParameter("passTypeId");
        int passTypeID = (passTypeIdRaw != null && !passTypeIdRaw.isEmpty()) ? Integer.parseInt(passTypeIdRaw) : 1;
        String imageProof = request.getParameter("imageProof");
        if (imageProof == null) {
            imageProof = "";
        }
        // Validate routeId
        if (routeIdRaw == null || routeIdRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/route-list");
            return;
        }
        // Validate ticketType
        if (ticketType == null || (!ticketType.equals("luot") && !ticketType.equals("thang") && !ticketType.equals("lien_chuyen"))) {
            request.setAttribute("errorMsg", "Loại dịch vụ vé không hợp lệ.");
            reloadFormContext(request, routeIdRaw, "luot");
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
            return;
        }
        try {
            int routeId = Integer.parseInt(routeIdRaw);
            // 1. Lấy thông tin tuyến xe qua Service
            Route route = routeService.getRouteById(routeId);
            if (route == null) {
                request.setAttribute("errorMsg", "Tuyến xe không tồn tại hoặc đã bị gỡ bỏ.");
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                return;
            }
            // 2. Kiểm tra trùng lặp vé tháng qua Service
            if (ticketType.equals("thang") && monthlyPassService.hasPendingOrApprovedPass(user.getAccountID(), routeId)) {
                request.setAttribute("errorMsg", "Bạn đã đăng ký vé tháng cho tuyến này rồi.");
                reloadFormContext(request, routeIdRaw, ticketType);
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                return;
            }
            if (ticketType.equals("lien_chuyen") && monthlyPassService.hasPendingOrApprovedAllRoutePass(user.getAccountID())) {
                request.setAttribute("errorMsg", "Bạn đã có vé tháng liên tuyến rồi.");
                reloadFormContext(request, routeIdRaw, ticketType);
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                return;
            }
            // 3. Tính giá vé qua Service
            long price;
            if (ticketType.equals("luot")) {
                price = route.getTicketPrice();
            } else if (ticketType.equals("thang")) {
                price = monthlyPassService.calculatePassPrice(routeId, passTypeID);
            } else {
                price = monthlyPassService.calculatePassPrice(null, passTypeID);
            }
            if (action != null && action.equals("confirm")) {
                // ==========================================
                // LUỒNG XÁC NHẬN: Gọi PurchaseService xử lý toàn bộ transaction
                // ==========================================
                try {
                    purchaseService.processPurchase(
                            user.getAccountID(),
                            routeId,
                            ticketType,
                            passTypeID,
                            imageProof
                    );
                    session.setAttribute("successMsg", "Mua vé trực tuyến thành công! Vé đang chờ phê duyệt thanh toán.");
                    response.sendRedirect(request.getContextPath() + "/customer/ticket");
                } catch (Exception e) {
                    request.setAttribute("errorMsg", "Lỗi lưu giao dịch: " + e.getMessage());
                    reloadFormContext(request, routeIdRaw, ticketType);
                    request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                }
            } else {
                // ==========================================
                // LUỒNG CHUYỂN HƯỚNG SANG QR: Chưa ghi vào Database
                // ==========================================
                session.setAttribute("successMsg", "Đặt mua thành công! Vui lòng quét mã QR thanh toán để hoàn tất.");
                request.setAttribute("qrType", ticketType);
                request.setAttribute("qrAmount", price);
                request.setAttribute("qrRoute", route != null ? route.getRouteNumber() : "ALL");
                request.setAttribute("qrRouteId", routeId);
                request.setAttribute("qrPassTypeId", passTypeID);
                request.setAttribute("qrImageProof", imageProof);

                request.getRequestDispatcher("/view/customer/payment-qr.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
            reloadFormContext(request, routeIdRaw, ticketType);
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
        }
    }

    /**
     * Nạp lại dữ liệu form khi cần hiển thị lại trang mua vé (sau lỗi
     * validation).
     */
    private void reloadFormContext(HttpServletRequest request, String routeIdRaw, String ticketType) {
        try {
            int routeId = Integer.parseInt(routeIdRaw);
            request.setAttribute("route", routeService.getRouteById(routeId));
            request.setAttribute("ticketType", ticketType);
            request.setAttribute("currentDate", new java.util.Date());
        } catch (Exception ignored) {
        }
    }
}
