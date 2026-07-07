/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author ASUS
 */
import dal.DashboardDAO;

public class ReportService {

    private DashboardDAO dashboardDAO;

    public ReportService() {
        this.dashboardDAO = new DashboardDAO();
    }

    // Trả về định dạng JSON chuẩn để dùng luôn cho thư viện Chart.js ở JSP
    public String getRevenueReport() {
        double todayRevenue = dashboardDAO.getTodayRevenue();

        // Chuỗi JSON cấu trúc sẵn cho Chart.js (Bar chart hoặc Line chart)
        String json = "{ "
                + "\"labels\": [\"Hôm nay\"], "
                + "\"datasets\": [{ "
                + "    \"label\": \"Doanh thu (VNĐ)\", "
                + "    \"data\": [" + todayRevenue + "], "
                + "    \"backgroundColor\": \"rgba(54, 162, 235, 0.5)\", "
                + "    \"borderColor\": \"rgba(54, 162, 235, 1)\", "
                + "    \"borderWidth\": 1 "
                + "}] "
                + "}";

        return json;
    }
}
