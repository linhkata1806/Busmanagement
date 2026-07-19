package controller.driver.trip;

import dto.TripDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import service.TripService;
import service.NotificationService;

public class MyTripServlet extends HttpServlet {
    private TripService tripService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
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

        List<TripDTO> assignedTrips = tripService.getTripsByDriver(driverID);
        request.setAttribute("assignedTrips", assignedTrips);

        // Fetch unread notification count for sidebar
        int unreadCount = notificationService.countUnreadByAccountAndRole(driverID, "DRIVER");
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/view/driver/trip/my-trip.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
