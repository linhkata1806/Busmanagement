/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff.trip;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalTime;
import model.Trip;
import service.AccountService;
import service.BusService;
import service.RouteService;
import service.TripService;

/**
 *
 * @author Administrator
 */
public class UpdateTripServlet extends HttpServlet {

    private TripService tripService;
    private RouteService routeService;
    private BusService busService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        routeService = new RouteService();
        busService = new BusService();
        accountService = new AccountService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy ID chuyến xe cần sửa từ URL
            String idRaw = request.getParameter("id");

            if (idRaw == null || idRaw.trim().isEmpty()) {
                request.getSession().setAttribute("msgError", "Thiếu mã chuyến xe cần sửa.");
                response.sendRedirect(request.getContextPath() + "/staff/trip");
                return;
            }

            int tripID;

            try {
                tripID = Integer.parseInt(idRaw);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("msgError", "Mã chuyến xe không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/staff/trip");
                return;
            }
            Trip trip = tripService.getTripById(tripID); // Nếu TripDAO của bạn chưa có hàm getById thì bảo tớ nhé!

            if (trip == null) {
                request.getSession().setAttribute("msgError", "Chuyến xe không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/staff/trip");
                return;
            }

            // Gửi dữ liệu cũ của chuyến xe sang giao diện để đổ vào Form
            request.setAttribute("trip", trip);

            // Gửi dữ liệu cho các Dropdown
            request.setAttribute("routes", routeService.getAllActiveRoutes());
            request.setAttribute("buses", busService.getAllActiveBuses());
            request.setAttribute("drivers", accountService.getAccountsByRole(3));
            request.setAttribute("assistants", accountService.getAccountsByRole(4));

            request.getRequestDispatcher("/view/staff/trip/update-trip.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/trip");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String tripIDStr = request.getParameter("id");
        String routeIDStr = request.getParameter("routeID");
        String busIDStr = request.getParameter("busID");
        String driverIDStr = request.getParameter("driverID");
        String assistantIDStr = request.getParameter("assistantID");
        String tripDateStr = request.getParameter("tripDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String directionStr = request.getParameter("direction");
        String statusStr = request.getParameter("status"); // Khi sửa thì được phép đổi trạng thái

        try {
            int tripID = Integer.parseInt(tripIDStr);
            int routeID = Integer.parseInt(routeIDStr);
            int busID = Integer.parseInt(busIDStr);
            int driverID = Integer.parseInt(driverIDStr);
            Integer assistantID = (assistantIDStr == null || assistantIDStr.trim().isEmpty()) ? null : Integer.parseInt(assistantIDStr.trim());

            LocalDate tripDate = LocalDate.parse(tripDateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            int direction = Integer.parseInt(directionStr);

            // Gọi Service Update (Đã tích hợp sẵn mọi cơ chế bắt lỗi bên trong)
            tripService.updateTrip(tripID, routeID, busID, driverID, assistantID, tripDate, startTime, endTime, direction, statusStr);

            request.getSession().setAttribute("msgSuccess", "Đã cập nhật lịch trình chuyến xe #" + tripID + " thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/trip");

        } catch (IllegalArgumentException e) {
            request.setAttribute("msgError", e.getMessage());
            doGet(request, response);

        } catch (java.time.format.DateTimeParseException e) {
            request.setAttribute("msgError", "Dữ liệu ngày giờ hoặc mã số không hợp lệ!");
            doGet(request, response);

        } catch (Exception e) {
            request.setAttribute("msgError", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}
