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

        // 1. Đọc và xử lý tham số thời gian
        String period = request.getParameter("period");
        period = period == null ? "this_month" : period.trim().toLowerCase();

        if (!period.equals("today") && !period.equals("this_month")
                && !period.equals("last_month") && !period.equals("this_year")) {
            period = "this_month";
        }

        LocalDate now = LocalDate.now();
        LocalDate start = now.withDayOfMonth(1);
        LocalDate end = now.withDayOfMonth(now.lengthOfMonth());

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

        // 2. Đọc và Validate tham số Tuyến xe (Làm TRƯỚC khi gọi DAO)
        String routeIdParam = request.getParameter("routeId");
        if (routeIdParam == null || routeIdParam.isBlank()) {
            routeIdParam = "ALL";
        } else {
            routeIdParam = routeIdParam.trim();
        }

        RouteDAO routeDAO = new RouteDAO();
        if (!"ALL".equalsIgnoreCase(routeIdParam)) {
            try {
                int selectedRouteId = Integer.parseInt(routeIdParam);
                if (selectedRouteId <= 0) {
                    throw new NumberFormatException();
                }

                Route selectedRoute = routeDAO.getRouteById(selectedRouteId);
                if (selectedRoute == null) {
                    routeIdParam = "ALL"; // Tuyến không tồn tại thì reset về ALL
                }
            } catch (NumberFormatException e) {
                routeIdParam = "ALL";
            }
        }

        // 3. Gọi dữ liệu từ tầng DAO (SỬA Ở ĐÂY: Truyền thêm routeIdParam vào hàm)
        DashboardDAO dashboardDAO = new DashboardDAO();
        List<Map<String, Object>> data = dashboardDAO.getRevenueByRouteAndType(
                Date.valueOf(start),
                Date.valueOf(end),
                routeIdParam // Truyền tham số tuyến xuống SQL để lọc
        );

        // 4. Xây dựng mảng chuỗi dữ liệu cho đồ thị Chart.js
        StringBuilder labels = new StringBuilder("[");
        StringBuilder ticketData = new StringBuilder("[");
        StringBuilder passData = new StringBuilder("[");
        double totalTicket = 0;
        double totalRoutePass = 0;
        double totalInterRoutePass = 0;

        for (Map<String, Object> item : data) {
            String routeNumber = (String) item.get("route");

            double ticketRevenue
                    = ((Number) item.get("ticket")).doubleValue();

            double passRevenue
                    = ((Number) item.get("pass")).doubleValue();

            String safeRouteNumber = routeNumber
                    .replace("\\", "\\\\")
                    .replace("'", "\\'");

            labels.append("'")
                    .append(safeRouteNumber)
                    .append("',");

            ticketData.append(ticketRevenue).append(",");
            passData.append(passRevenue).append(",");

            totalTicket += ticketRevenue;

            if ("Liên Tuyến".equalsIgnoreCase(routeNumber)) {
                totalInterRoutePass += passRevenue;
            } else {
                totalRoutePass += passRevenue;
            }
        }

        double totalPass = totalRoutePass + totalInterRoutePass;

        // 5. Loại bỏ dấu phẩy thừa ở cuối phần tử
        if (!data.isEmpty()) {
            labels.setLength(labels.length() - 1);
            ticketData.setLength(ticketData.length() - 1);
            passData.setLength(passData.length() - 1);
        }
        labels.append("]");
        ticketData.append("]");
        passData.append("]");

        // 6. Đẩy toàn bộ dữ liệu sang giao diện hiển thị
        request.setAttribute("labels", labels.toString());
        request.setAttribute("ticketData", ticketData.toString());
        request.setAttribute("passData", passData.toString());

        request.setAttribute("totalTicket", totalTicket);
        request.setAttribute("totalRoutePass", totalRoutePass);
        request.setAttribute(
                "totalInterRoutePass",
                totalInterRoutePass
        );
        request.setAttribute("totalPass", totalPass);
        request.setAttribute(
                "totalAll",
                totalTicket + totalPass
        );

        request.setAttribute("selectedPeriod", period);
        request.setAttribute("selectedRoute", routeIdParam);

        Integer selectedRouteId = null;

        if (!"ALL".equalsIgnoreCase(routeIdParam)) {
            selectedRouteId = Integer.valueOf(routeIdParam);
        }

        request.setAttribute("selectedRouteId", selectedRouteId);
        request.setAttribute(
                "routes",
                routeDAO.getAllActiveRoutes()
        );

        request.getRequestDispatcher("/view/admin/revenue-report.jsp").forward(request, response);
    }
}
