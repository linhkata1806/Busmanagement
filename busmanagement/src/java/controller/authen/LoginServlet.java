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
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        Account account = authService.login(user, pass);

        if (account != null) {
            // prevent Session Fixation Attack
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // start a new session
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("USER", account);

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
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập, email,mật khẩu không đúng hoặc tài khoản bị khóa!");
            request.setAttribute("username", user);
            request.getRequestDispatcher("view/login.jsp").forward(request, response);
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
