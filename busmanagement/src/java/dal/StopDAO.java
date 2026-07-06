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

    //======= Hàm cho guest- hiển thị lên home servlet
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

    //============hàm cho guest Lấy chi tiết thông tin 1 trạm dừng dựa vào ID
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

    private Stop mapStop(ResultSet rs) throws SQLException {
        Stop stop = new Stop();
        stop.setStopID(rs.getInt("StopID"));
        stop.setStopName(rs.getString("StopName"));
        stop.setAddress(rs.getString("Address"));

        stop.setLatitude(rs.getDouble("Latitude"));
        stop.setLongitude(rs.getDouble("Longitude"));
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

// 1. TÌM KIẾM VÀ LỌC ĐIỂM DỪNG (Xử lý chuỗi ALL/ACTIVE/INACTIVE sang BIT)
    public List<Stop> searchAndFilter(String keyword, String status) {
        List<Stop> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Stops WHERE (StopName LIKE ? OR Address LIKE ?) ");

        // Chuyển đổi String "ACTIVE"/"INACTIVE" thành điều kiện lọc BIT
        if ("ACTIVE".equalsIgnoreCase(status)) {
            sql.append("AND IsActive = 1 ");
        } else if ("INACTIVE".equalsIgnoreCase(status)) {
            sql.append("AND IsActive = 0 ");
        }
        sql.append("ORDER BY StopName ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStop(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi searchAndFilter Stop: " + e.getMessage());
        }
        return list;
    }

    // 2. KIỂM TRA TRÙNG TÊN ĐIỂM DỪNG
    public boolean existsStopName(String stopName, Integer excludeStopID) {
        String sql = "SELECT TOP 1 1 FROM Stops WHERE StopName = ?";
        if (excludeStopID != null) {
            sql += " AND StopID != ?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, stopName);
            if (excludeStopID != null) {
                ps.setInt(2, excludeStopID);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Lỗi existsStopName: " + e.getMessage());
        }
        return false;
    }

    // 3. THÊM MỚI
    public boolean insert(Stop stop) {
        String sql = "INSERT INTO Stops (StopName, Address, Latitude, Longitude, IsActive) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, stop.getStopName());
            ps.setString(2, stop.getAddress());
            ps.setDouble(3, stop.getLatitude());
            ps.setDouble(4, stop.getLongitude());
            ps.setBoolean(5, stop.isIsActive());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi insert Stop: " + e.getMessage());
        }
        return false;
    }

    // 4. CẬP NHẬT
    public boolean update(Stop stop) {
        String sql = "UPDATE Stops SET StopName = ?, Address = ?, Latitude = ?, Longitude = ?, IsActive = ? WHERE StopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, stop.getStopName());
            ps.setString(2, stop.getAddress());
            ps.setDouble(3, stop.getLatitude());
            ps.setDouble(4, stop.getLongitude());
            ps.setBoolean(5, stop.isIsActive());
            ps.setInt(6, stop.getStopID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi update Stop: " + e.getMessage());
        }
        return false;
    }

    // 5. CẬP NHẬT TRẠNG THÁI (Dùng cho Soft Delete)
    public boolean updateStatus(int stopID, boolean isActive) {
        String sql = "UPDATE Stops SET IsActive = ? WHERE StopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, stopID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi updateStatus Stop: " + e.getMessage());
        }
        return false;
    }

    // 6. XÓA VẬT LÝ (Hard Delete)
    public boolean delete(int stopID) {
        String sql = "DELETE FROM Stops WHERE StopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, stopID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Stop: " + e.getMessage());
        }
        return false;
    }

    public List<Stop> getAvailableStops(int routeID) {
        List<Stop> list = new ArrayList<>();

        // Truy vấn lấy các trạm ACTIVE và CHƯA nằm trong Route_Stop của tuyến hiện tại
        String sql = "SELECT * FROM Stops "
                + "WHERE IsActive = 1 "
                + "AND StopID NOT IN ("
                + "    SELECT StopID FROM Route_Stop WHERE RouteID = ?"
                + ") "
                + "ORDER BY StopName ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Stop stop = new Stop();
                    stop.setStopID(rs.getInt("StopID"));
                    stop.setStopName(rs.getString("StopName"));
                    stop.setAddress(rs.getString("Address"));
                    stop.setLatitude(rs.getDouble("Latitude"));
                    stop.setLongitude(rs.getDouble("Longitude"));
                    stop.setIsActive(rs.getBoolean("IsActive"));

                    list.add(stop);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi tại getAvailableStops (StopDAO): " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
}
