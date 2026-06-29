//trả về dữ liệu JSON thời tiết.

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.WeatherService;

@WebServlet(name = "WeatherServlet", urlPatterns = {"/weather"})
public class WeatherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập header trả về kiểu JSON hỗ trợ UTF-8 cho tiếng Việt
        response.setContentType("application/json;charset=UTF-8");
        
        // Lấy tên thành phố từ URL Parameter (nếu không có thì mặc định là Hanoi)
        String city = request.getParameter("city");
        if (city == null || city.trim().isEmpty()) {
            city = "Hanoi"; 
        }
        
        String weatherJson = WeatherService.getWeatherData(city);
        
        if (weatherJson != null) {
            response.getWriter().write(weatherJson);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Không thể tải dữ liệu thời tiết!\"}");
        }
    }
}
