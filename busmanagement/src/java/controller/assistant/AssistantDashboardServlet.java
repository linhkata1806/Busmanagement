package controller.assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import model.Account;
import service.AssistantDashboardService;

public class AssistantDashboardServlet extends HttpServlet {
    private AssistantDashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new AssistantDashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int assistantID = user.getAccountID();

        Map<String, Object> stats = dashboardService.getDashboardStats(assistantID);
        for (Map.Entry<String, Object> entry : stats.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }

        request.getRequestDispatcher("/view/assistant/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
