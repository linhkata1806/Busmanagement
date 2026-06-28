/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dto.MonthlyPassDTO;
import dto.TicketDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import service.MonthlyPassService;
import service.TicketService;

/**
 *
 * @author Administrator
 */
public class TicketServlet extends HttpServlet {

    private TicketService ticketService;
    private MonthlyPassService monthlyPassService;

    @Override
    public void init() throws ServletException {
        ticketService = new TicketService();
        monthlyPassService = new MonthlyPassService();
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
        HttpSession session = request.getSession(false);
        String tab = request.getParameter("tab");
        Account user = (Account) session.getAttribute("USER");
        int accountID = user.getAccountID();
        if(tab==null){
            tab="ticket";
        }
        //service lay du lieu tu DTO
        List<TicketDTO> ticketList = ticketService.getTicketsByAccount(accountID);
        List<MonthlyPassDTO> routePassList = monthlyPassService.getRoutePasses(accountID);
        List<MonthlyPassDTO> allRoutePassList = monthlyPassService.getAllRoutePasses(accountID);

        //SET DTO trong request
        request.setAttribute("activeTab", tab);
        request.setAttribute("ticketList", ticketList);
        request.setAttribute("routePassList", routePassList);
        request.setAttribute("allRoutePassList", allRoutePassList);
        request.getRequestDispatcher("/view/customer/ticket.jsp").forward(request, response);
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
