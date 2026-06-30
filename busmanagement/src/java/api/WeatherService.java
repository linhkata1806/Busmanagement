//kết nối đến WeatherAPI bằng key của bạn và cấu hình cache 30 phút.

package api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class WeatherService {
    private static final String API_KEY = "d23b57f290834536875130824262906"; 
    private static final String API_URL = "http://api.weatherapi.com/v1/forecast.json";
    
    // Lưu trữ cache đơn giản bằng biến tĩnh (Static Variables) trong bộ nhớ
    private static String cachedWeatherData = null;
    private static long lastUpdatedTime = 0;
    private static final long CACHE_DURATION = 30 * 60 * 1000; // Cache 30 phút

    public static String getWeatherData(String city) {
        long currentTime = System.currentTimeMillis();
        
        // Nếu đã có cache và chưa quá thời gian CACHE_DURATION, trả về dữ liệu cache luôn
        if (cachedWeatherData != null && (currentTime - lastUpdatedTime) < CACHE_DURATION) {
            return cachedWeatherData;
        }

        try {
            String encodedCity = URLEncoder.encode(city, StandardCharsets.UTF_8.toString());
            // Lấy dự báo 4 ngày (hôm nay + 3 ngày tiếp theo)
            String urlString = API_URL + "?key=" + API_KEY + "&q=" + encodedCity + "&days=4&aqi=no&alerts=no&lang=vi";
            
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder response = new StringBuilder();
                String inputLine;

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                // Lưu dữ liệu vào cache
                cachedWeatherData = response.toString();
                lastUpdatedTime = currentTime;

                return cachedWeatherData;
            } else {
                System.out.println("Lỗi gọi Weather API. HTTP Response Code: " + responseCode);
            }
        } catch (Exception e) {
            System.err.println("Lỗi hệ thống khi tải thời tiết: " + e.getMessage());
        }
        
        // Nếu bị lỗi nhưng đã có cache cũ, trả về cache cũ thay vì trả về null
        if (cachedWeatherData != null) {
            return cachedWeatherData;
        }
        
        return null;
    }
}
