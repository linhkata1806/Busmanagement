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

        // Phân trang
        int page = 1;
        int limit = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * limit;

        String keyword = request.getParameter("search");
        String role = request.getParameter("role");

        List<Account> accountList;
        int totalRecords = 0;
        StringBuilder queryString = new StringBuilder();

        if ((keyword != null && !keyword.isEmpty()) || (role != null && !role.isEmpty())) {
            // Nếu không lọc role cụ thể, ngầm định là ALL
            if (role == null || role.isEmpty()) {
                role = "ALL";
            }
            accountList = accountService.searchAndFilter(keyword, role, offset, limit);
            totalRecords = accountService.countSearchAndFilter(keyword, role);

            // Giữ lại từ khóa trên ô tìm kiếm
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("selectedRole", role);
            
            // Xây dựng query string để giữ tham số khi chuyển trang
            if (keyword != null && !keyword.isEmpty()) {
                queryString.append("search=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
            }
            if (role != null && !role.isEmpty()) {
                if (queryString.length() > 0) queryString.append("&");
                queryString.append("role=").append(java.net.URLEncoder.encode(role, "UTF-8"));
            }
        } else {
            accountList = accountService.getAllAccounts(offset, limit);
            totalRecords = accountService.countAllAccounts();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        request.setAttribute("accountList", accountList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("queryString", queryString.toString());
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
