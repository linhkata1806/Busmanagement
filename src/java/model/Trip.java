/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import enums.TripStatus;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author Administrator
 */
public class Trip {
    private int tripID;
    private int routeID;
    private int busID;
    private int driverID;
    private Integer assistantID;
    private LocalDate tripDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private int direction;
    private TripStatus status;

    public Trip() {
    }

    public Trip(int tripID, int routeID, int busID, int driverID, Integer assistantID, LocalDate tripDate, LocalTime startTime, LocalTime endTime, int direction, TripStatus status) {
        this.tripID = tripID;
        this.routeID = routeID;
        this.busID = busID;
        this.driverID = driverID;
        this.assistantID = assistantID;
        this.tripDate = tripDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.direction = direction;
        this.status = status;
    }

    public int getTripID() {
        return tripID;
    }

    public void setTripID(int tripID) {
        this.tripID = tripID;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
    }

    public int getBusID() {
        return busID;
    }

    public void setBusID(int busID) {
        this.busID = busID;
    }

    public int getDriverID() {
        return driverID;
    }

    public void setDriverID(int driverID) {
        this.driverID = driverID;
    }

    public Integer getAssistantID() {
        return assistantID;
    }

    public void setAssistantID(Integer assistantID) {
        this.assistantID = assistantID;
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

    public TripStatus getStatus() {
        return status;
    }

    public void setStatus(TripStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Trip{" + "tripID=" + tripID + ", routeID=" + routeID + ", busID=" + busID + ", driverID=" + driverID + ", assistantID=" + assistantID + ", tripDate=" + tripDate + ", startTime=" + startTime + ", endTime=" + endTime + ", direction=" + direction + ", status=" + status + '}';
    }
    
    
}
