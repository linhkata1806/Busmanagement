package controller.staff.stop;

import controller.staff.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.StopService;

public class CreateStopServlet extends HttpServlet {
    private StopService stopService;

    @Override
    public void init() throws ServletException {
        stopService = new StopService();
    }

    // Hàm mở trang Form thêm mới
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/staff/stop/create-stop.jsp").forward(request, response);
    }

    // Hàm xử lý khi người dùng bấm Submit Form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String stopName = request.getParameter("stopName");
        String address = request.getParameter("address");
        String latStr = request.getParameter("latitude");
        String lngStr = request.getParameter("longitude");

        try {
            // Validate sơ bộ kiểu dữ liệu
            if (latStr == null || latStr.trim().isEmpty() || lngStr == null || lngStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng nhập đầy đủ tọa độ Kinh độ và Vĩ độ!");
            }

            double lat = Double.parseDouble(latStr.trim());
            double lng = Double.parseDouble(lngStr.trim());

            // Gọi Service để xử lý logic (Service đã bao bọc tất cả validate nghiệp vụ)
            stopService.createStop(stopName, address, lat, lng);

            // Báo thành công và đá về trang danh sách
            request.getSession().setAttribute("msgSuccess", "Đã thêm điểm dừng '" + stopName + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/stop");

        } catch (NumberFormatException e) {
            handleError(request, response, "Tọa độ (Kinh độ/Vĩ độ) phải là dạng số hợp lệ!", stopName, address, latStr, lngStr);
        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage(), stopName, address, latStr, lngStr);
        } catch (Exception e) {
            handleError(request, response, "Lỗi hệ thống: " + e.getMessage(), stopName, address, latStr, lngStr);
        }
    }

    // Hàm phụ trợ giúp hiển thị lại lỗi và giữ nguyên dữ liệu người dùng vừa nhập (State Retention)
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMsg, 
                             String stopName, String address, String lat, String lng) 
            throws ServletException, IOException {
        
        request.setAttribute("msgError", errorMsg);
        
        // Trả lại dữ liệu để ô input không bị trắng tinh sau khi lỗi
        request.setAttribute("stopName", stopName);
        request.setAttribute("address", address);
        request.setAttribute("latitude", lat);
        request.setAttribute("longitude", lng);
        
        request.getRequestDispatcher("/view/staff/stop/create-stop.jsp").forward(request, response);
    }
}