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
import model.Route;
import service.RouteService;

/**
 *
 * @author Administrator
 */
public class RouteViewServlet extends HttpServlet {

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
        try {
            // Lấy ID tuyến xe cần xem từ URL
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã định danh tuyến xe không hợp lệ.");
            }

            int routeID = Integer.parseInt(idStr.trim());
            Route route = routeService.getRouteById(routeID);

            if (route == null) {
                throw new IllegalArgumentException("Tuyến xe không tồn tại trên hệ thống.");
            }

            // Đẩy dữ liệu sang trang JSP xem chi tiết
            request.setAttribute("route", route);
            request.getRequestDispatcher("/view/staff/view-route.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/route");
        } catch (Exception e) {
            System.out.println("View Route Error: " + e.getMessage());
            request.getSession().setAttribute("msgError", "Hệ thống đang gặp sự cố.");
            response.sendRedirect(request.getContextPath() + "/staff/route");
        }
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
