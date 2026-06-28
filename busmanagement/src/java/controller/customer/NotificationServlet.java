/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Notification;
import service.NotificationService;

/**
 *
 * @author Administrator
 */
public class NotificationServlet extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet NotificationServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NotificationServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

        request.getRequestDispatcher("/view/customer/notification.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            out.print("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        Account user = (Account) session.getAttribute("USER");
        int accountId = user.getAccountID();

        try {
            int notiId = Integer.parseInt(request.getParameter("notiId"));
            String action = request.getParameter("action");

            // Validate Action
            if (!"read".equals(action) && !"delete".equals(action)) {
                out.print("{\"success\": false, \"message\": \"Invalid action\"}");
                return;
            }

            boolean result = false;
            if ("read".equals(action)) {
                result = notificationService.markAsRead(notiId, accountId);
            } else if ("delete".equals(action)) {
                result = notificationService.delete(notiId, accountId);
            }

            if (result) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false}");
            }

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
