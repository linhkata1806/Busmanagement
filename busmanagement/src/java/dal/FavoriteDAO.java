/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import dto.RouteDTO;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Administrator
 */
public class FavoriteDAO extends DBContext{

    public int countFavorites(int accountId) {
        String sql = "SELECT COUNT(*) FROM Favorites WHERE AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Kiểm tra xem User đã yêu thích tuyến này chưa
    public boolean isFavorite(int accountId, int routeId) {
        String sql = "SELECT 1 FROM Favorites WHERE AccountID = ? AND RouteID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setInt(2, routeId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Thêm vào danh sách yêu thích
    public boolean addFavorite(int accountId, int routeId) {
        String sql = "INSERT INTO Favorites (AccountID, RouteID) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, routeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa khỏi danh sách yêu thích
    public boolean removeFavorite(int accountId, int routeId) {
        String sql = "DELETE FROM Favorites WHERE AccountID = ? AND RouteID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, routeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<RouteDTO> getFavoriteRoutes(int accountId) {
        List<RouteDTO> list = new ArrayList<>();
        
        // JOIN bảng Routes với bảng Favorites
        String sql = "SELECT r.* "
                   + "FROM Routes r "
                   + "JOIN Favorites f ON r.RouteID = f.RouteID "
                   + "WHERE f.AccountID = ? "
                   + "ORDER BY f.CreatedAt DESC";
                   
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RouteDTO route = new RouteDTO();
                    
                    route.setRouteID(rs.getInt("RouteID"));
                    route.setRouteNumber(rs.getString("RouteNumber"));
                    route.setRouteName(rs.getString("RouteName"));
                    route.setStartPoint(rs.getString("StartPoint"));
                    route.setEndPoint(rs.getString("EndPoint"));
                    route.setOperatingHours(rs.getString("OperatingHours"));
                    route.setFrequency(rs.getString("Frequency"));
                    route.setTicketPrice(rs.getLong("TicketPrice"));
                    route.setIsActive(rs.getBoolean("IsActive"));
                    
                    list.add(route);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getFavoriteRoutes: " + e.getMessage());
        }
        return list;
    }
    
}
