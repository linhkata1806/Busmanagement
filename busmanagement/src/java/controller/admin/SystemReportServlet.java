/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

/**
 *
 * @author ASUS
 */
import dal.DashboardDAO;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SystemReportServlet extends HttpServlet {

    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Gọi DAO lấy số liệu quy mô database
        Map<String, Integer> scaleMetrics = dashboardDAO.getDatabaseScaleMetrics();
        
        // 2. Đẩy dữ liệu sang trang JSP
        request.setAttribute("dbScale", scaleMetrics);
        
        // 3. Chuyển hướng sang giao diện tương ứng
        request.getRequestDispatcher("/view/admin/system-report.jsp").forward(request, response);
    }
}
