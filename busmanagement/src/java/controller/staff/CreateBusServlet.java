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
public class CreateBusServlet extends HttpServlet {

    private BusService busService;

    @Override
    public void init() throws ServletException {
        busService = new BusService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng người dùng sang trang form đăng ký xe buýt mới
        request.getRequestDispatcher("/view/staff/create-bus.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String licensePlate = request.getParameter("licensePlate");
        String busType = request.getParameter("busType");
        String capacityStr = request.getParameter("capacity");

        // State Retention
        request.setAttribute("b_licensePlate", licensePlate);
        request.setAttribute("b_busType", busType);
        request.setAttribute("b_capacity", capacityStr);

        try {

            if (capacityStr == null || capacityStr.trim().isEmpty()) {
                throw new IllegalArgumentException(
                        "Sức chứa không được để trống.");
            }

            int capacity = Integer.parseInt(capacityStr.trim());

            // Mặc định tạo mới = ACTIVE
            busService.createBus(
                    licensePlate,
                    busType,
                    capacity
            );

            request.getSession().setAttribute(
                    "msgSuccess",
                    "Đã thêm phương tiện mới vào hệ thống thành công!"
            );

            response.sendRedirect(
                    request.getContextPath() + "/staff/bus"
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute("msgError", e.getMessage());
            doGet(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "msgError",
                    "Hệ thống đang gặp sự cố. Vui lòng thử lại sau."
            );

            doGet(request, response);
        }
    }

}
