/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.authen;

import controller.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.AuthService;

/**
 *
 * @author Administrator
 */
public class LogOutServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
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
            out.println("<title>Servlet LogOutServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LogOutServlet at " + request.getContextPath () + "</h1>");
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
        // 1. Hủy Session trên Server
        HttpSession session = request.getSession(false);
        if (session != null) {
            Account user = (Account) session.getAttribute("USER");
            if (user != null) {
                // Xóa Token trong Database
                authService.clearRememberToken(user.getAccountID());
            }
            session.invalidate(); 
        }

        // 2. Xóa sạch sẽ các Cookies ở Client (Path chuẩn chỉnh)
        String contextPath = request.getContextPath();
        
        // delete JSESSIONID
        Cookie jsessionCookie = new Cookie("JSESSIONID", "");
        jsessionCookie.setMaxAge(0);
        jsessionCookie.setPath(contextPath);
        response.addCookie(jsessionCookie);

        // delete others cookes
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("REMEMBER_TOKEN") || cookie.getName().equals("username")) {
                    cookie.setValue("");
                    cookie.setMaxAge(0); 
                    cookie.setPath(contextPath); 
                    response.addCookie(cookie);
                }
            }
        }

        // 3. Chuyển hướng
        response.sendRedirect("login");
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
