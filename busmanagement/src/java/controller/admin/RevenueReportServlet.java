package controller.admin;

import dal.DashboardDAO;
import dal.RouteDAO;
import model.Route;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Đọc tham số lọc từ request
        String period = request.getParameter("period");

        period = period == null
                ? "this_month"
                : period.trim().toLowerCase();

        if (!period.equals("today")
                && !period.equals("this_month")
                && !period.equals("last_month")
                && !period.equals("this_year")) {
            period = "this_month";
        }

        String routeIdParam = request.getParameter("routeId");

        if (routeIdParam == null || routeIdParam.isBlank()) {
            routeIdParam = "ALL";
        } else {
            routeIdParam = routeIdParam.trim();
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
        DashboardDAO dashboardDAO = new DashboardDAO();
        List<Map<String, Object>> data = dashboardDAO.getRevenueByRouteAndType(Date.valueOf(start), Date.valueOf(end));

        // 4. Lấy thông tin Tuyến lọc (nếu có)
        int selectedRouteId = -1;
        String selectedRouteNumber = null;
        RouteDAO routeDAO = new RouteDAO();

        if (!"ALL".equalsIgnoreCase(routeIdParam)) {
            try {
                selectedRouteId = Integer.parseInt(routeIdParam.trim());

                if (selectedRouteId <= 0) {
                    throw new NumberFormatException();
                }

                Route selectedRoute = routeDAO.getRouteById(selectedRouteId);

                if (selectedRoute != null) {
                    selectedRouteNumber = selectedRoute.getRouteNumber();
                    routeIdParam = String.valueOf(selectedRouteId);
                } else {
                    // ID la so nhung route khong ton tai
                    routeIdParam = "ALL";
                    selectedRouteId = -1;
                    selectedRouteNumber = null;
                }

            } catch (NumberFormatException e) {
                // ID null, khong phai so, so am hoac bang 0
                routeIdParam = "ALL";
                selectedRouteId = -1;
                selectedRouteNumber = null;
            }
        }

        // 5. Xây dựng mảng chuỗi dữ liệu cho đồ thị Chart.js
        StringBuilder labels = new StringBuilder("[");
        StringBuilder ticketData = new StringBuilder("[");
        StringBuilder passData = new StringBuilder("[");
        double totalTicket = 0;
        double totalPass = 0;
        boolean hasFilteredData = false;

        for (Map<String, Object> item : data) {
            String routeNumber = (String) item.get("route");
            if (selectedRouteNumber != null && !selectedRouteNumber.equals(routeNumber)) {
                continue; // Lọc bỏ tuyến không chọn
            }
            labels.append("'Tuyến ").append(routeNumber).append("',");
            ticketData.append(item.get("ticket")).append(",");
            passData.append(item.get("pass")).append(",");
            totalTicket += (double) item.get("ticket");
            totalPass += (double) item.get("pass");
            hasFilteredData = true;
        }

        // Loại bỏ dấu phẩy thừa ở cuối phần tử
        if (hasFilteredData) {
            labels.setLength(labels.length() - 1);
            ticketData.setLength(ticketData.length() - 1);
            passData.setLength(passData.length() - 1);
        }
        labels.append("]");
        ticketData.append("]");
        passData.append("]");

        // 6. Đẩy toàn bộ dữ liệu thật sang giao diện hiển thị
        request.setAttribute("labels", labels.toString());
        request.setAttribute("ticketData", ticketData.toString());
        request.setAttribute("passData", passData.toString());
        request.setAttribute("totalTicket", totalTicket);
        request.setAttribute("totalPass", totalPass);
        request.setAttribute("totalAll", totalTicket + totalPass);
        request.setAttribute("selectedPeriod", period);
        request.setAttribute("selectedRoute", routeIdParam);
        request.setAttribute("routes", routeDAO.getAllActiveRoutes());

        request.getRequestDispatcher("/view/admin/revenue-report.jsp").forward(request, response);
    }
}
