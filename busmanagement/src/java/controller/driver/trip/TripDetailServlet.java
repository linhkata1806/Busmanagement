package controller.driver.trip;

import dto.RouteStopDTO;
import dto.TripDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Trip;
import service.RouteStopService;
import service.TripService;
import service.NotificationService;

public class TripDetailServlet extends HttpServlet {

    private TripService tripService;
    private RouteStopService routeStopService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        routeStopService = new RouteStopService();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xác thực người dùng (Login Check)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account user = (Account) session.getAttribute("USER");
        int driverID = user.getAccountID();

        // 1. Kiểm tra tham số ID từ URL
        String tripIdParam = request.getParameter("id");
        if (tripIdParam == null || tripIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin. Vui lòng cung cấp mã chuyến xe.");
            forwardToView(request, response, driverID);
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIdParam);
            Trip trip = tripService.getTripById(tripID);

            // 2. Kiểm tra chuyến xe có tồn tại không
            if (trip == null) {
                request.setAttribute("errorMessage", "Chuyến xe này không tồn tại hoặc đã bị xóa.");
                forwardToView(request, response, driverID);
                return;
            }

            // 3. Kiểm tra thẩm quyền: Trip này có phải của Driver đang login không?
            if (trip.getDriverID() != driverID) {
                request.setAttribute("errorMessage", "Từ chối truy cập. Bạn không có quyền xem chuyến xe của tài xế khác.");
                forwardToView(request, response, driverID);
                return;
            }

            // Mọi validation đều pass -> Load DTO và list trạm dừng
            TripDTO tripDTO = tripService.getTripDTOByIDAndDriver(tripID, driverID);
            List<RouteStopDTO> routeStops = routeStopService.getStopsByRoute(trip.getRouteID());

            request.setAttribute("trip", tripDTO);
            request.setAttribute("routeStops", routeStops);

            forwardToView(request, response, driverID);

        } catch (NumberFormatException e) {
            // Xử lý khi user nhập linh tinh vào URL (ví dụ: ?id=abc)
            request.setAttribute("errorMessage", "Mã chuyến xe không hợp lệ.");
            forwardToView(request, response, driverID);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống trong quá trình tải dữ liệu.");
        }
    }

    // Hàm helper để tránh lặp lại code set Sidebar count và forward
    private void forwardToView(HttpServletRequest request, HttpServletResponse response, int driverID) throws ServletException, IOException {
        try {
            int unreadCount = notificationService.countUnreadByAccountAndRole(driverID, "DRIVER");
            request.setAttribute("unreadCount", unreadCount);
        } catch (Exception e) {
            // Fail-safe cho notification
            request.setAttribute("unreadCount", 0);
        }
        request.getRequestDispatcher("/view/driver/trip/trip-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
