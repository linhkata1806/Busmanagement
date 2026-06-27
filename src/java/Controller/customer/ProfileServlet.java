/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import Util.Validator;
import dal.AccountDAO;
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
public class ProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;
//    private Validator validator;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
//        validator = new Validator();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");
        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");

        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String avatar = request.getParameter("avatar"); // Lưu dưới dạng URL ảnh

        //check email
        if (Validator.isValidEmail(email)) {
            request.setAttribute("errorMsg", "Định dạng email không hợp lệ.");
            doGet(request, response);
            return;
        }
        //check sdt
        if (Validator.isValidPhone(phone)) {
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ.");
            doGet(request, response);
            return;
        }
        if (!email.equalsIgnoreCase(user.getEmail())) {
            if (accountDAO.existsByEmail(email)) {
                request.setAttribute("errorMsg", "Cập nhật thất bại! Email này đã được sử dụng bởi một tài khoản khác.");
                doGet(request, response);
                return;
            }
        }
        // 2. Cập nhật vào Database
        boolean isSuccess = accountDAO.updateProfile(user.getAccountID(), fullName, email, phone, avatar);

        if (isSuccess) {
            Account updated = accountDAO.getAccountById(user.getAccountID());
            request.setAttribute("USER", updated);

            request.setAttribute("successMsg", "Cập nhật hồ sơ cá nhân thành công!");
        } else {
            request.setAttribute("errorMsg", "Cập nhật thất bại. Email hoặc Số điện thoại có thể đã được sử dụng.");
        }

        // 3. Render lại trang
        doGet(request, response);
    }
}
