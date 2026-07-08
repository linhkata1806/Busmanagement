package controller.driver.trip;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;
import service.DriverTripService;

public class StartTripServlet extends HttpServlet {

    private DriverTripService driverTripService;

    @Override
    public void init() throws ServletException {
        driverTripService = new DriverTripService();
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

        // Bắt lỗi: Nút bị lỗi truyền href trống hoặc id trống
        if (tripIDStr == null || tripIDStr.trim().isEmpty()) {
            session.setAttribute("error", "Dữ liệu không hợp lệ: Thiếu mã chuyến xe. Vui lòng tải lại trang.");
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr.trim());
            driverTripService.startTrip(tripID, driverID);
            session.setAttribute("successMsg", "Bắt đầu chuyến đi #" + tripID + " thành công!");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã chuyến xe không đúng định dạng.");
        } catch (Exception e) {
            // Nơi đây sẽ bắt toàn bộ thông báo chi tiết từ Service (Sai tài xế, chưa đến giờ,...)
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
