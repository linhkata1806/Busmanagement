/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import enums.NotificationType;
import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Notification {

    private int notificationID;
    private int accountID;
    private NotificationType notificationType;
    private String title;
    private String content;
    private boolean isRead;
    private LocalDateTime createdAt;
    private String targetRole;

    public Notification() {
    }

    public Notification(int notificationID, int accountID, NotificationType notificationType, String title, String content, boolean isRead, LocalDateTime createdAt, String targetRole) {
        this.notificationID = notificationID;
        this.accountID = accountID;
        this.notificationType = notificationType;
        this.title = title;
        this.content = content;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.targetRole = targetRole;
    }

    public int getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getTargetRole() {
        return targetRole;
    }

    public void setTargetRole(String targetRole) {
        this.targetRole = targetRole;
    }

    @Override
    public String toString() {
        return "Notification{" + "notificationID=" + notificationID + ", accountID=" + accountID + ", notificationType=" + notificationType + ", title=" + title + ", content=" + content + ", isRead=" + isRead + ", createdAt=" + createdAt + ", targetRole=" + targetRole + '}';
    }

    
}
