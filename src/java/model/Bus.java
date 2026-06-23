/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import enums.BusStatus;

/**
 *
 * @author Administrator
 */
public class Bus {
    private int busID;
    private String licensePlate;
    private int capacity;
    private String busType;
    private BusStatus status;

    public Bus(int busID, String licensePlate, int capacity, String busType, BusStatus status) {
        this.busID = busID;
        this.licensePlate = licensePlate;
        this.capacity = capacity;
        this.busType = busType;
        this.status = status;
    }

    public Bus() {
    }

    public int getBusID() {
        return busID;
    }

    public void setBusID(int busID) {
        this.busID = busID;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public BusStatus getStatus() {
        return status;
    }

    public void setStatus(BusStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Bus{" + "busID=" + busID + ", licensePlate=" + licensePlate + ", capacity=" + capacity + ", busType=" + busType + ", status=" + status + '}';
    }
    
}
