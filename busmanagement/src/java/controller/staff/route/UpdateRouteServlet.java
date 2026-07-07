package controller.staff.route;

import controller.staff.*;
import dal.StopDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Route;
import service.RouteService;

public class UpdateRouteServlet extends HttpServlet {

    private RouteService routeService;
    private StopDAO stopDAO; // GỌI THÊM STOP DAO ĐỂ LẤY DATA CHO DROPDOWN

    @Override
    public void init() throws ServletException {
        routeService = new RouteService();
        stopDAO = new StopDAO(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int routeID = Integer.parseInt(request.getParameter("id"));
            Route route = routeService.getRouteById(routeID);

            if (route == null) {
                request.getSession().setAttribute("msgError", "Tuyến xe không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/staff/route");
                return;
            }

            request.setAttribute("route", route);
            // GỬI DANH SÁCH ĐIỂM DỪNG SANG JSP
            request.setAttribute("stops", stopDAO.getAllStops()); 
            
            request.getRequestDispatcher("/view/staff/route/view-route.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/route");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String routeIDStr = request.getParameter("id"); 
        String routeName = request.getParameter("routeName");
        String startPoint = request.getParameter("startPoint"); // BỔ SUNG
        String endPoint = request.getParameter("endPoint");     // BỔ SUNG
        String operatingHours = request.getParameter("operatingHours");
        String frequency = request.getParameter("frequency");
        String ticketPriceStr = request.getParameter("ticketPrice");
        String distanceStr = request.getParameter("distance");
        String estimatedDurationStr = request.getParameter("estimatedDuration"); // BỔ SUNG
        String statusStr = request.getParameter("status"); 

        Route route = new Route();
        try {
            route.setRouteID(Integer.parseInt(routeIDStr));
            route.setRouteName(routeName);
            route.setStartPoint(startPoint); // BỔ SUNG
            route.setEndPoint(endPoint);     // BỔ SUNG
            route.setOperatingHours(operatingHours);
            route.setFrequence(frequency);
            if(ticketPriceStr != null && !ticketPriceStr.isEmpty()) route.setTicketPrice(Long.parseLong(ticketPriceStr.trim()));
            if(distanceStr != null && !distanceStr.isEmpty()) route.setTotalDistance(Double.parseDouble(distanceStr.trim()));
            if(estimatedDurationStr != null && !estimatedDurationStr.isEmpty()) route.setEstimatedDuration(Integer.parseInt(estimatedDurationStr.trim())); // BỔ SUNG
            route.setIsActive("ACTIVE".equals(statusStr));
            
            // Mã tuyến vẫn khóa read-only
            route.setRouteNumber(request.getParameter("routeNumber")); 
        } catch (Exception ignored) {}

        try {
            int routeID = Integer.parseInt(routeIDStr);
            long ticketPrice = Long.parseLong(ticketPriceStr.trim());
            double distance = Double.parseDouble(distanceStr.trim());
            int estimatedDuration = Integer.parseInt(estimatedDurationStr.trim()); // BỔ SUNG
            boolean isActive = "ACTIVE".equals(statusStr);

            // Truyền đầy đủ startPoint, endPoint và estimatedDuration xuống Service
            routeService.updateRoute(routeID, routeName, startPoint, endPoint, operatingHours, frequency, ticketPrice, distance, estimatedDuration, isActive);

            request.getSession().setAttribute("msgSuccess", "Đã cập nhật thông tin tuyến xe thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/route");

        } catch (IllegalArgumentException e) {
            request.setAttribute("msgError", e.getMessage());
            request.setAttribute("route", route); 
            request.setAttribute("stops", stopDAO.getAllStops()); // Phải gửi lại danh sách trạm nếu form bị lỗi
            request.getRequestDispatcher("/view/staff/route/view-route.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("msgError", "Dữ liệu nhập không hợp lệ hoặc lỗi hệ thống.");
            request.setAttribute("route", route);
            request.setAttribute("stops", stopDAO.getAllStops());
            request.getRequestDispatcher("/view/staff/route/view-route.jsp").forward(request, response);
        }
    }
}