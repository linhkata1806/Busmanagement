/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.RouteStopDAO;
import dal.StopDAO;
import java.util.List;
import model.Stop;

/**
 *
 * @author Administrator
 */
public class StopService {

    private StopDAO stopDAO;
    private RouteStopDAO routeStopDAO;

    public StopService() {
        this.stopDAO = new StopDAO();
        this.routeStopDAO = new RouteStopDAO();
    }

    public List<Stop> searchAndFilter(String keyword, String status) {
        // Chuẩn hóa param trước khi đẩy xuống DAO
        keyword = (keyword == null) ? "" : keyword.trim();
        status = (status == null || status.trim().isEmpty()) ? "ALL" : status.trim().toUpperCase();
        return stopDAO.searchAndFilter(keyword, status);
    }

    public void createStop(String stopName, String address, double lat, double lng) throws Exception {
        validateStopData(stopName, lat, lng);

        if (stopDAO.existsStopName(stopName.trim(), null)) {
            throw new IllegalArgumentException("Tên điểm dừng '" + stopName.trim() + "' đã tồn tại trong hệ thống.");
        }

        Stop stop = new Stop();
        stop.setStopName(stopName.trim());
        stop.setAddress(address == null ? "" : address.trim());
        stop.setLatitude(lat);
        stop.setLongitude(lng);
        stop.setIsActive(true); // Mặc định khi tạo mới là ACTIVE

        if (!stopDAO.insert(stop)) {
            throw new Exception("Lỗi hệ thống: Không thể thêm điểm dừng mới.");
        }
    }
        public void updateStop(int stopID, String stopName, String address, double lat, double lng, boolean isActive) throws Exception {
        validateStopData(stopName, lat, lng);

        Stop existingStop = stopDAO.getStopById(stopID);
        if (existingStop == null) {
            throw new IllegalArgumentException("Điểm dừng không tồn tại.");
        }

        if (stopDAO.existsStopName(stopName.trim(), stopID)) {
            throw new IllegalArgumentException("Tên điểm dừng '" + stopName.trim() + "' đã bị trùng với một điểm dừng khác.");
        }

        existingStop.setStopName(stopName.trim());
        existingStop.setAddress(address == null ? "" : address.trim());
        existingStop.setLatitude(lat);
        existingStop.setLongitude(lng);
        existingStop.setIsActive(isActive);

        if (!stopDAO.update(existingStop)) {
            throw new Exception("Lỗi hệ thống: Không thể cập nhật điểm dừng.");
        }
    }

    public String deleteStop(int stopID) throws Exception {
        if (stopDAO.getStopById(stopID) == null) {
            throw new IllegalArgumentException("Điểm dừng không tồn tại hoặc đã bị xóa!");
        }

        
        if (routeStopDAO.existsByStopId(stopID)) {
            // THAY ĐỔI: Truyền false thay vì "INACTIVE"
            if (!stopDAO.updateStatus(stopID, false)) {
                throw new Exception("Lỗi hệ thống: Không thể chuyển trạng thái điểm dừng sang INACTIVE.");
            }
            return "INACTIVATED";
        }

        // Nếu điểm dừng chưa từng được sử dụng -> Hard Delete
        if (!stopDAO.delete(stopID)) {
            throw new Exception("Lỗi hệ thống: Không thể xóa điểm dừng khỏi cơ sở dữ liệu.");
        }

        return "DELETED";
    }
    // Hàm phụ trợ dùng chung cho Create và Update
   private void validateStopData(String stopName, double lat, double lng) {
        if (stopName == null || stopName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên điểm dừng không được để trống.");
        }
        if (lat < -90.0 || lat > 90.0) {
            throw new IllegalArgumentException("Vĩ độ (Latitude) phải hợp lệ (từ -90 đến 90).");
        }
        if (lng < -180.0 || lng > 180.0) {
            throw new IllegalArgumentException("Kinh độ (Longitude) phải hợp lệ (từ -180 đến 180).");
        }
    }
}
