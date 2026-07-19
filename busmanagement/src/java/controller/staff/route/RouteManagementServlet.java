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
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Route> routes = routeService.searchAndFilter(keyword, status);

        // Xử lý để JSP không bị hiển thị chuỗi "null" vào ô input
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("status", status == null ? "ALL" : status);
        
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
        util.Page<Route> pageInfo = new util.Page<>(routes, page, routes.size(), 10);
        int start = (page - 1) * 10;
        int end = Math.min(start + 10, routes.size());
        List<Route> pagedList = routes.isEmpty() ? routes : routes.subList(start, end);

        request.setAttribute("routes", pagedList);
        request.setAttribute("currentPage", pageInfo.getCurrentPage());
        request.setAttribute("totalPages", pageInfo.getTotalPages());

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
