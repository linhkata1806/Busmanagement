package controller.assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Notification;
import service.NotificationService;

public class NotificationServlet extends HttpServlet {
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        List<Notification> notiList = notificationService.getByAccount(accountId);
        int unreadCount = notificationService.countUnreadNotifications(accountId);

        request.setAttribute("notiList", notiList);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/view/assistant/notification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mark as read logic
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        String notiIdStr = request.getParameter("notificationID");
        if (notiIdStr != null) {
            try {
                int notiID = Integer.parseInt(notiIdStr);
                notificationService.markAsRead(notiID, accountId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("notification");
    }
}
