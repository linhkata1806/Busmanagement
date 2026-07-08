package controller.admin;

import dal.DashboardDAO;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RevenueReportServlet extends HttpServlet {

    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Đọc tham số lọc từ request
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "this_month"; // Mặc định khi mới vào trang
        }

        LocalDate now = LocalDate.now();
        LocalDate start = now.withDayOfMonth(1); 
        LocalDate end = now.withDayOfMonth(now.lengthOfMonth());

        // 2. Tính toán khoảng ngày thực tế dựa trên lựa chọn
        if ("today".equals(period)) {
            start = now;
            end = now;
        } else if ("last_month".equals(period)) {
            start = now.minusMonths(1).withDayOfMonth(1);
            end = start.withDayOfMonth(start.lengthOfMonth());
        } else if ("this_year".equals(period)) {
            start = now.withDayOfYear(1);
            end = now;
        }

        // 3. Gọi dữ liệu từ tầng DAO
        List<Map<String, Object>> data = dashboardDAO.getRevenueByRouteAndType(Date.valueOf(start), Date.valueOf(end));

        // 4. Xây dựng mảng chuỗi dữ liệu cho đồ thị Chart.js
        StringBuilder labels = new StringBuilder("[");
        StringBuilder ticketData = new StringBuilder("[");
        StringBuilder passData = new StringBuilder("[");
        double totalTicket = 0;
        double totalPass = 0;

        for (Map<String, Object> item : data) {
            labels.append("'Tuyến ").append(item.get("route")).append("',");
            ticketData.append(item.get("ticket")).append(",");
            passData.append(item.get("pass")).append(",");
            totalTicket += (double) item.get("ticket");
            totalPass += (double) item.get("pass");
        }

        // Loại bỏ dấu phẩy thừa ở cuối phần tử
        if (!data.isEmpty()) {
            labels.setLength(labels.length() - 1);
            ticketData.setLength(ticketData.length() - 1);
            passData.setLength(passData.length() - 1);
        }
        labels.append("]");
        ticketData.append("]");
        passData.append("]");

        // 5. Đẩy toàn bộ dữ liệu thật sang giao diện hiển thị
        request.setAttribute("labels", labels.toString());
        request.setAttribute("ticketData", ticketData.toString());
        request.setAttribute("passData", passData.toString());
        request.setAttribute("totalTicket", totalTicket);
        request.setAttribute("totalPass", totalPass);
        request.setAttribute("totalAll", totalTicket + totalPass);
        request.setAttribute("selectedPeriod", period);

        request.getRequestDispatcher("/view/admin/revenue-report.jsp").forward(request, response);
    }
}