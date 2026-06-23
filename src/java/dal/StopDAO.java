/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Stop;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Administrator
 */
public class StopDAO extends DBContext {

    public List<Stop> getAllStops() {
        List<Stop> list = new ArrayList<>();
        String sql = "SELECT * FROM Stops WHERE IsActive = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStop(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Stop mapStop(ResultSet rs) throws SQLException {
        Stop stop = new Stop();
        stop.setStopID(rs.getInt("StopID"));
        stop.setStopName(rs.getString("StopName"));
        stop.setAddress(rs.getString("Address"));
        // Nếu có tọa độ GPS (Kinh độ/Vĩ độ)
        // stop.setLatitude(rs.getDouble("Latitude"));
        // stop.setLongitude(rs.getDouble("Longitude"));
        stop.setIsActive(rs.getBoolean("IsActive"));

        return stop;
    }

    // Lấy danh sách trạm dừng của 1 tuyến xe cụ thể
    public List<Stop> getStopsByRouteId(int routeId) {
        List<Stop> list = new ArrayList<>();

        // Cần JOIN với bảng trung gian (Ví dụ tên là RouteStops) và sắp xếp theo thứ tự trạm
        String sql = "SELECT s.* "
                + "FROM Stops s "
                + "JOIN Route_Stop rs ON s.StopID = rs.StopID "
                + "WHERE rs.RouteID = ? AND s.IsActive = 1 "
                + "ORDER BY rs.StopOrder ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Gọi lại ngay hàm mapStop cực tiện lợi
                    list.add(mapStop(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy chi tiết thông tin 1 trạm dừng dựa vào ID
    public Stop getStopById(int stopId) {
        String sql = "SELECT * FROM Stops WHERE StopID = ? AND IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, stopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStop(rs); // Gọi lại hàm mapStop có sẵn cực tiện
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
