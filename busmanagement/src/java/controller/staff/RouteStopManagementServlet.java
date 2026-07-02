/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RouteStopService;

/**
 *
 * @author Administrator
 */
public class RouteStopManagementServlet extends HttpServlet {

    private RouteStopService routeStopService;

    @Override
    public void init() throws ServletException {
        routeStopService = new RouteStopService();
    }

    // HIỂN THỊ DANH SÁCH STOP CỦA TUYẾN
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String routeIdStr = request.getParameter("routeId");

        try {
            if (routeIdStr == null || routeIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn một tuyến xe để quản lý.");
            }

            int routeId = Integer.parseInt(routeIdStr.trim());

            // Gọi Service lấy dữ liệu đẩy sang JSP
            request.setAttribute("routeId", routeId);
            request.setAttribute("routeStops", routeStopService.getStopsByRoute(routeId));
            request.setAttribute("availableStops", routeStopService.getAvailableStops(routeId));

            // (Tuỳ chọn) Nếu bạn có RouteService, bạn có thể gọi thêm để lấy tên Route hiển thị: "Route 01: Gia Lâm - Yên Nghĩa"
            // Route route = routeService.getRouteById(routeId);
            // request.setAttribute("route", route);
            request.getRequestDispatcher("/view/staff/route-stop-management.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
            // Đá về trang danh sách tuyến xe nếu mã tuyến sai
            response.sendRedirect(request.getContextPath() + "/staff/route");
        } catch (Exception e) {
            request.getSession().setAttribute("msgError", "Đã xảy ra lỗi: Mã tuyến không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/staff/route");
        }
    }

    // XỬ LÝ ACTIONS: MOVE UP, MOVE DOWN, REMOVE
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String routeStopIdStr = request.getParameter("id"); // ID của bản ghi Route_Stop
        String routeIdStr = request.getParameter("routeId"); // ID của Tuyến (để redirect về đúng trang)

        try {
            int routeStopId = Integer.parseInt(routeStopIdStr.trim());

            switch (action) {
                case "up":
                    routeStopService.moveStopUp(routeStopId);
                    request.getSession().setAttribute("msgSuccess", "Đã đẩy điểm dừng lên trên thành công.");
                    break;
                case "down":
                    routeStopService.moveStopDown(routeStopId);
                    request.getSession().setAttribute("msgSuccess", "Đã kéo điểm dừng xuống dưới thành công.");
                    break;
                case "remove":
                    routeStopService.removeStopFromRoute(routeStopId);
                    request.getSession().setAttribute("msgSuccess", "Đã xóa điểm dừng khỏi tuyến thành công.");
                    break;
                default:
                    throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("msgError", "Mã điểm dừng không hợp lệ.");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage()); // Bắt lỗi Logic từ Service
        } catch (Exception e) {
            e.printStackTrace(); // Log cho Dev
            request.getSession().setAttribute("msgError", "Hệ thống đang gặp sự cố. Vui lòng thử lại sau."); // Giấu lỗi DB
        }

        // Luôn Redirect về lại trang quản lý của chính Route đó
        response.sendRedirect(request.getContextPath() + "/staff/route-stop?routeId=" + routeIdStr);
    }
}
