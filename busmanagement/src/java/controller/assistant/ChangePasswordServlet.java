package controller.assistant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;
import service.AuthService;
import util.Validator;

public class ChangePasswordServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/assistant/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

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
            session.setAttribute("successMsg", "Đổi mật khẩu thành công. Hãy dùng mật khẩu mới cho lần đăng nhập sau!");
            response.sendRedirect(request.getContextPath() + "/assistant/profile");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMsg", e.getMessage());
            doGet(request, response);
        }
    }
}
