/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Notification;
import model.NotificationType;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class NotificationDAO extends DBContext {

    public int countUnreadNotifications(int accountId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE AccountID = ? AND IsRead = 0";
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

    public boolean insert(Notification noti) {
        String sql = "INSERT INTO Notifications (AccountID, NotificationType, Title, Content, IsRead, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, noti.getAccountID());
            ps.setString(2, noti.getNotificationType().name()); // Lưu tên Enum vào DB
            ps.setString(3, noti.getTitle());
            ps.setString(4, noti.getContent());
            ps.setBoolean(5, noti.isIsRead());
            ps.setTimestamp(6, Timestamp.valueOf(noti.getCreatedAt()));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Lỗi insert Notification: " + e.getMessage());
            return false;
        }
    }

    public List<Notification> getByAccount(int accountID) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE AccountID = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationID(rs.getInt("NotificationID"));
                    n.setAccountID(rs.getInt("AccountID"));
                    String typeStr = rs.getString("NotificationType");
                    n.setNotificationType(NotificationType.valueOf(typeStr));
                    n.setTitle(rs.getString("Title"));
                    n.setContent(rs.getString("Content"));
                    n.setIsRead(rs.getBoolean("IsRead"));
                    // Xử lý LocalDateTime
                    n.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Đánh dấu đã đọc (Có check AccountID để bảo mật)
    public boolean markAsRead(int notificationID, int accountID) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ? AND AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Xóa thông báo (Có check AccountID)
    public boolean delete(int notificationID, int accountID) {
        String sql = "DELETE FROM Notifications WHERE NotificationID = ? AND AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
