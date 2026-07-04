package controller.driver;

import dto.RouteStopDTO;
import dto.TripDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Trip;
import service.RouteStopService;
import service.TripService;
import service.NotificationService;

public class TripDetailServlet extends HttpServlet {
    private TripService tripService;
    private RouteStopService routeStopService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        routeStopService = new RouteStopService();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");
        int driverID = user.getAccountID();

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã chuyến xe.");
            return;
        }

        try {
            int tripID = Integer.parseInt(idStr);
            Trip trip = tripService.getTripById(tripID);

            if (trip == null) {
                throw new IllegalArgumentException("Chuyến xe không tồn tại.");
            }

            // Security constraint: Check ownership
            if (trip.getDriverID() != driverID) {
                throw new IllegalArgumentException("Bạn không có quyền truy cập chuyến xe này.");
            }

            TripDTO tripDTO = tripService.getTripDTOByIDAndDriver(tripID, driverID);
            List<RouteStopDTO> routeStops = routeStopService.getStopsByRoute(trip.getRouteID());
            
            request.setAttribute("trip", tripDTO);
            request.setAttribute("routeStops", routeStops);

            // Fetch unread notification count for sidebar
            int unreadCount = notificationService.countUnreadNotifications(driverID);
            request.setAttribute("unreadCount", unreadCount);

            request.getRequestDispatcher("/view/driver/trip-detail.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/view/driver/trip-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
