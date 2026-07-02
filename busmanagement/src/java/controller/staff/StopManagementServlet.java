package controller.staff;

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

        // 3. Đẩy dữ liệu ra view
        request.setAttribute("listStops", listStops);
        
        // Giữ lại trạng thái tìm kiếm trên giao diện
        request.setAttribute("search", keyword);
        request.setAttribute("status", status);

        // 4. Chuyển hướng sang trang JSP
        request.getRequestDispatcher("/view/staff/stop-management.jsp").forward(request, response);
    }
}