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
import service.ReportService;

public class RevenueReportServlet extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Gọi Service lấy chuỗi JSON chứa dữ liệu doanh thu
        String chartDataJson = reportService.getRevenueReport();
        
        // Nạp data báo cáo tài chính lên request để chuyển sang View
        request.setAttribute("chartDataJson", chartDataJson);
        
        request.getRequestDispatcher("/view/admin/revenue-report.jsp").forward(request, response);
    }
}
