/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Administrator
 */
public class NotificationRead {

    private int readID;
    private int notificationID;
    private int accountID;
    private Timestamp readAt;
    
    public NotificationRead() {}

    public NotificationRead(int readID, int notificationID, int accountID, Timestamp readAt) {
        this.readID = readID;
        this.notificationID = notificationID;
        this.accountID = accountID;
        this.readAt = readAt;
    }

    public int getReadID() { return readID; }
    public void setReadID(int readID) { this.readID = readID; }

    public int getNotificationID() { return notificationID; }
    public void setNotificationID(int notificationID) { this.notificationID = notificationID; }

    public int getAccountID() { return accountID; }
    public void setAccountID(int accountID) { this.accountID = accountID; }

    public Timestamp getReadAt() { return readAt; }
    public void setReadAt(Timestamp readAt) { this.readAt = readAt; }

    @Override
    public String toString() {
        return "NotificationRead{notificationID=" + notificationID + ", accountID=" + accountID + ", readAt=" + readAt + "}";
    }
}
