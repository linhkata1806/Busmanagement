package controller.staff;

import dal.StopDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Route;
import service.RouteService;

public class CreateRouteServlet extends HttpServlet {

    private RouteService routeService;
    private StopDAO stopDAO;

    @Override
    public void init() throws ServletException {
        routeService = new RouteService();
        stopDAO = new StopDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("stops", stopDAO.getAllStops());
            request.getRequestDispatcher("/view/staff/create-route.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/route");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String routeNumber = request.getParameter("routeNumber");
        String routeName = request.getParameter("routeName");
        String startPoint = request.getParameter("startPoint");
        String endPoint = request.getParameter("endPoint");
        String operatingHours = request.getParameter("operatingHours");
        String frequency = request.getParameter("frequency");
        String ticketPriceStr = request.getParameter("ticketPrice");
        String distanceStr = request.getParameter("distance");
        String estimatedDurationStr = request.getParameter("estimatedDuration");
        String statusStr = request.getParameter("status");

        Route route = new Route();
        try {
            route.setRouteNumber(routeNumber);
            route.setRouteName(routeName);
            route.setStartPoint(startPoint);
            route.setEndPoint(endPoint);
            route.setOperatingHours(operatingHours);
            route.setFrequence(frequency);
            if (ticketPriceStr != null && !ticketPriceStr.isEmpty()) route.setTicketPrice(Long.parseLong(ticketPriceStr.trim()));
            if (distanceStr != null && !distanceStr.isEmpty()) route.setTotalDistance(Double.parseDouble(distanceStr.trim()));
            if (estimatedDurationStr != null && !estimatedDurationStr.isEmpty()) route.setEstimatedDuration(Integer.parseInt(estimatedDurationStr.trim()));
            route.setIsActive("ACTIVE".equals(statusStr));
        } catch (Exception ignored) {}

        try {
            long ticketPrice = Long.parseLong(ticketPriceStr.trim());
            double distance = Double.parseDouble(distanceStr.trim());
            int estimatedDuration = Integer.parseInt(estimatedDurationStr.trim());
            boolean isActive = "ACTIVE".equals(statusStr);

            routeService.createRoute(routeNumber, routeName, startPoint, endPoint, operatingHours, frequency, ticketPrice, distance, estimatedDuration, isActive);

            request.getSession().setAttribute("msgSuccess", "Đã tạo mới tuyến xe thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/route");

        } catch (IllegalArgumentException e) {
            request.setAttribute("msgError", e.getMessage());
            request.setAttribute("route", route);
            request.setAttribute("stops", stopDAO.getAllStops());
            request.getRequestDispatcher("/view/staff/create-route.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("msgError", "Dữ liệu nhập không hợp lệ hoặc lỗi hệ thống.");
            request.setAttribute("route", route);
            request.setAttribute("stops", stopDAO.getAllStops());
            request.getRequestDispatcher("/view/staff/create-route.jsp").forward(request, response);
        }
    }
}
