package controller.customer;

import dal.AccountDAO;
import dal.FavoriteDAO;
import dal.MonthlyPassDAO;
import dal.NotificationDAO;
import dal.TicketDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import java.util.List;

public class ProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;
    private TicketDAO ticketDAO;
    private MonthlyPassDAO monthlyPassDAO;
    private FavoriteDAO favoriteDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
        ticketDAO = new TicketDAO();
        monthlyPassDAO = new MonthlyPassDAO();
        favoriteDAO = new FavoriteDAO();
        notificationDAO = new NotificationDAO();
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
        int accountId = user.getAccountID();

        // 1. Lấy thông tin chi tiết Account
        Account account = accountDAO.getAccountById(accountId);
        if (account == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("account", account);

        // 2. Lấy số liệu thống kê nhanh (Giống Dashboard)
        int totalTickets = 0;
        int totalPasses = 0;
        int totalFavorites = 0;
        int unreadNotifications = 0;

        try {
            totalTickets = ticketDAO.countUnusedTickets(accountId);
            totalPasses = monthlyPassDAO.countActivePasses(accountId);
            totalFavorites = favoriteDAO.countFavorites(accountId);
            unreadNotifications = notificationDAO.countUnreadNotifications(accountId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("totalPasses", totalPasses);
        request.setAttribute("totalFavorites", totalFavorites);
        request.setAttribute("unreadNotifications", unreadNotifications);

        // 3. Lấy dữ liệu Vé Tháng đang sử dụng thực tế
        dto.MonthlyPassDTO activeMonthlyPass = monthlyPassDAO.getActivePassByAccountId(accountId);
        request.setAttribute("activeMonthlyPass", activeMonthlyPass);

        // 4. Lấy danh sách lịch sử chuyến đi thực tế của khách hàng
        List<dto.TripHistoryDTO> recentTrips = ticketDAO.getRecentTripsByAccount(accountId);
        request.setAttribute("recentTrips", recentTrips);

        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}