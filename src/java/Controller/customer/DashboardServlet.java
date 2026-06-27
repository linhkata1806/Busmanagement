/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.customer;

import dal.FavoriteDAO;
import dal.MonthlyPassDAO;
import dal.NotificationDAO;
import dal.RouteDAO;
import dal.StopDAO;
import dal.TicketDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Route;
import model.Stop;

/**
 *
 * @author Administrator
 */
public class DashboardServlet extends HttpServlet {
   
    private TicketDAO ticketDAO;
    private MonthlyPassDAO monthlyPassDAO;
    private FavoriteDAO favoriteDAO;
    private NotificationDAO notificationDAO;
     private RouteDAO routeDAO;
    private StopDAO stopDAO;


    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
        monthlyPassDAO = new MonthlyPassDAO();
        favoriteDAO = new FavoriteDAO();
        notificationDAO = new NotificationDAO();
        routeDAO = new RouteDAO();
        stopDAO = new StopDAO();
    }
    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // 1. Kiểm tra Session (Lớp phòng thủ phụ, dù đã có Filter)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy AccountID từ Session
        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        // 3. Gọi DAO để đếm số liệu (Thực thi logic Sprint 3)
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
        List<Route> popularRoutes = routeDAO.getPopularRoutes(6);
        request.setAttribute("popularRoutes", popularRoutes);

        List<Stop> stopNames = stopDAO.getAllStops();

        request.setAttribute("stopNames", stopNames);

        // 4. Gắn dữ liệu vào Request Scope
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("totalPasses", totalPasses);
        request.setAttribute("totalFavorites", totalFavorites);
        request.setAttribute("unreadNotifications", unreadNotifications);

        // 5. Điều hướng sang JSP
        request.getRequestDispatcher("/view/customer/dashboard.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
