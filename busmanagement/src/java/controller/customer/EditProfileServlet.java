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
import util.Validator;

/**
 *
 * @author Administrator
 */
public class EditProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
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
        Account user = (Account) session.getAttribute("USER");

        // Luôn bốc dữ liệu mới nhất từ DB lên để điền vào Form cho chuẩn xác
        Account account = accountDAO.getAccountById(user.getAccountID());

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("account", account);
        request.getRequestDispatcher("/view/customer/edit-profile.jsp").forward(request, response);
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

        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");

        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String avatar = request.getParameter("avatar").trim(); // Tạm dùng URL string theo yêu cầu

        // 2. Validate dữ liệu đầu vào (Sử dụng Validator của bạn)
        if (Validator.isBlank(fullName)) {
            request.setAttribute("errorMsg", "Họ tên không được để trống.");
            doGet(request, response);
            return;
        }
        if (!Validator.isValidEmail(email)) {
            request.setAttribute("errorMsg", "Định dạng email không hợp lệ.");
            doGet(request, response);
            return;
        }

        if (!Validator.isValidPhone(phone)) {
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ (cần 10 số, bắt đầu bằng 0).");
            doGet(request, response);
            return;
        }

        // 3. Check trùng Email (Chỉ check nếu khách hàng thực sự thay đổi email)
        if (!email.equalsIgnoreCase(user.getEmail())) {
            if (accountDAO.existsByEmail(email)) {
                request.setAttribute("errorMsg", "Email này đã được sử dụng bởi một tài khoản khác!");
                doGet(request, response);
                return;
            }
        }

        // 4. Gọi DAO cập nhật xuống DB
        boolean isSuccess = accountDAO.updateProfile(user.getAccountID(), fullName, email, phone, avatar);

        if (isSuccess) {
            // CỰC KỲ QUAN TRỌNG: Cập nhật lại Session USER để đồng bộ Tên/Avatar trên góc phải màn hình
            Account updatedAccount = accountDAO.getAccountById(user.getAccountID());
            session.setAttribute("USER", updatedAccount);

            // Đính kèm thông báo thành công vào session (Flash message)
            session.setAttribute("successMsg", "Cập nhật hồ sơ thành công!");

            // Dùng sendRedirect (Thay vì forward) để chặn lỗi "Submit lại form (F5)"
            response.sendRedirect(request.getContextPath() + "/customer/profile");

        } else {
            // Lỗi hệ thống SQL ngầm
            request.setAttribute("errorMsg", "Hệ thống đang bận. Cập nhật thất bại!");
            doGet(request, response);
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
