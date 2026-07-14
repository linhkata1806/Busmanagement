package controller.staff.stop;

import controller.staff.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Stop;
import service.StopService;

public class StopManagementServlet extends HttpServlet {
    private StopService stopService;

    @Override
    public void init() throws ServletException {
        stopService = new StopService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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

        // 1. Lấy tham số tìm kiếm và lọc từ UI (nếu có)
        String keyword = request.getParameter("search");
        String status = request.getParameter("status"); // ALL, ACTIVE, INACTIVE

        // 2. Gọi Service để lấy dữ liệu
        List<Stop> listStops = stopService.searchAndFilter(keyword, status, offset, limit);
        int totalRecords = stopService.countSearchAndFilter(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        StringBuilder queryString = new StringBuilder();
        if (keyword != null && !keyword.isEmpty()) {
            queryString.append("search=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        if (status != null && !status.isEmpty()) {
            if (queryString.length() > 0) queryString.append("&");
            queryString.append("status=").append(java.net.URLEncoder.encode(status, "UTF-8"));
        }

        // 3. Đẩy dữ liệu ra view
        request.setAttribute("listStops", listStops);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("queryString", queryString.toString());
        
        // Giữ lại trạng thái tìm kiếm trên giao diện
        request.setAttribute("search", keyword == null ? "" : keyword);
        request.setAttribute("status", status == null ? "ALL" : status);

        // 4. Chuyển hướng sang trang JSP
        request.getRequestDispatcher("/view/staff/stop/stop-management.jsp").forward(request, response);
    }
}