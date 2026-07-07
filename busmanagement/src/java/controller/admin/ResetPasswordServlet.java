/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

/**
 *
 * @author ASUS
 */
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.AccountManagementService;

public class ResetPasswordServlet extends HttpServlet {

    private AccountManagementService accountService;

    @Override
    public void init() throws ServletException {
        accountService = new AccountManagementService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        try {
            int accountId = Integer.parseInt(idParam);
            
            // Gọi Service xử lý gán chuỗi Bus@Year và mã hóa BCrypt
            boolean success = accountService.resetPassword(accountId);

            if (success) {
                session.setAttribute("successMsg", "Đã reset mật khẩu thành công về mặc định!");
            } else {
                session.setAttribute("errorMsg", "Reset mật khẩu thất bại. Hệ thống gặp lỗi.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "ID tài khoản không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }
}
