/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import service.MonthlyPassService;
import service.TicketService;
import dal.RouteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Route;
import model.NotificationType;
import service.NotificationService;

/**
 *
 * @author Administrator
 */
public class BuyTicketServlet extends HttpServlet {

    // ==========================================
    // GET: LẤY THÔNG TIN TUYẾN & HIỂN THỊ FORM XÁC NHẬN
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        RouteDAO routeDAO = new RouteDAO();
        try {
            String routeIdRaw = request.getParameter("routeId");
            String ticketType = request.getParameter("ticketType"); // luot, thang, lien_chuyen

            // 1. Kiểm tra nếu tham số bị trống (lỗi trên URL nha mấy bảo bối)
            if (routeIdRaw == null || routeIdRaw.isEmpty()) {
                session.setAttribute("errorMsg", "Vui lòng chọn một tuyến xe cụ thể để tiến hành mua vé.");
                response.sendRedirect(request.getContextPath() + "/route-list");
                return;
            }

            // 2. Ép kiểu ID tuyến (Sẽ văng NumberFormatException nếu khách cố tình sửa URL thành chữ)
            int routeId = Integer.parseInt(routeIdRaw);

            // 3. vào DB tuyến xe
            Route route = routeDAO.getRouteById(routeId);

            // 4. Kiểm tra xem tuyến xe có thực sự tồn tại trong DB không
            if (route == null) {
                session.setAttribute("errorMsg", "Tuyến xe bạn yêu cầu không tồn tại hoặc đã dừng vận hành.");
                response.sendRedirect(request.getContextPath() + "/route-list");
                return;
            }

            // check nếu type khác 3 type quy ước nhe
            if (ticketType == null || (!ticketType.equals("luot") && !ticketType.equals("thang") && !ticketType.equals("lien_chuyen"))) {
                ticketType = "luot";
            }

            request.setAttribute("ticketType", ticketType);

            //day qua trang hoa don
            request.setAttribute("route", route);

            request.setAttribute("currentDate", new java.util.Date()); // Ngày giờ thời gian thực

            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // loi format  so
            session.setAttribute("errorMsg", "Mã số tuyến xe trên đường dẫn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/route-list");

        } catch (Exception e) {
            // loi chung chung nma phan lon do database
            session.setAttribute("errorMsg", "Hệ thống gặp sự cố khi tải thông tin tuyến: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/route-list");
        } finally {
            routeDAO.close(); // Giải phóng kết nối ngay sau khi tải xong thông tin
        }
    }

    // ==========================================
    // POST: XỬ LÝ LƯU GIAO DỊCH MUA VÉ VỚI TRANSACTION & COMMIT/ROLLBACK
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        if (routeIdRaw == null || routeIdRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/route-list");
            return;
        }

        RouteDAO routeDAO = new RouteDAO();
        TicketService ticketService = new TicketService();
        NotificationService notificationService = new NotificationService();
        MonthlyPassService monthlyPassService = new MonthlyPassService();

        // xu ly neu du lieu k trung voi 3 dang kia
        if (ticketType == null || (!ticketType.equals("luot") && !ticketType.equals("thang") && !ticketType.equals("lien_chuyen"))) {
            request.setAttribute("errorMsg", "Loại dịch vụ vé không hợp lệ.");
            reloadFormContext(request, routeDAO, routeIdRaw, "luot"); // Ép về luot để hiển thị lại form
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
            routeDAO.close();
            return;
        }

        try {
            int routeId = Integer.parseInt(routeIdRaw);
            Route route = routeDAO.getRouteById(routeId);

            if (route == null) {
                request.setAttribute("errorMsg", "Tuyến xe không tồn tại hoặc đã bị gỡ bỏ.");
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                routeDAO.close();
                return;
            }

            // Kiểm tra trùng lặp vé tháng trước khi tiến hành
            if (ticketType.equals("thang")) {
                dal.MonthlyPassDAO mpDAO = new dal.MonthlyPassDAO();
                mpDAO.setConnection(routeDAO.getConnection()); // dùng chung connection để tối ưu
                if (mpDAO.hasPendingOrApprovedPass(user.getAccountID(), routeId)) {
                    request.setAttribute("errorMsg", "Bạn đã đăng ký vé tháng cho tuyến này rồi.");
                    reloadFormContext(request, routeDAO, routeIdRaw, ticketType);
                    request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                    routeDAO.close();
                    return;
                }
            } else if (ticketType.equals("lien_chuyen")) {
                dal.MonthlyPassDAO mpDAO = new dal.MonthlyPassDAO();
                mpDAO.setConnection(routeDAO.getConnection()); // dùng chung connection để tối ưu
                if (mpDAO.hasPendingOrApprovedAllRoutePass(user.getAccountID())) {
                    request.setAttribute("errorMsg", "Bạn đã có vé tháng liên tuyến rồi.");
                    reloadFormContext(request, routeDAO, routeIdRaw, ticketType);
                    request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                    routeDAO.close();
                    return;
                }
            }

            // Tính toán giá tiền thực tế
            long price = 0;
            if (ticketType.equals("luot")) {
                price = route.getTicketPrice();
            } else if (ticketType.equals("thang")) {
                price = monthlyPassService.calculatePassPrice(routeId, passTypeID);
            } else {
                price = monthlyPassService.calculatePassPrice(null, passTypeID);
            }

            if (action != null && action.equals("confirm")) {
                // ==========================================
                // LUỒNG XÁC NHẬN: Thực tế ghi nhận vào Database
                // ==========================================
                java.sql.Connection conn = null;
                try {
                    dal.DBContext db = new dal.DBContext();
                    conn = db.getConnection();
                    conn.setAutoCommit(false); // Bắt đầu transaction

                    routeDAO.setConnection(conn);
                    ticketService.setConnection(conn);
                    notificationService.setConnection(conn);
                    monthlyPassService.setConnection(conn);

                    String notiTitle = "";
                    String notiContent = "";

                    switch (ticketType) {
                        case "luot":
                            ticketService.buySingleTicket(user.getAccountID(), routeId, route.getTicketPrice(), ticketType);
                            notiTitle = "Mua vé lượt thành công";
                            notiContent = "Bạn đã thanh toán vé lượt tuyến số " + route.getRouteNumber() + " thành công.";
                            break;

                        case "thang":
                            monthlyPassService.registerRoutePass(
                                    user.getAccountID(),
                                    routeId,
                                    passTypeID,
                                    imageProof
                            );
                            notiTitle = "Đăng ký vé tháng thành công";
                            notiContent = "Bạn đã đăng ký vé tháng cho tuyến số "
                                    + route.getRouteNumber()
                                    + " thành công.";
                            break;

                        case "lien_chuyen":
                            monthlyPassService.registerAllRoutePass(
                                    user.getAccountID(),
                                    passTypeID,
                                    imageProof
                            );
                            notiTitle = "Đăng ký vé liên tuyến thành công";
                            notiContent = "Bạn đã đăng ký thành công vé liên tuyến đi toàn mạng lưới.";
                            break;
                    }

                    // Tạo thông báo cho người dùng
                    notificationService.createNotification(
                            user.getAccountID(),
                            NotificationType.TICKET,
                            notiTitle,
                            notiContent
                    );

                    // Commit giao dịch
                    conn.commit();

                    session.setAttribute("successMsg", "Mua vé trực tuyến thành công! Vé đang chờ phê duyệt thanh toán.");
                    response.sendRedirect(request.getContextPath() + "/customer/ticket");

                } catch (Exception e) {
                    if (conn != null) {
                        try { conn.rollback(); } catch (java.sql.SQLException ex) { ex.printStackTrace(); }
                    }
                    request.setAttribute("errorMsg", "Lỗi lưu giao dịch: " + e.getMessage());
                    reloadFormContext(request, routeDAO, routeIdRaw, ticketType);
                    request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                } finally {
                    if (conn != null) {
                        try { conn.close(); } catch (java.sql.SQLException ex) { ex.printStackTrace(); }
                    }
                    routeDAO.close();
                }

            } else {
                // ==========================================
                // LUỒNG CHUYỂN HƯỚNG SANG QR: Chưa ghi vào Database
                // ==========================================
                routeDAO.close();
                session.setAttribute("successMsg", "Đặt mua thành công! Vui lòng quét mã QR thanh toán để hoàn tất.");
                response.sendRedirect(request.getContextPath() + "/customer/payment-qr"
                        + "?type=" + ticketType
                        + "&amount=" + price
                        + "&route=" + (route != null ? route.getRouteNumber() : "ALL")
                        + "&routeId=" + routeId
                        + "&passTypeId=" + passTypeID
                        + "&imageProof=" + java.net.URLEncoder.encode(imageProof, "UTF-8"));
            }

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
            reloadFormContext(request, routeDAO, routeIdRaw, ticketType);
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
            routeDAO.close();
        }
    }

    private void reloadFormContext(HttpServletRequest request, RouteDAO routeDAO, String routeIdRaw, String ticketType) {
        try {
            int routeId = Integer.parseInt(routeIdRaw);
            request.setAttribute("route", routeDAO.getRouteById(routeId));
            request.setAttribute("ticketType", ticketType);
            request.setAttribute("currentDate", new java.util.Date());
        } catch (Exception ignored) {
        }
    }
}
