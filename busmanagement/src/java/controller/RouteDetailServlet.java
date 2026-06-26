/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.RouteDAO;
import dal.StopDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Route;
import model.Stop;

/**
 *
 * @author Administrator
 */
public class RouteDetailServlet extends HttpServlet {
    
    private RouteDAO routeDAO;
    private StopDAO stopDAO;

    @Override
    public void init() throws ServletException {
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
        try {
            // 1. Lấy ID tuyến xe từ URL
            String idRaw = request.getParameter("id");
            
            if (idRaw != null && !idRaw.trim().isEmpty()) {
                int routeId = Integer.parseInt(idRaw);
                
                // 2. Gọi DAO lấy thông tin tuyến và danh sách trạm dừng
                Route route = routeDAO.getRouteById(routeId);
                List<Stop> stops = stopDAO.getStopsByRouteId(routeId);
                
                // 3. Đẩy dữ liệu sang trang JSP
                request.setAttribute("route", route);
                request.setAttribute("stops", stops);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // 4. Chuyển hướng sang giao diện xem chi tiết
        request.getRequestDispatcher("view/route-detail.jsp").forward(request, response);
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
