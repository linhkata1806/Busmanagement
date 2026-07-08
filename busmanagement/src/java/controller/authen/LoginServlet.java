/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authen;

import controller.*;
import service.AuthService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author Administrator
 */
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
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
        HttpSession session = request.getSession(false);
        // Nếu người dùng đã đăng nhập (session khác null và USER khác null), chuyển hướng về home
        if (session != null && session.getAttribute("USER") != null) {
            response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            Account account = authService.login(user, pass);

            if (account != null) {
                // prevent Session Fixation Attack
                HttpSession oldSession = request.getSession(false);
                String redirectUrl = null;
                if (oldSession != null) {
                    redirectUrl = (String) oldSession.getAttribute("REDIRECT_URL");
                    oldSession.invalidate();
                }

                // start a new session
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("USER", account);
                if (redirectUrl != null) {
                    newSession.setAttribute("REDIRECT_URL", redirectUrl);
                }

                String remember = request.getParameter("remember");
                if ("on".equals(remember)) {
                    // Gọi Service sinh Token và lưu DB
                    String token = authService.generateAndSaveRememberToken(account.getAccountID());
                    if (token != null) {
                        Cookie cookie = new Cookie("REMEMBER_TOKEN", token);
                        cookie.setMaxAge(30 * 24 * 60 * 60); // Thời hạn 30 ngày (tính bằng giây)
                        cookie.setPath(request.getContextPath());
                        response.addCookie(cookie);
                    }
                }
                // perfomed navigation base on role
                switch (account.getRoleName()) {
                    case "ADMIN":
                        response.sendRedirect("admin/dashboard");
                        break;
                    case "STAFF":
                        response.sendRedirect("staff/dashboard");
                        break;
                    case "DRIVER":
                        response.sendRedirect("driver/dashboard");
                        break;
                    case "ASSISTANT":
                        response.sendRedirect("assistant/dashboard");
                        break;

                    default:
                        String targetUrl = (String) newSession.getAttribute("REDIRECT_URL");
                        if (targetUrl != null) {
                            newSession.removeAttribute("REDIRECT_URL");
                            response.sendRedirect(targetUrl);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/home");
                        }
                        break;
                }
            } else {
                request.setAttribute("error", "Đăng nhập thất bại. Vui lòng thử lại.");
                request.setAttribute("username", user);
                request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", user);
            request.getRequestDispatcher("view/authen/login.jsp").forward(request, response);
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

}
