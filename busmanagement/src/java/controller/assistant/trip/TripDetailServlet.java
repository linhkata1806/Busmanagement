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
        
        // 1. VÁ LỖI THIẾU ID TỪ URL (Thay thế sendError)
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu thông tin mã chuyến xe. Vui lòng chọn lại từ danh sách.");
            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
            return;
        }

        try {
            int tripID = Integer.parseInt(idStr);

            // Lấy Trip model để kiểm tra quyền sở hữu (chứa assistantID)
            Trip trip = tripService.getTripById(tripID);

            if (trip == null) {
                throw new IllegalArgumentException("Chuyến xe không tồn tại hoặc đã bị xóa khỏi hệ thống.");
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
            
        } catch (NumberFormatException e) {
            // 2. VÁ LỖI NHẬP CHỮ VÀO URL (VD: ?id=abc)
            request.setAttribute("error", "Mã chuyến xe không đúng định dạng. Hệ thống từ chối truy cập.");
            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // 3. VÁ LỖI 500 (Ném lỗi hệ thống ra giao diện thay vì sendError)
            request.setAttribute("error", "Hệ thống đang gặp sự cố trong quá trình tải dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/assistant/trip-detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
