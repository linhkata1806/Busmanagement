package controller.driver;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import model.Account;
import service.DriverDashboardService;

public class DriverDashboardServlet extends HttpServlet {
    private DriverDashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new DriverDashboardService();
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

        Map<String, Object> stats = dashboardService.getDashboardStats(driverID);
        for (Map.Entry<String, Object> entry : stats.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        // Set unreadCount for sidebar
        int unreadCount = (int) stats.get("pendingNotifications");
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/view/driver/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
