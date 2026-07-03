/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.FavoriteDAO;
import dal.RouteDAO;
import dal.RouteStopDAO;
import dto.RouteStopDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Route;
import service.FavoriteService;

/**
 *
 * @author Administrator
 */
public class RouteDetailServlet extends HttpServlet {

    private RouteDAO routeDAO;
    private RouteStopDAO routeStopDAO;
    private FavoriteService favoriteService;

    @Override
    public void init() throws ServletException {
        routeDAO = new RouteDAO();
        routeStopDAO = new RouteStopDAO();
        favoriteService = new FavoriteService();
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
            String idRaw = request.getParameter("id");
            
            if (idRaw != null && !idRaw.trim().isEmpty()) {
                int routeId = Integer.parseInt(idRaw);
                
                Route route = routeDAO.getRouteById(routeId);
                List<RouteStopDTO> stops = routeStopDAO.getStopsByRoute(routeId);
                
                // LOGIC MỚI: Gọi qua Service
                boolean isFavorite = false;
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("USER") != null) {
                    Account user = (Account) session.getAttribute("USER");
                    isFavorite = favoriteService.isFavorite(user.getAccountID(), routeId);
                }
                
                request.setAttribute("route", route);
                request.setAttribute("stops", stops);
                request.setAttribute("isFavorite", isFavorite);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("view/route-detail.jsp").forward(request, response);
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
