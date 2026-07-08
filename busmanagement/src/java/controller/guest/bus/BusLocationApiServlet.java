/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.guest.bus;

import com.google.gson.Gson;
import dto.BusLocationDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.BusTrackingService;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "BusLocationApiServlet", urlPatterns = {"/api/bus-location"})
public class BusLocationApiServlet extends HttpServlet {

    private BusTrackingService trackingService;

    @Override
    public void init() throws ServletException {
        trackingService = new BusTrackingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Trả về định dạng JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<BusLocationDTO> locations = trackingService.getRunningBusesLocations();
            Gson gson = new Gson();
            String jsonOutput = gson.toJson(locations);

            response.getWriter().write(jsonOutput);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi khi lấy dữ liệu vị trí xe\"}");
            e.printStackTrace();
        }
    }
}
