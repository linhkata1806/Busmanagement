/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff.route;

import controller.staff.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Route;
import service.RouteService;

/**
 *
 * @author Administrator
 */
public class RouteManagementServlet extends HttpServlet {

    private RouteService routeService;

    @Override
    public void init() throws ServletException {
        routeService = new RouteService();
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

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Route> routes = routeService.searchAndFilter(keyword, status, offset, limit);
        int totalRecords = routeService.countSearchAndFilter(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        StringBuilder queryString = new StringBuilder();
        if (keyword != null && !keyword.isEmpty()) {
            queryString.append("keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        if (status != null && !status.isEmpty()) {
            if (queryString.length() > 0) queryString.append("&");
            queryString.append("status=").append(java.net.URLEncoder.encode(status, "UTF-8"));
        }

        // Xử lý để JSP không bị hiển thị chuỗi "null" vào ô input
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("status", status == null ? "ALL" : status);
        request.setAttribute("routes", routes);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("queryString", queryString.toString());

        request.getRequestDispatcher("/view/staff/route/route-management.jsp").forward(request, response);
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
