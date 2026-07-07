/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

/**
 *
 * @author ASUS
 */
import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.AccountManagementService;

public class UpdateAccountServlet extends HttpServlet {

    private AccountManagementService accountService;
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountService = new AccountManagementService();
        accountDAO = new AccountDAO(); // Dùng tạm DAO để truy vấn nhanh by ID
    }

    // Lấy thông tin tài khoản cũ đẩy lên Form giao diện
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        try {
            int accountId = Integer.parseInt(idParam);
            Account account = accountDAO.getAccountById(accountId);
            
            if (account != null) {
                request.setAttribute("account", account);
                request.getRequestDispatcher("/view/admin/update-account.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("errorMsg", "Không tìm thấy tài khoản!");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        }
    }

    // Nhận dữ liệu sau khi sửa và cập nhật xuống DB
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // Username readonly theo đặc tả nên không cần lấy từ form
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String avatar = request.getParameter("avatar"); 

            Account updatedAcc = new Account();
            updatedAcc.setAccountID(accountId);
            updatedAcc.setFullName(fullName);
            updatedAcc.setEmail(email);
            updatedAcc.setPhone(phone);
            updatedAcc.setAvatar(avatar);

            boolean success = accountService.updateAccount(updatedAcc);

            if (success) {
                session.setAttribute("successMsg", "Cập nhật thông tin thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
            } else {
                throw new Exception("Lỗi hệ thống khi cập nhật Database.");
            }

        } catch (Exception e) {
            session.setAttribute("errorMsg", "Cập nhật thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        }
    }
}
