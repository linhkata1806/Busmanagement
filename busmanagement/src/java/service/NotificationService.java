/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.NotificationDAO;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.Notification;
import enums.NotificationType;

/**
 *
 * @author Administrator
 */
public class NotificationService {

    private NotificationDAO notificationDAO;

    public NotificationService() {
        notificationDAO = new NotificationDAO();
    }

    // quan ly cua staff
    public boolean createNotification(int accountID, String type, String notiTitle, String notiContent) {
        try {
            Notification noti = new Notification();

            noti.setAccountID(accountID);
            noti.setNotificationType(NotificationType.valueOf(type.toUpperCase()));
            noti.setTitle(notiTitle);
            noti.setContent(notiContent);
            noti.setIsRead(false);
            LocalDateTime now = LocalDateTime.now();
            noti.setCreatedAt(now);

            notificationDAO.insert(noti);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi tạo thông báo: " + e.getMessage());
            // 3. Nếu xảy ra lỗi, trả về false để Servlet báo lỗi ra màn hình

        }
        return false;
    }

    public void setConnection(java.sql.Connection conn) {
        this.notificationDAO.setConnection(conn);
    }

    public void createNotification(int accountID, NotificationType type, String notiTitle, String notiContent) {
        Notification noti = new Notification();

        noti.setAccountID(accountID);
        noti.setNotificationType(type);
        noti.setTitle(notiTitle);
        noti.setContent(notiContent);
        noti.setIsRead(false);
        LocalDateTime now = LocalDateTime.now();
        noti.setCreatedAt(now);

        notificationDAO.insert(noti);

    }

    // Lấy toàn bộ danh sách thông báo (Dùng cho giao diện Staff)
    public List<Notification> getAllNotifications() {
        return notificationDAO.getAll();
    }

    public boolean updateNotification(int notificationId, String title, String content) {
        // Validate
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            return false;
        }
        return notificationDAO.update(notificationId, title.trim(), content.trim());
    }

    public boolean deleteNotification(int notificationId) {
        return notificationDAO.delete(notificationId);
    }

    public List<Notification> getByAccount(int accountID) {
        return notificationDAO.getByAccount(accountID);
    }

    public boolean markAsRead(int notificationID, int accountID) {
        return notificationDAO.markAsRead(notificationID, accountID);
    }

    public boolean delete(int notificationID, int accountID) {
        return notificationDAO.delete(notificationID, accountID);
    }

    public int countUnreadNotifications(int accountID) {
        return notificationDAO.countUnreadNotifications(accountID);
    }

    public int countNotifications() {
        return notificationDAO.countNotifications();
    }

    public Notification getById(int id) {
        return notificationDAO.getById(id);
    }

}
