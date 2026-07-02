package dal;

import dto.RouteStopDTO;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RouteStopDAO extends DBContext {

    // =========================================================================
    // KHU VỰC LẤY DỮ LIỆU (READ)
    // =========================================================================

    // 1. LẤY DANH SÁCH STOP THEO TUYẾN (Bổ sung Lat, Lng cho Map)
    public List<RouteStopDTO> getStopsByRoute(int routeID) {
        List<RouteStopDTO> list = new ArrayList<>();
        String sql = "SELECT rs.RouteStopID, rs.RouteID, rs.StopID, rs.StopOrder, " +
                     "s.StopName, s.Address, s.Latitude, s.Longitude, s.IsActive " +
                     "FROM Route_Stop rs JOIN Stops s ON rs.StopID = s.StopID " +
                     "WHERE rs.RouteID = ? ORDER BY rs.StopOrder ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RouteStopDTO dto = new RouteStopDTO();
                    dto.setRouteStopID(rs.getInt("RouteStopID"));
                    dto.setRouteID(rs.getInt("RouteID"));
                    dto.setStopID(rs.getInt("StopID"));
                    dto.setStopOrder(rs.getInt("StopOrder"));
                    
                    // Dữ liệu JOIN từ bảng Stops
                    dto.setStopName(rs.getString("StopName"));
                    dto.setAddress(rs.getString("Address"));
                    dto.setLatitude(rs.getDouble("Latitude"));
                    dto.setLongitude(rs.getDouble("Longitude"));
                    
                    // Gợi ý: Bạn có thể thêm trường isActive vào RouteStopDTO nếu muốn hiển thị trạm bị mờ trên giao diện
                    
                    list.add(dto);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 2. LẤY THÔNG TIN 1 BẢN GHI (JOIN Stops để lấy StopName phục vụ quăng Exception trên Service)
    public RouteStopDTO getById(int routeStopID) {
        String sql = "SELECT rs.*, s.StopName " +
                     "FROM Route_Stop rs JOIN Stops s ON rs.StopID = s.StopID " +
                     "WHERE rs.RouteStopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeStopID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RouteStopDTO dto = new RouteStopDTO();
                    dto.setRouteStopID(rs.getInt("RouteStopID"));
                    dto.setRouteID(rs.getInt("RouteID"));
                    dto.setStopID(rs.getInt("StopID"));
                    dto.setStopOrder(rs.getInt("StopOrder"));
                    
                    // Lấy thêm StopName
                    dto.setStopName(rs.getString("StopName"));
                    
                    return dto;
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    // 3. KIỂM TRA ĐIỂM DỪNG ĐÃ ĐƯỢC DÙNG TRONG BẤT KỲ TUYẾN NÀO CHƯA
    // (Phục vụ cho luồng Soft Delete ở Stop Management)
    public boolean existsByStopId(int stopID) {
        String sql = "SELECT TOP 1 1 FROM Route_Stop WHERE StopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, stopID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. KIỂM TRA ĐIỂM DỪNG ĐÃ TỒN TẠI TRONG 1 TUYẾN CỤ THỂ CHƯA
    public boolean existsStopInRoute(int routeID, int stopID) {
        String sql = "SELECT TOP 1 1 FROM Route_Stop WHERE RouteID = ? AND StopID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);
            ps.setInt(2, stopID);
            try (ResultSet rs = ps.executeQuery()) { 
                return rs.next(); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // 5. ĐẾM SỐ LƯỢNG STOP ĐANG CÓ TRONG 1 TUYẾN
    public int countStopsByRoute(int routeID) {
        String sql = "SELECT COUNT(*) FROM Route_Stop WHERE RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, routeID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return 0;
    }

    // =========================================================================
    // KHU VỰC THAO TÁC GHI DỮ LIỆU (BẮT BUỘC DÙNG TRANSACTION & THROWS EXCEPTION)
    // =========================================================================

    // 6. THÊM STOP VÀO TUYẾN
    public void addStopToRoute(int routeID, int stopID, int position) throws Exception {
        String sqlShift = "UPDATE Route_Stop SET StopOrder = StopOrder + 1 WHERE RouteID = ? AND StopOrder >= ?";
        String sqlInsert = "INSERT INTO Route_Stop (RouteID, StopID, StopOrder) VALUES (?, ?, ?)";
        
        try {
            connection.setAutoCommit(false); // BEGIN TRAN
            
            // Bước 1: Dãn dòng (Đẩy các Stop phía sau lên 1 bậc)
            try (PreparedStatement psShift = connection.prepareStatement(sqlShift)) {
                psShift.setInt(1, routeID);
                psShift.setInt(2, position);
                psShift.executeUpdate();
            }
            
            // Bước 2: Chèn Stop mới vào đúng vị trí
            try (PreparedStatement psInsert = connection.prepareStatement(sqlInsert)) {
                psInsert.setInt(1, routeID);
                psInsert.setInt(2, stopID);
                psInsert.setInt(3, position);
                psInsert.executeUpdate();
            }
            
            connection.commit(); // COMMIT TRAN
        } catch (Exception e) {
            connection.rollback(); // ROLLBACK TRAN
            throw new Exception("Lỗi Database khi Add Stop: " + e.getMessage());
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // 7. XÓA STOP KHỎI TUYẾN (Dùng DTO cho Code Clean)
    public void removeStop(RouteStopDTO dto) throws Exception {
        String sqlDelete = "DELETE FROM Route_Stop WHERE RouteStopID = ?";
        String sqlShift = "UPDATE Route_Stop SET StopOrder = StopOrder - 1 WHERE RouteID = ? AND StopOrder > ?";
        
        try {
            connection.setAutoCommit(false);
            
            // Bước 1: Xóa bản ghi hiện tại
            try (PreparedStatement psDelete = connection.prepareStatement(sqlDelete)) {
                psDelete.setInt(1, dto.getRouteStopID());
                psDelete.executeUpdate();
            }
            
            // Bước 2: Dồn hàng (Kéo các Stop phía sau lùi lại 1 bậc)
            try (PreparedStatement psShift = connection.prepareStatement(sqlShift)) {
                psShift.setInt(1, dto.getRouteID());
                psShift.setInt(2, dto.getStopOrder());
                psShift.executeUpdate();
            }
            
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw new Exception("Lỗi Database khi Remove Stop: " + e.getMessage());
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // 8. SWAP VỊ TRÍ (Hàm lõi cho Move Up / Move Down - Sử dụng mẹo -1 để lách Unique Constraint)
    // Hàm hoán đổi vị trí (Order) của 2 điểm dừng
    public void swapStopOrder(int routeID, int currentRouteStopID, int currentOrder, int targetOrder) throws Exception {
        
        // Dùng 99999 làm vị trí tạm thay vì -1 để không vi phạm constraint CHK_RouteStop_Order (StopOrder >= 1)
        String sql1 = "UPDATE Route_Stop SET StopOrder = 99999 WHERE RouteStopID = ?";
        String sql2 = "UPDATE Route_Stop SET StopOrder = ? WHERE RouteID = ? AND StopOrder = ?";
        String sql3 = "UPDATE Route_Stop SET StopOrder = ? WHERE RouteStopID = ?";

        try {
            // Tắt auto commit để chạy Transaction an toàn
            connection.setAutoCommit(false);

            // Bước 1: Đẩy trạm hiện tại ra vị trí tạm (99999)
            try (PreparedStatement ps1 = connection.prepareStatement(sql1)) {
                ps1.setInt(1, currentRouteStopID);
                ps1.executeUpdate();
            }

            // Bước 2: Kéo trạm ở vị trí đích (Target) về vị trí hiện tại (Current)
            try (PreparedStatement ps2 = connection.prepareStatement(sql2)) {
                ps2.setInt(1, currentOrder);
                ps2.setInt(2, routeID);
                ps2.setInt(3, targetOrder);
                ps2.executeUpdate();
            }

            // Bước 3: Đưa trạm đang ở vị trí tạm (99999) vào vị trí đích (Target)
            try (PreparedStatement ps3 = connection.prepareStatement(sql3)) {
                ps3.setInt(1, targetOrder);
                ps3.setInt(2, currentRouteStopID);
                ps3.executeUpdate();
            }

            // Hoàn tất Transaction
            connection.commit();
            
        } catch (Exception e) {
            // Nếu có bất kỳ lỗi gì, Rollback lại trạng thái ban đầu
            connection.rollback();
            throw new Exception("Lỗi Database khi Swap Order: " + e.getMessage());
        } finally {
            // Bật lại auto commit cho các hàm khác dùng
            connection.setAutoCommit(true);
        }
    }
}