/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.staff.notification;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.NotificationService;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class NotificationManagementServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet NotificationManagementServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NotificationManagementServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
       NotificationService notificationService = new NotificationService();
       List<model.Notification> allNotifications = notificationService.getAllNotifications();
       
       int page = 1;
       String pageStr = request.getParameter("page");
       if (pageStr != null && !pageStr.isEmpty()) {
           try {
               page = Integer.parseInt(pageStr);
           } catch (Exception e) {}
       }
       
       util.Page<model.Notification> pageInfo = new util.Page<>(allNotifications, page, allNotifications.size(), 10);
       int start = (page - 1) * 10;
       int end = Math.min(start + 10, allNotifications.size());
       List<model.Notification> pagedList = allNotifications.isEmpty() ? allNotifications : allNotifications.subList(start, end);
       
       request.setAttribute("notifications", pagedList);
       request.setAttribute("currentPage", pageInfo.getCurrentPage());
       request.setAttribute("totalPages", pageInfo.getTotalPages());
       
       request.getRequestDispatcher("/view/staff/notification/notification-list.jsp").forward(request, response);
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
        processRequest(request, response);
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
