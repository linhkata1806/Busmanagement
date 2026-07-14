/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.staff.pass;

import controller.staff.*;
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
        int page = 1;
        int limit = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * limit;

        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");
        
        // Làm sạch chuỗi
        statusFilter = statusFilter == null ? "" : statusFilter.trim();
        searchQuery = searchQuery == null ? "" : searchQuery.trim();
        
        List<MonthlyPassDTO> passList;
        // day xuong service khi status null 
        if(statusFilter.isEmpty() || statusFilter.equalsIgnoreCase("ALL")){
            statusFilter="ALL";
            passList = monthlyPassService.getAllPassesForStaff(searchQuery, offset, limit);
        }else{
            passList = monthlyPassService.getPassesByStatusForStaff(statusFilter.toUpperCase(), searchQuery, offset, limit);
        }
        
        int totalRecords = monthlyPassService.countPassesForStaff(statusFilter.toUpperCase(), searchQuery);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        StringBuilder queryString = new StringBuilder();
        if (!statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
            queryString.append("status=").append(java.net.URLEncoder.encode(statusFilter, "UTF-8"));
        }
        if (!searchQuery.isEmpty()) {
            if (queryString.length() > 0) queryString.append("&");
            queryString.append("search=").append(java.net.URLEncoder.encode(searchQuery, "UTF-8"));
        }
        
        //lay so luong badge hien thi
        int pendingCount = monthlyPassService.countPendingPasses();
        
        request.setAttribute("passList", passList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("queryString", queryString.toString());
        
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("pendingPasses", pendingCount);

        request.getRequestDispatcher("/view/staff/pass/monthly-pass.jsp").forward(request, response);
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
