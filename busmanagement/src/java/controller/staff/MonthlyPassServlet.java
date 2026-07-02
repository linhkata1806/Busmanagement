/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.staff;

import dto.MonthlyPassDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.MonthlyPassService;

/**
 *
 * @author Administrator
 */
public class MonthlyPassServlet extends HttpServlet {
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        monthlyPassService = new MonthlyPassService();
    }
    
   
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
            out.println("<title>Servlet MonthlyPassServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MonthlyPassServlet at " + request.getContextPath () + "</h1>");
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
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");
        
        List<MonthlyPassDTO> passList;
        // day xuong service khi status null 
        if(statusFilter ==null||statusFilter.isBlank()||statusFilter.equalsIgnoreCase("ALL")){
            statusFilter="ALL";
            passList = monthlyPassService.getAllPassesForStaff(searchQuery);
        }else{
            passList = monthlyPassService.getPassesByStatusForStaff(statusFilter.toUpperCase(),searchQuery);
        }
        
        //lay so luong badge hien thi
        int pendingCount = monthlyPassService.countPendingPasses();
        
        request.setAttribute("passList", passList);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("pendingPasses", pendingCount);

        request.getRequestDispatcher("/view/staff/monthly-pass.jsp").forward(request, response);
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
