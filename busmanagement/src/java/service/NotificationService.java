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

/**
 *
 * @author Administrator
 */
public class NotificationService {
    private NotificationDAO notificationDAO;

    public NotificationService() {
        notificationDAO = new NotificationDAO();
    }
        
    
    public void createNotification(int accountID, String type, String notiTitle, String notiContent) {
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
    
}
