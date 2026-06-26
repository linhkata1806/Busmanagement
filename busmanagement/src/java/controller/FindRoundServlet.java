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
public class FindRoundServlet extends HttpServlet {
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
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fromStopStr = request.getParameter("fromStopID");
        String toStopStr = request.getParameter("toStopID");

        List<Stop> allStops = stopDAO.getAllStops();
        request.setAttribute("stopNames", allStops);

        if (fromStopStr != null && toStopStr != null
                && !fromStopStr.isEmpty() && !toStopStr.isEmpty()) {

            try {

                int fromStopID = Integer.parseInt(fromStopStr);
                int toStopID = Integer.parseInt(toStopStr);

                if (fromStopID != toStopID) {

                    Stop fromStop = stopDAO.getStopById(fromStopID);
                    Stop toStop = stopDAO.getStopById(toStopID);

                    if (fromStop != null && toStop != null) {

                        request.setAttribute("selectedFrom", fromStop);
                        request.setAttribute("selectedTo", toStop);

                        List<Route> matchingRoutes
                                = routeDAO.findRoutesBetweenStops(fromStopID, toStopID);

                        request.setAttribute("matchingRoutes", matchingRoutes);

                    } else {
                        request.setAttribute("error", "Không tìm thấy điểm dừng.");
                    }
                } else {
                    request.setAttribute("error", "Điểm đi và điểm đến phải khác nhau.");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Dữ liệu không hợp lệ.");
            }
        }

        request.getRequestDispatcher("view/find-route.jsp")
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
