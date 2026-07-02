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
import java.time.LocalDate;
import java.time.LocalTime;
import service.AccountService;
import service.BusService;
import service.RouteService;
import service.TripService;

/**
 *
 * @author Administrator
 */
public class CreateTripServlet extends HttpServlet {

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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("routes", routeService.getAllActiveRoutes());
        request.setAttribute("routes", routeService.getAllActiveRoutes());
        request.setAttribute("buses", busService.getAllActiveBuses());
        request.setAttribute("drivers", accountService.getAccountsByRole(3));    // RoleID 3 là Tài xế
        request.setAttribute("assistants", accountService.getAccountsByRole(4)); // RoleID 4 là Phụ xe

        request.getRequestDispatcher("/view/staff/create-trip.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Nhận dữ liệu gốc dưới dạng String để giữ trạng thái 
        String routeIDStr = request.getParameter("routeID");
        String busIDStr = request.getParameter("busID");
        String driverIDStr = request.getParameter("driverID");
        String assistantIDStr = request.getParameter("assistantID");
        String tripDateStr = request.getParameter("tripDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String directionStr = request.getParameter("direction");

        // Đẩy lại toàn bộ dữ liệu vào Request để giao diện JSP không bị trắng form
        request.setAttribute("r_routeID", routeIDStr);
        request.setAttribute("r_busID", busIDStr);
        request.setAttribute("r_driverID", driverIDStr);
        request.setAttribute("r_assistantID", assistantIDStr);
        request.setAttribute("r_tripDate", tripDateStr);
        request.setAttribute("r_startTime", startTimeStr);
        request.setAttribute("r_endTime", endTimeStr);
        request.setAttribute("r_direction", directionStr);

        try {
            // 2. Parse dữ liệu (Có thể văng NumberFormatException hoặc DateTimeParseException)
            int routeID = Integer.parseInt(routeIDStr);
            int busID = Integer.parseInt(busIDStr);
            int driverID = Integer.parseInt(driverIDStr);
            Integer assistantID = (assistantIDStr == null || assistantIDStr.trim().isEmpty()) ? null : Integer.parseInt(assistantIDStr.trim());

            LocalDate tripDate = LocalDate.parse(tripDateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);
            int direction = Integer.parseInt(directionStr);

            // 3. Gọi Service (Không dùng boolean nữa)
            tripService.createTrip(routeID, busID, driverID, assistantID, tripDate, startTime, endTime, direction);

            // 4. Nếu code chạy qua dòng trên mà không văng lỗi => Thành công 100%
            request.getSession().setAttribute("msgSuccess", "Đã thêm chuyến xe mới vào lịch trình thành công!");
            response.sendRedirect(request.getContextPath() + "/staff/trip");

        } catch (IllegalArgumentException e) {
            // Bắt lỗi NGHIỆP VỤ (Business Logic Error)
            request.setAttribute("msgError", e.getMessage());
            doGet(request, response);

        } catch (Exception e) {
            // Bắt lỗi HỆ THỐNG (Database chết, NullPointer...)
            request.setAttribute("msgError", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}
