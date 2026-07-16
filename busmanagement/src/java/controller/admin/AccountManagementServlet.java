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
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import service.AccountManagementService;

public class AccountManagementServlet extends HttpServlet {

    private AccountManagementService accountService;

    @Override
    public void init() throws ServletException {
        accountService = new AccountManagementService();
    }

    // Xử lý luồng hiển thị danh sách, tìm kiếm và lọc (Yêu cầu 2)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("search");
        String role = request.getParameter("role");

        List<Account> accountList;

        if ((keyword != null && !keyword.isEmpty()) || (role != null && !role.isEmpty())) {
            // Nếu không lọc role cụ thể, ngầm định là ALL
            if (role == null || role.isEmpty()) {
                role = "ALL";
            }
            accountList = accountService.searchAndFilter(keyword, role);

            // Giữ lại từ khóa trên ô tìm kiếm
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("selectedRole", role);
        } else {
            accountList = accountService.getAllAccounts();
        }

        request.setAttribute("accountList", accountList);
        request.getRequestDispatcher("/view/admin/account-management.jsp").forward(request, response);
    }

    // Xử lý luồng Khóa / Mở khóa tài khoản (Yêu cầu 1 - Dùng PRG Pattern)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        try {
            int accountId = Integer.parseInt(idParam);
            boolean success = false;

            if ("lock".equals(action)) {
                success = accountService.lockAccount(accountId);
                if (success) {
                    session.setAttribute("successMsg", "Đã khóa tài khoản thành công!");
                }

            } else if ("unlock".equals(action)) {
                success = accountService.unlockAccount(accountId);
                if (success) {
                    session.setAttribute("successMsg", "Đã mở khóa tài khoản thành công!");
                }
            }

            if (!success) {
                session.setAttribute("errorMsg", "Thao tác thất bại. Vui lòng thử lại!");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "ID tài khoản không hợp lệ!");
        }

        // Chặn lỗi double-submit (F5) bằng sendRedirect
        response.sendRedirect(request.getContextPath() + "/admin/accounts");

    }

    // --- CÁC HÀM TIỆN ÍCH KIỂM TRA (VALIDATION) ---
    private boolean isValidPhone(String phone) {
        // Trả về true nếu chuỗi bắt đầu bằng 0 và có tổng cộng 10 chữ số
        return phone != null && phone.matches("^0\\d{9}$");
    }

    private boolean isValidEmail(String email) {
        // Trả về true nếu đúng định dạng email chuẩn
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
}
