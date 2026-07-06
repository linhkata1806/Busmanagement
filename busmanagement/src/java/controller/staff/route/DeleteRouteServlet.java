package controller.staff.route;

import controller.staff.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RouteService;

public class DeleteRouteServlet extends HttpServlet {

    private RouteService routeService;

    @Override
    public void init() throws ServletException {
        routeService = new RouteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().setAttribute("msgError", "Thao tác không hợp lệ! Xóa hoặc ngừng hoạt động tuyến xe phải thực hiện qua nút bấm trên giao diện.");
        response.sendRedirect(request.getContextPath() + "/staff/route");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int routeID = Integer.parseInt(request.getParameter("id"));

            routeService.deleteRoute(routeID);

            request.getSession().setAttribute("msgSuccess", "Đã xóa vĩnh viễn tuyến xe khỏi hệ thống thành công!");

        } catch (IllegalArgumentException e) {
            // BẮT LỖI NGHIỆP VỤ:
            // Sẽ rơi vào đây nếu Tuyến không tồn tại, HOẶC Tuyến đã bị tự động chuyển sang INACTIVE do có Trip (Soft Delete)
            // Lấy trực tiếp thông báo lỗi từ tầng Service hiển thị lên màn hình (màu đỏ)
            request.getSession().setAttribute("msgError", e.getMessage());

        } catch (Exception e) {
            // BẮT LỖI HỆ THỐNG: Ẩn lỗi SQL khóa ngoại, chỉ ghi log console cho Dev
            System.out.println("Delete Route Error: " + e.getMessage());
            request.getSession().setAttribute("msgError", "Hệ thống đang gặp sự cố cơ sở dữ liệu. Vui lòng thử lại sau.");
        }

        // 4. Luôn redirect về trang  tuyến đường sau khi thao tác xong
        response.sendRedirect(request.getContextPath() + "/staff/route");
    }
}