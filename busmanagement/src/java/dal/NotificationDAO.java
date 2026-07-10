/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Notification;
import enums.NotificationType;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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

    /**
     * Đếm thông báo chưa đọc dành cho một tài khoản VÀ các thông báo broadcast
     * gửi tới nhóm vai trò (roleName) hoặc gửi cho tất cả ('ALL').
     * Dành cho Phụ xe: roleName = "ASSISTANT"
     */
    public int countUnreadByAccountAndRole(int accountId, String roleName) {
        String sql = "SELECT COUNT(*) FROM Notifications n "
                + "LEFT JOIN NotificationReads nr ON n.NotificationID = nr.NotificationID AND nr.AccountID = ? "
                + "WHERE nr.ReadID IS NULL AND ("
                + "  (n.AccountID = ? AND n.IsRead = 0) "
                + "  OR (n.AccountID IS NULL AND n.TargetRole IN (?, 'ALL'))"
                + ")";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, accountId);
            ps.setString(3, roleName);
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

    /**
     * Lấy thông báo cho Phụ xe: bao gồm thông báo đích danh (AccountID = accountID)
     * VÀ thông báo broadcast gửi tới nhóm vai trò (roleName) hoặc gửi tất cả ('ALL').
     * Spec Sprint 6 – Mục V: "xem thông báo được gửi đích danh HOẶC gửi hàng loạt dành cho nhóm Phụ xe".
     */
    public List<Notification> getByAccountAndRole(int accountID, String roleName) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT n.NotificationID, n.AccountID, n.NotificationType, n.Title, n.Content, n.TargetRole, n.CreatedAt, "
                + "       CASE "
                + "           WHEN n.AccountID = ? THEN n.IsRead "
                + "           ELSE CASE WHEN nr.ReadID IS NOT NULL THEN 1 ELSE 0 END "
                + "       END AS IsRead "
                + "FROM Notifications n "
                + "LEFT JOIN NotificationReads nr ON n.NotificationID = nr.NotificationID AND nr.AccountID = ? "
                + "WHERE n.AccountID = ? "
                + "   OR (n.AccountID IS NULL AND n.TargetRole IN (?, 'ALL')) "
                + "ORDER BY n.CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            ps.setInt(2, accountID);
            ps.setInt(3, accountID);
            ps.setString(4, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            } catch (Exception ex) {
                Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, "Lỗi getByAccountAndRole", ex);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markAsRead(int notificationID, int accountID) {
        String updateSql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ? AND AccountID = ?";
        try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
            ps.setInt(1, notificationID);
            ps.setInt(2, accountID);
            if (ps.executeUpdate() > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu không update được (có thể do AccountID IS NULL - thông báo chung),
        // thì thêm bản ghi vào bảng NotificationReads để đánh dấu tài khoản này đã đọc.
        String checkSql = "SELECT 1 FROM Notifications WHERE NotificationID = ? AND AccountID IS NULL";
        boolean isBroadcast = false;
        try (PreparedStatement ps = connection.prepareStatement(checkSql)) {
            ps.setInt(1, notificationID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    isBroadcast = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (isBroadcast) {
            String insertSql = "INSERT INTO NotificationReads (NotificationID, AccountID) VALUES (?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
                ps.setInt(1, notificationID);
                ps.setInt(2, accountID);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                // Nếu đã tồn tại (lỗi UNIQUE), coi như thành công
                return true;
            }
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

    //cho staff
    public int countNotifications() {
        String sql = "SELECT COUNT(*) FROM Notifications";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi countNotifications: " + e.getMessage());
        }
        return 0;
    }

    //get all noti cho staff
    public List<Notification> getAll() {
        List<Notification> list = new ArrayList<>();
        String sql = "select * from Notifications";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi truy vấn danh sách thông báo: " + e.getMessage(), e);
        }
        return list;
    }

    public Notification getById(int notificationId) {
        String sql = "SELECT * FROM Notifications WHERE NotificationID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, notificationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getById Notification: " + e.getMessage());
        }
        return null;
    }

    // 4. Cập nhật (Chỉ sửa Title và Content theo Sprint 4)
    public boolean update(int notificationId, String title, String content) {
        String sql = "UPDATE Notifications SET Title = ?, Content = ? WHERE NotificationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi update Notification: " + e.getMessage());
        }
        return false;
    }

    // 5. Xóa thông báo
    public boolean delete(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE NotificationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi delete Notification: " + e.getMessage());
        }
        return false;
    }

    private Notification mapRow(ResultSet rs) throws Exception {
        Notification n = new Notification();
        n.setNotificationID(rs.getInt("NotificationID"));
        n.setAccountID(rs.getInt("AccountID"));
        int accountID = rs.getInt("AccountID");
        if (rs.wasNull()) {
            n.setAccountID(0);
        } else {
            n.setAccountID(accountID);
    }
        n.setNotificationType(NotificationType.valueOf(rs.getString("NotificationType")));
        n.setTitle(rs.getString("Title"));
        n.setContent(rs.getString("Content"));
        n.setIsRead(rs.getBoolean("IsRead"));
        java.sql.Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) {
            n.setCreatedAt(ts.toLocalDateTime());
        }
        return n;
    }
}
