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
import service.RouteStopService;

/**
 *
 * @author Administrator
 */
public class AddStopToRouteServlet extends HttpServlet {

    private RouteStopService routeStopService;

    @Override
    public void init() throws ServletException {
        routeStopService = new RouteStopService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String routeIdStr = request.getParameter("routeId");
        String stopIdStr = request.getParameter("stopId");
        String positionStr = request.getParameter("position");
        String distanceStr = request.getParameter("distance"); // BỔ SUNG: Khoảng cách từ điểm đầu

        try {
            int routeId = Integer.parseInt(routeIdStr.trim());
            int stopId = Integer.parseInt(stopIdStr.trim());
            int position = Integer.parseInt(positionStr.trim());
            double distance = (distanceStr != null && !distanceStr.trim().isEmpty())
                    ? Double.parseDouble(distanceStr.trim()) : 0.0; // BỔ SUNG

            // Gọi Service xử lý Transaction thêm trạm
            routeStopService.addStopToRoute(routeId, stopId, position, distance);

            request.getSession().setAttribute("msgSuccess", "Đã thêm điểm dừng mới vào tuyến thành công!");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("msgError", "Dữ liệu đầu vào (Tuyến, Trạm, Vị trí, Khoảng cách) phải là số hợp lệ.");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("msgError", e.getMessage()); // Hiển thị lỗi do validate Service
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msgError", "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
        }

        // Redirect về lại trang quản lý của chính Route đó
        response.sendRedirect(request.getContextPath() + "/staff/route-stop?routeId=" + routeIdStr);
    }
}
