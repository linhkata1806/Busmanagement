/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.MonthlyPassService;
import service.NotificationService;
import service.TripService;

/**
 *
 * @author Administrator
 */
public class StaffDashboardServlet extends HttpServlet {
    private MonthlyPassService monthlyPassService;
    private TripService tripService;
   private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        monthlyPassService = new MonthlyPassService();
        tripService = new TripService();
        notificationService = new NotificationService();
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
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        
        //thống kê nha các bảo bói
        int pendingPasses = monthlyPassService.countPendingPasses();
        int totalTripsToday = tripService.countTripsToday();
        int totalNotifications = notificationService.countNotifications();
        
        request.setAttribute("staff", user);
        request.setAttribute("pendingPasses", pendingPasses);
        request.setAttribute("totalTripsToday", totalTripsToday);
        request.setAttribute("totalNotifications", totalNotifications);
        
        request.getRequestDispatcher("/view/staff/dashboard.jsp").forward(request, response);
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
