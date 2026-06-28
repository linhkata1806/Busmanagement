/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.AuthService;
import util.Validator;

/**
 *
 * @author Administrator
 */
public class ChangePasswordServlet extends HttpServlet {

    private AccountDAO accountDAO;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
        authService = new AuthService();
    }

    // ==========================================
    // GET: CHỈ HIỂN THỊ FORM
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/customer/change-password.jsp").forward(request, response);
    }

    // ==========================================
    // POST: XỬ LÝ ĐỔI MẬT KHẨU
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // B2. Lấy Account từ Session
        HttpSession session = request.getSession(false);

        Account user = (Account) session.getAttribute("USER");

        // B1. Lấy dữ liệu
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // B2. Validate cơ bản (Chỉ check định dạng)
        if (!Validator.isValidPassword(oldPassword) || !Validator.isValidPassword(newPassword)) {
            request.setAttribute("errorMsg", "Mật khẩu phải từ 6 đến 50 ký tự và không được để trống.");
            doGet(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp với mật khẩu mới.");
            doGet(request, response);
            return;
        }

        if (newPassword.equals(oldPassword)) {
            request.setAttribute("errorMsg", "Mật khẩu mới không được trùng với mật khẩu hiện tại.");
            doGet(request, response);
            return;
        }

        try {
            authService.changePassword(user.getAccountID(), oldPassword, newPassword);

            // Nếu code chạy được đến đây nghĩa là KHÔNG CÓ LỖI NÀO BỊ NÉM RA -> THÀNH CÔNG
            session.setAttribute("successMsg", "Đổi mật khẩu thành công. Hãy dùng mật khẩu mới cho lần đăng nhập sau!");
            response.sendRedirect(request.getContextPath() + "/customer/profile");

        } catch (IllegalArgumentException e) {
            // Lỗi do người dùng nhập sai mật khẩu cũ
            request.setAttribute("errorMsg", e.getMessage());
            doGet(request, response);

        } catch (Exception e) {
            // Lỗi do hệ thống (Database sập, Không tìm thấy Account...)
            request.setAttribute("errorMsg", e.getMessage());
            doGet(request, response);
        }
    }
}
