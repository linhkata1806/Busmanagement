/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class Stop {
    private int stopID;
    private String stopName;
    private String address;
    private double latitude;
    private double longitude;
    private boolean isActive;

    public Stop() {
    }

    public Stop(int stopID, String stopName, String address, double latitude, double longitude, boolean isActive) {
        this.stopID = stopID;
        this.stopName = stopName;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.isActive = isActive;
    }

    public int getStopID() {
        return stopID;
    }

    public void setStopID(int stopID) {
        this.stopID = stopID;
    }

    public String getStopName() {
        return stopName;
    }

    public void setStopName(String stopName) {
        this.stopName = stopName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Stop{" + "stopID=" + stopID + ", stopName=" + stopName + ", address=" + address + ", latitude=" + latitude + ", longitude=" + longitude + ", isActive=" + isActive + '}';
    }

    
}
