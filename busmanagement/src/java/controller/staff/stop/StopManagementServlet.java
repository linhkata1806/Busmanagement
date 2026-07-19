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
        
        // 1. Lấy tham số tìm kiếm và lọc từ UI (nếu có)
        String keyword = request.getParameter("search");
        String status = request.getParameter("status"); // ALL, ACTIVE, INACTIVE

        // 2. Gọi Service để lấy dữ liệu
        List<Stop> listStops = stopService.searchAndFilter(keyword, status);

        // Giữ lại trạng thái tìm kiếm trên giao diện
        request.setAttribute("search", keyword);
        request.setAttribute("status", status);

        StringBuilder qs = new StringBuilder();
        if (keyword != null && !keyword.isEmpty()) qs.append("search=").append(keyword).append("&");
        if (status != null && !status.isEmpty()) qs.append("status=").append(status).append("&");
        if (qs.length() > 0) {
            qs.deleteCharAt(qs.length() - 1);
            request.setAttribute("queryString", qs.toString());
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {}
        }
        util.Page<Stop> pageInfo = new util.Page<>(listStops, page, listStops.size(), 10);
        int start = (page - 1) * 10;
        int end = Math.min(start + 10, listStops.size());
        List<Stop> pagedList = listStops.isEmpty() ? listStops : listStops.subList(start, end);

        request.setAttribute("listStops", pagedList);
        request.setAttribute("currentPage", pageInfo.getCurrentPage());
        request.setAttribute("totalPages", pageInfo.getTotalPages());

        // 4. Chuyển hướng sang trang JSP
        request.getRequestDispatcher("/view/staff/stop/stop-management.jsp").forward(request, response);
    }
}