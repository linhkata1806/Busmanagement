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

public class ProfileServlet extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Kiểm tra xem đã đăng nhập chưa
        if (session != null && session.getAttribute("USER") != null) {
            Account loggedInUser = (Account) session.getAttribute("USER");
            
            // Lấy lại thông tin mới nhất từ Database để đảm bảo dữ liệu không bị cũ
            Account currentProfile = accountDAO.getAccountById(loggedInUser.getAccountID());
            
            request.setAttribute("profile", currentProfile);
        }
        
        // Forward sang trang cá nhân của Admin
        request.getRequestDispatcher("/view/admin/profile.jsp").forward(request, response);
    }
}