/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.RouteDAO;
import dal.TripDAO;
import java.util.List;
import model.Route;

/**
 *
 * @author Administrator
 */
public class RouteService {

    private RouteDAO routeDAO;
    private TripDAO tripDAO;

    public RouteService() {
        routeDAO = new RouteDAO();
        tripDAO = new TripDAO();
    }

    public List<Route> getAllActiveRoutes() {
        return routeDAO.getAllActiveRoutes();
    }

    public List<Route> searchAndFilter(String keyword, String status) {
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        // Chặn URL truyền status sai
        if (!status.equalsIgnoreCase("ALL")
                && !status.equalsIgnoreCase("ACTIVE")
                && !status.equalsIgnoreCase("INACTIVE")) {
            status = "ALL";
        }

        return routeDAO.searchAndFilter(keyword, status);
    }

    public Route getRouteById(int routeID) {
        return routeDAO.getRouteById(routeID);
    }

    // 3. CẬP NHẬT TUYẾN (Bổ sung startPoint, endPoint)
    public void updateRoute(int routeID, String routeName, String startPoint, String endPoint,
            String operatingHours, String frequency, long ticketPrice, double distance, boolean isActive) throws Exception {

        if (!routeDAO.existsById(routeID)) {
            throw new IllegalArgumentException("Tuyến xe không tồn tại trên hệ thống.");
        }

        // --- VALIDATION ĐIỂM ĐẦU / CUỐI ---
        if (routeName == null || routeName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên tuyến không được để trống.");
        }
        if (startPoint == null || startPoint.trim().isEmpty() || endPoint == null || endPoint.trim().isEmpty()) {
            throw new IllegalArgumentException("Điểm xuất phát và Điểm kết thúc không được để trống.");
        }
        if (startPoint.trim().equalsIgnoreCase(endPoint.trim())) {
            throw new IllegalArgumentException("Vi phạm hành trình: Điểm đầu và Điểm cuối không được trùng nhau.");
        }
        // ... (Giữ nguyên các đoạn validate Giá vé, Giờ, Khoảng cách ở dưới)

        Route route = new Route();
        route.setRouteID(routeID);
        route.setRouteName(routeName.trim());
        route.setStartPoint(startPoint.trim()); // BỔ SUNG
        route.setEndPoint(endPoint.trim());     // BỔ SUNG
        route.setOperatingHours(operatingHours.trim());
        route.setFrequence(frequency != null ? frequency.trim() : "");
        route.setTicketPrice(ticketPrice);
        route.setTotalDistance(distance);
        route.setIsActive(isActive);

        if (!routeDAO.update(route)) {
            throw new Exception("Lỗi Database: Không thể cập nhật thông tin tuyến xe.");
        }
    }
    // HÀM XÓA TUYẾN XE (TỰ ĐỘNG SOFT/HARD DELETE THEO LOGIC)
    public void deleteRoute(int routeID) throws Exception {
        // 1. Kiểm tra tuyến xe có tồn tại không
        if (!routeDAO.existsById(routeID)) {
            throw new IllegalArgumentException("Tuyến xe không tồn tại.");
        }
        
        // 2. Kiểm tra lịch sử vận hành chuyến xe (Trip)
        if (tripDAO.existsByRouteId(routeID)) {
            // Tự động chuyển trạng thái thành Ngừng hoạt động (INACTIVE) để giữ toàn vẹn dữ liệu lịch sử
            routeDAO.updateStatus(routeID, false);
            
            // Ném lỗi IllegalArgumentException để thông báo trực tiếp cho nhân viên trên giao diện
            throw new IllegalArgumentException("Tuyến đã có lịch sử vận hành nên hệ thống chỉ chuyển về trạng thái Ngừng hoạt động.");
        }
        
        // 3. Đủ điều kiện an toàn -> Tiến hành xóa cứng (Hard Delete) khỏi Database
        if (!routeDAO.delete(routeID)) {
            throw new Exception("Lỗi hệ thống cơ sở dữ liệu: Không thể hoàn tác lệnh xóa tuyến xe.");
        }
    }
}
