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
import service.NotificationService;

/**
 *
 * @author Administrator
 */
public class BuyTicketServlet extends HttpServlet {

    private RouteDAO routeDAO;
    private TicketService ticketService;
    private NotificationService notificationService;
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
        ticketService = new TicketService();
        notificationService = new NotificationService();
        monthlyPassService = new MonthlyPassService();
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
        }
    }

    // ==========================================
    // POST: XỬ LÝ LƯU GIAO DỊCH MUA VÉ
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");

        String routeIdRaw = request.getParameter("routeId");
        String ticketType = request.getParameter("ticketType");
        int passTypeID = 1;

        if (routeIdRaw == null || routeIdRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/route-list");
            return;
        }

        // xu ly neu du lieu k trung voi 3 dang kia
        if (ticketType == null || (!ticketType.equals("luot") && !ticketType.equals("thang") && !ticketType.equals("lien_chuyen"))) {
            request.setAttribute("errorMsg", "Loại dịch vụ vé không hợp lệ.");
            reloadFormContext(request, routeIdRaw, "luot"); // Ép về luot để hiển thị lại form
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
            return;
        }

        try {
            int routeId = Integer.parseInt(routeIdRaw);
            Route route = routeDAO.getRouteById(routeId);

            if (route == null) {
                request.setAttribute("errorMsg", "Tuyến xe không tồn tại hoặc đã bị gỡ bỏ.");
                request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
                return;
            }

            String notiTitle = "";
            String notiContent = "";
            // ====================================================================
            // GỌI SERVICE: Cho phép Service tự quyết định và ném lỗi cụ thể (e.getMessage())
            // ====================================================================
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
                            passTypeID
                    );

                    notiTitle = "Đăng ký vé tháng thành công";

                    notiContent = "Bạn đã đăng ký vé tháng cho tuyến số "
                            + route.getRouteNumber()
                            + " thành công.";

                    break;

                case "lien_chuyen":

                    monthlyPassService.registerAllRoutePass(
                            user.getAccountID(),
                            passTypeID
                    );

                    notiTitle = "Đăng ký vé liên tuyến thành công";

                    notiContent
                            = "Bạn đã đăng ký thành công vé liên tuyến đi toàn mạng lưới.";

                    break;

                default:
                    throw new IllegalArgumentException("Loại dịch vụ vé không hợp lệ.");
            }

            notificationService.createNotification(
                    user.getAccountID(),
                    "TICKET", // Type để sau này filter
                    notiTitle, // Tiêu đề ngắn gọn
                    notiContent // Nội dung chi tiết
            );

            session.setAttribute("successMsg", "Mua vé trực tuyến thành công!");
            response.sendRedirect(request.getContextPath() + "/customer/ticket");

        } catch (IllegalArgumentException e) {
            //  nghiệp vụ từ Service (Ví dụ: Số dư tài khoản không đủ, Đã sở hữu vé...) nheee
            request.setAttribute("errorMsg", e.getMessage());

            // Đẩy lại dữ liệu cũ sang JSP để giao diện không bị trống trơn thông tin tuyến khi tải lại
            reloadFormContext(request, routeIdRaw, ticketType);
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);

        } catch (Exception e) {

            request.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());

            reloadFormContext(request, routeIdRaw, ticketType);
            request.getRequestDispatcher("/view/customer/buy-ticket.jsp").forward(request, response);
        }
    }

    private void reloadFormContext(HttpServletRequest request, String routeIdRaw, String ticketType) {
        try {
            int routeId = Integer.parseInt(routeIdRaw);
            request.setAttribute("route", routeDAO.getRouteById(routeId));
            request.setAttribute("ticketType", ticketType);
            request.setAttribute("currentDate", new java.util.Date());
        } catch (Exception ignored) {
        }
    }

}
