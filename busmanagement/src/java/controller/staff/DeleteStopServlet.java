package controller.staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.StopService;

public class DeleteStopServlet extends HttpServlet {
    private StopService stopService;

    @Override
    public void init() throws ServletException {
        stopService = new StopService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");

        try {
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Không tìm thấy mã điểm dừng cần xóa!");
            }

            int stopId = Integer.parseInt(idStr.trim());
            
            // Gọi Service và hứng kết quả phân luồng Soft/Hard Delete
            String result = stopService.deleteStop(stopId);

            if ("DELETED".equals(result)) {
                // Xóa vật lý thành công (Xanh lá)
                request.getSession().setAttribute("msgSuccess", "Đã xóa vật lý điểm dừng khỏi hệ thống thành công!");
            } else if ("INACTIVATED".equals(result)) {
                // Đang vướng Route_Stop nên đổi trạng thái (Xanh dương)
                request.getSession().setAttribute("msgInfo", "Điểm dừng đang được sử dụng trong tuyến xe nên hệ thống đã tự động chuyển sang trạng thái INACTIVE (Ngừng hoạt động) để bảo toàn dữ liệu lịch sử.");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("msgError", "Mã điểm dừng không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("msgError", "Lỗi hệ thống khi xóa: " + e.getMessage());
        }

        // Dù thành công hay thất bại cũng đá về trang danh sách để load lại dữ liệu mới nhất
        response.sendRedirect(request.getContextPath() + "/staff/stop");
    }
}