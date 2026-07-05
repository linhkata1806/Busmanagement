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
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("USER");
        int driverID = user.getAccountID();

        String tripIDStr = request.getParameter("tripID");
        if (tripIDStr == null || tripIDStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã chuyến xe.");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr);
            Trip trip = tripService.getTripById(tripID);

            if (trip == null) {
                session.setAttribute("error", "Chuyến xe không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/driver/dashboard");
                return;
            }

            // Security constraint: Check ownership
            if (trip.getDriverID() != driverID) {
                session.setAttribute("error", "Bạn không có quyền bắt đầu chuyến xe của nhân sự khác.");
                response.sendRedirect(request.getContextPath() + "/driver/dashboard");
                return;
            }

            driverTripService.startTrip(tripID);

            session.setAttribute("successMsg", "Bắt đầu chuyến đi #" + tripID + " thành công!");
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/driver/dashboard");
    }
}
