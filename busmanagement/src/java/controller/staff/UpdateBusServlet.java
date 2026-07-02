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
import model.Bus;
import service.BusService;

/**
 *
 * @author Administrator
 */
public class UpdateBusServlet extends HttpServlet {

    private BusService busService;

    @Override
    public void init() throws ServletException {
        busService = new BusService();
    }

    // doGet: Xử lý khi click vào từ danh sách để xem form cập nhật
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        try {
            int busId = Integer.parseInt(idStr);
            Bus bus = busService.getBusById(busId);

            if (bus == null) {
                request.getSession().setAttribute("msgError", "Không tìm thấy phương tiện này trong hệ thống!");
                response.sendRedirect(request.getContextPath() + "/staff/bus");
                return;
            }

            request.setAttribute("bus", bus);
            request.getRequestDispatcher("/view/staff/update-bus.jsp").forward(request, response);

        } catch (ServletException | IOException | NumberFormatException e) {
            request.getSession().setAttribute(
                    "msgError",
                    "ID phương tiện không hợp lệ!"
            );

            response.sendRedirect(
                    request.getContextPath() + "/staff/bus"
            );
        }
    }

    // doPost: Xử lý khi bấm nút "Lưu thay đổi"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String busType = request.getParameter("busType");
        String capacityStr = request.getParameter("capacity");
        String status = request.getParameter("status");

        try {
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Không tìm thấy ID phương tiện!");
            }
            if (capacityStr == null || capacityStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Sức chứa không được để trống!");
            }
            int busId = Integer.parseInt(idStr.trim());
            int capacity = Integer.parseInt(capacityStr.trim());

            // Gọi Service để update DB
            busService.updateBus(busId, busType, capacity, status);

            // Thành công
            request.getSession().setAttribute("msgSuccess", "Đã cập nhật thông tin phương tiện thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/bus");

        } catch (NumberFormatException e) {
            handleErrorState(request, response, idStr, busType, capacityStr, status, "Sức chứa phải là một số nguyên hợp lệ!");
        } catch (IllegalArgumentException e) {
            handleErrorState(request, response, idStr, busType, capacityStr, status, e.getMessage());
        } catch (Exception e) {
            handleErrorState(request, response, idStr, busType, capacityStr, status, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // Hàm phụ trợ: Giữ nguyên dữ liệu gõ dở khi có lỗi (State Retention)
    private void handleErrorState(
            HttpServletRequest request,
            HttpServletResponse response,
            String idStr,
            String busType,
            String capacityStr,
            String status,
            String errorMsg)
            throws ServletException, IOException {

        try {
            int busId = Integer.parseInt(idStr.trim());
            Bus currentBus = busService.getBusById(busId);

            if (currentBus != null) {
                currentBus.setBusType(busType);

                try {
                    currentBus.setCapacity(
                            Integer.parseInt(capacityStr.trim())
                    );
                } catch (NumberFormatException ignored) {
                }

                request.setAttribute("bus", currentBus);
            }

            request.setAttribute(
                    "selectedStatus",
                    status
            );

        } catch (NumberFormatException ignored) {
        } catch (Exception ignored) {
            
        }

        request.setAttribute(
                "msgError",
                errorMsg
        );

        request.getRequestDispatcher(
                "/view/staff/update-bus.jsp"
        ).forward(request, response);
    }
}
