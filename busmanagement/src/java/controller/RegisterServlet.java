/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import service.AuthService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author Administrator
 */
public class RegisterServlet extends HttpServlet {

    private AuthService AuthService;

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
        if (session != null && session.getAttribute("USER") != null) {

            response.sendRedirect("home");
            return;
        }

        request.getRequestDispatcher("view/register.jsp").forward(request, response);
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
        String username = request.getParameter("username");
        String pass = request.getParameter("password");
        String rePass = request.getParameter("repassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Validate an toàn (NullPointer Safe)
        if (pass == null || !pass.equals(rePass)) {
            forwardError(request, response, "Mật khẩu nhập lại không khớp!", username, fullName, email, phone);
            return;
        }
        
        Account acc = new Account();
        acc.setUsername(username);
        acc.setPassword(pass);
        acc.setFullName(fullName);
        acc.setEmail(email);
        acc.setPhone(phone);

        boolean isSuccess = AuthService.register(acc);

        if (isSuccess) {
            // Áp dụng PRG (Post-Redirect-Get)
            HttpSession session = request.getSession();
            session.setAttribute("success", "Đăng ký thành công, vui lòng đăng nhập!");
            response.sendRedirect("login");
        } else {
            forwardError(request, response, "Tên đăng nhập hoặc Email đã tồn tại!", username, fullName, email, phone);
        }
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

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String errMsg, String username, String fullName, String email, String phone) throws ServletException, IOException {
        request.setAttribute("error", errMsg);
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        
        request.getRequestDispatcher("view/register.jsp").forward(request, response);
    }

}
