/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Attendance {

    private int attendanceID;
    private int tripID;
    private int accountID;
    private LocalDateTime checkInTime;
    private LocalDateTime checkOutTime;
    private String note;

    public Attendance() {
    }

    public Attendance(int attendanceID, int tripID, int accountID, LocalDateTime checkInTime, LocalDateTime checkOutTime, String note) {
        this.attendanceID = attendanceID;
        this.tripID = tripID;
        this.accountID = accountID;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.note = note;
    }

    public int getAttendanceID() {
        return attendanceID;
    }

    public void setAttendanceID(int attendanceID) {
        this.attendanceID = attendanceID;
    }

    public int getTripID() {
        return tripID;
    }

    public void setTripID(int tripID) {
        this.tripID = tripID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }

    public LocalDateTime getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(LocalDateTime checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "Attendance{" + "attendanceID=" + attendanceID + ", tripID=" + tripID + ", accountID=" + accountID + ", checkInTime=" + checkInTime + ", checkOutTime=" + checkOutTime + ", note=" + note + '}';
    }
    
}
