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
import model.Account;
import service.AccountManagementService;

public class CreateAccountServlet extends HttpServlet {

    private AccountManagementService accountService;

    @Override
    public void init() throws ServletException {
        // Đã sửa thành đúng tên file Service dành riêng cho Admin
        accountService = new AccountManagementService();
    }

    // Chuyển hướng người dùng đến trang form tạo tài khoản
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/create-account.jsp").forward(request, response);
    }

    // Nhận dữ liệu từ form submit lên và xử lý nghiệp vụ
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("roleId");

        try {
            int roleId = Integer.parseInt(roleStr);
            String roleName = mapRoleName(roleId);

            // 2. Gói dữ liệu vào Model Account
            Account newAcc = new Account();
            newAcc.setUsername(username);
            newAcc.setPassword(password);
            newAcc.setFullName(fullName);
            newAcc.setEmail(email);
            newAcc.setPhone(phone);
            newAcc.setRoleID(roleId);

            // 3. Đẩy xuống Service xử lý
            boolean success = accountService.createAccount(newAcc, roleName);

            if (success) {
                // Áp dụng PRG: Redirect về trang danh sách và báo thành công
                session.setAttribute("successMsg", "Tạo tài khoản " + username + " thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
            } else {
                throw new Exception("Lỗi hệ thống khi lưu xuống Database.");
            }

        } catch (IllegalArgumentException e) {
            // Lỗi bảo mật (Cố tình tạo ADMIN)
            request.setAttribute("errorMsg", e.getMessage());
            keepFormData(request, username, fullName, email, phone);
            request.getRequestDispatcher("/view/admin/create-account.jsp").forward(request, response);

        } catch (Exception e) {
            // Lỗi trùng lặp dữ liệu (Username, Email, Phone) hoặc lỗi parse số
            request.setAttribute("errorMsg", "Không thể tạo tài khoản: " + e.getMessage());
            keepFormData(request, username, fullName, email, phone);
            request.getRequestDispatcher("/view/admin/create-account.jsp").forward(request, response);
        }
    }

    // Hàm tiện ích: Trả lại dữ liệu người dùng vừa nhập để họ không phải gõ lại từ đầu nếu bị lỗi form
    private void keepFormData(HttpServletRequest request, String user, String name, String email, String phone) {
        request.setAttribute("username", user);
        request.setAttribute("fullName", name);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }

    // Hàm phụ trợ: Ánh xạ cứng RoleID sang RoleName
    private String mapRoleName(int roleId) {
        switch (roleId) {
            case 1: return "ADMIN";
            case 2: return "STAFF";
            case 3: return "DRIVER";
            case 4: return "ASSISTANT";
            case 5: return "CUSTOMER";
            default: return "UNKNOWN";
        }
    }
}
