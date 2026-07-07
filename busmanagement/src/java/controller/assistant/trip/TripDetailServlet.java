package controller.assistant.trip;

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

public class TripDetailServlet extends HttpServlet {
    private TripService tripService;
    private RouteStopService routeStopService;

    @Override
    public void init() throws ServletException {
        tripService = new TripService();
        routeStopService = new RouteStopService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (Account) session.getAttribute("USER");
        int assistantID = user.getAccountID();

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã chuyến xe.");
            return;
        }

        try {
            int tripID = Integer.parseInt(idStr);

            // Lấy Trip model để kiểm tra quyền sở hữu (chứa assistantID)
            Trip trip = tripService.getTripById(tripID);

            if (trip == null) {
                throw new IllegalArgumentException("Chuyến xe không tồn tại.");
            }

            // Security constraint: AssistantID == CurrentUserID
            if (trip.getAssistantID() == null || trip.getAssistantID() != assistantID) {
                throw new IllegalArgumentException("Bạn không có quyền truy cập thông tin chuyến xe của nhân sự khác.");
            }

            // Lấy TripDTO (đã JOIN) để hiển thị tên tuyến, biển số xe, tên lái xe
            TripDTO tripDTO = tripService.getTripDTOById(tripID);

            List<RouteStopDTO> routeStops = routeStopService.getStopsByRoute(trip.getRouteID());

            // Truyền cả trip (cho tripID/status/ngày) và tripDTO (cho route name, bus plate)
            request.setAttribute("trip", trip);
            request.setAttribute("tripDTO", tripDTO);
            request.setAttribute("routeStops", routeStops);

            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
