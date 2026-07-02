/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.BusService;

/**
 *
 * @author Administrator
 */
public class DeleteBusServlet extends HttpServlet {

    private BusService busService;

    @Override
    public void init() throws ServletException {
        busService = new BusService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        try {
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Không tìm thấy mã phương tiện cần xóa!");
            }

            int busId = Integer.parseInt(idStr.trim());

            // Gọi Service nâng cấp theo cách 2
            String result = busService.deleteBus(busId);

            // Xử lý thông báo thông minh dựa trên kết quả trả về
            if ("DELETED".equals(result)) {
                request.getSession().setAttribute("msgSuccess", "Đã xóa hoàn toàn phương tiện khỏi hệ thống thành công!");
            } else if ("INACTIVATED".equals(result)) {
                // Đẩy vào msgInfo (màu xanh dương) thay vì màu xanh lá, thể hiện đây là một thông tin cảnh báo nghiệp vụ thành công
                request.getSession().setAttribute("msgInfo", "Phương tiện này đã từng vận hành (có chuyến đi) nên hệ thống đã tự động chuyển sang trạng thái [Ngừng hoạt động - INACTIVE] để lưu lại lịch sử dữ liệu!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("msgError", "Mã phương tiện không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("msgError", "Lỗi hệ thống khi xóa: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/staff/bus");
    }
}
