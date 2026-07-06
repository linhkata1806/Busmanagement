package controller.driver;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;
import service.DriverTripService;

public class FinishTripServlet extends HttpServlet {

    private DriverTripService driverTripService;

    @Override
    public void init() throws ServletException {
        driverTripService = new DriverTripService();
        // Đã bỏ TripService ở đây vì logic tìm kiếm và validate đã được chuyển hết vào DriverTripService
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
            session.setAttribute("error", "Thiếu mã chuyến xe.");
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr);

            // Gọi Service để xử lý nghiệp vụ kết thúc chuyến xe (truyền thêm driverID để validate)
            driverTripService.finishTrip(tripID, driverID);

            session.setAttribute("successMsg", "Kết thúc chuyến đi #" + tripID + " thành công!");
        } catch (Exception e) {
            // Bắt trúng các thông báo lỗi từ Service và hiển thị cho tài xế
            e.printStackTrace(); // Giữ lại để log ra console khi debug
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
