/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff.bus;

import controller.staff.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Bus;
import service.BusService;

/**
 *
 * @author Administrator
 */
public class BusManagementServlet extends HttpServlet {
    private BusService busService;

    @Override
    public void init() throws ServletException {
        busService = new BusService();
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
            out.println("<title>Servlet BusManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BusManagementServlet at " + request.getContextPath() + "</h1>");
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
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        //search+filter nha tinh yeu
        List<Bus> buses = busService.searchAndFilter(keyword, status);
        // Chống hiển thị null trên ô input và dropdown
        request.setAttribute("keyword",
                keyword == null ? "" : keyword.trim());

        request.setAttribute("status",
                status == null ? "ALL" : status.trim().toUpperCase());

        StringBuilder qs = new StringBuilder();
        if (keyword != null && !keyword.isEmpty()) qs.append("keyword=").append(keyword).append("&");
        if (status != null && !status.isEmpty()) qs.append("status=").append(status).append("&");
        if (qs.length() > 0) {
            qs.deleteCharAt(qs.length() - 1);
            request.setAttribute("queryString", qs.toString());
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {}
        }
        util.Page<Bus> pageInfo = new util.Page<>(buses, page, buses.size(), 10);
        int start = (page - 1) * 10;
        int end = Math.min(start + 10, buses.size());
        List<Bus> pagedList = buses.isEmpty() ? buses : buses.subList(start, end);

        request.setAttribute("buses", pagedList);
        request.setAttribute("currentPage", pageInfo.getCurrentPage());
        request.setAttribute("totalPages", pageInfo.getTotalPages());

        request.getRequestDispatcher("/view/staff/bus/bus-management.jsp")
                .forward(request, response);
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
        doGet(request, response);
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
