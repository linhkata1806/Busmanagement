package controller.driver.trip;

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

        // Bắt lỗi thẻ <a id=""> rỗng
        if (tripIDStr == null || tripIDStr.trim().isEmpty()) {
            session.setAttribute("error", "Dữ liệu không hợp lệ: Không tìm thấy mã chuyến xe để kết thúc.");
            response.sendRedirect(request.getContextPath() + "/driver/dashboard");
            return;
        }

        try {
            int tripID = Integer.parseInt(tripIDStr.trim());
            driverTripService.finishTrip(tripID, driverID);
            session.setAttribute("successMsg", "Kết thúc chuyến đi #" + tripID + " thành công!");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã chuyến xe không đúng định dạng số.");
        } catch (Exception e) {
            // Bắt lỗi: Chuyến xe không tồn tại, sai tài xế...
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
