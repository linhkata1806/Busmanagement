package controller.assistant.notification;

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

    /** Hằng số vai trò phụ xe, khớp với giá trị TargetRole trong DB */
    private static final String ASSISTANT_ROLE = "ASSISTANT";

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

        int page = 1;
        int limit = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * limit;

        int totalNotifications = notificationService.countByAccountAndRole(accountId, ASSISTANT_ROLE);
        int totalPages = (int) Math.ceil((double) totalNotifications / limit);

        // Lấy cả thông báo đích danh + broadcast cho nhóm ASSISTANT (Spec Sprint 6 – Mục V)
        List<Notification> notiList = notificationService.getByAccountAndRole(accountId, ASSISTANT_ROLE, offset, limit);
        int unreadCount = notificationService.countUnreadByAccountAndRole(accountId, ASSISTANT_ROLE);

        request.setAttribute("notiList", notiList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/view/assistant/notification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đánh dấu đã đọc – chỉ áp dụng cho thông báo đích danh (có AccountID)
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        String notiIdStr = request.getParameter("notificationID");
        if (notiIdStr != null) {
            try {
                int notiID = Integer.parseInt(notiIdStr);
                notificationService.markAsRead(notiID, accountId);
                
                int updatedUnreadCount = notificationService.countUnreadByAccountAndRole(accountId, ASSISTANT_ROLE);
                session.setAttribute("globalUnreadCount", updatedUnreadCount);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("notification");
    }
}
