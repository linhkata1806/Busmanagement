package controller.driver;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;
import model.Trip;
import service.DriverTripService;
import service.TripService;

public class StartTripServlet extends HttpServlet {

    private DriverTripService driverTripService;
    private TripService tripService;

    @Override
    public void init() throws ServletException {
        driverTripService = new DriverTripService();
        tripService = new TripService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // ... [Check auth giữ nguyên] ...

        Account user = (Account) session.getAttribute("USER");
        int driverID = user.getAccountID();
        String tripIDStr = request.getParameter("tripID");

        if (tripIDStr == null || tripIDStr.trim().isEmpty()) {
            session.setAttribute("error", "Thiếu mã chuyến xe.");
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr);

            // Chuyển toàn bộ logic kiểm tra vào Service
            driverTripService.startTrip(tripID, driverID);

            session.setAttribute("successMsg", "Bắt đầu chuyến đi #" + tripID + " thành công!");
        } catch (Exception e) {
            // Bắt trúng các thông báo lỗi từ Service (Chưa tới giờ, Đã lỡ chuyến, v.v.)
            session.setAttribute("error", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/driver/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/driver/dashboard");
    }
}
