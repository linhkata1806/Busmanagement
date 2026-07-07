/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

/**
 *
 * @author ASUS
 */
import dto.DashboardDTO;
import service.DashboardService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminDashboardServlet extends HttpServlet {

    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        // Khởi tạo tầng Service đã làm ở phần 2
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Gọi Service lấy dữ liệu thống kê (trả về cục DashboardDTO)
        DashboardDTO dashboardData = dashboardService.getDashboardData();

        // 2. Đính kèm dữ liệu vào request để đẩy sang giao diện
        request.setAttribute("dashboardData", dashboardData);

        // 3. Chuyển hướng sang trang JSP (giao diện)
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}
