/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author Administrator
 */
public class TripDTO {

    private int tripID;
    private String routeNumber;
    private String routeName;
    private String busPlate;
    private String driverName;
    private String assistantName; // Có thể null
    private LocalDate tripDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private int direction;
    private String status;
    private java.sql.Timestamp actualStartTime;
    private java.sql.Timestamp actualEndTime;

    public TripDTO() {
    }

    public int getTripID() {
        return tripID;
    }

    public void setTripID(int tripID) {
        this.tripID = tripID;
    }

    public String getRouteNumber() {
        return routeNumber;
    }

    public void setRouteNumber(String routeNumber) {
        this.routeNumber = routeNumber;
    }

    public String getRouteName() {
        return routeName;
    }

    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }

    public String getBusPlate() {
        return busPlate;
    }

    public void setBusPlate(String busPlate) {
        this.busPlate = busPlate;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getAssistantName() {
        return assistantName;
    }

    public void setAssistantName(String assistantName) {
        this.assistantName = assistantName;
    }

    public LocalDate getTripDate() {
        return tripDate;
    }

    public void setTripDate(LocalDate tripDate) {
        this.tripDate = tripDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getDirection() {
        return direction;
    }

    public void setDirection(int direction) {
        this.direction = direction;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVietnameseStatus() {
        if (status == null) return "";
        switch (status) {
            case "SCHEDULED": return "Chuẩn bị";
            case "IN_PROGRESS": return "Đang chạy";
            case "COMPLETED": return "Hoàn thành";
            case "CANCELLED": return "Đã huỷ";
            default: return status;
        }
    }

    public java.sql.Timestamp getActualStartTime() {
        return actualStartTime;
    }

    public void setActualStartTime(java.sql.Timestamp actualStartTime) {
        this.actualStartTime = actualStartTime;
    }

    public java.sql.Timestamp getActualEndTime() {
        return actualEndTime;
    }

    public void setActualEndTime(java.sql.Timestamp actualEndTime) {
        this.actualEndTime = actualEndTime;
    }
}
