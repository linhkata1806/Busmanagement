/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class RouteStop {
    private int routestopID;
    private int routID;
    private int stopID;
    private int stopOrder;
    
    private String stopName;
    private double latitude;
    private double longitude;

    public RouteStop() {
    }

    public RouteStop(int routestopID, int routID, int stopID, int stopOrder, String stopName, double latitude, double longitude) {
        this.routestopID = routestopID;
        this.routID = routID;
        this.stopID = stopID;
        this.stopOrder = stopOrder;
        this.stopName = stopName;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public int getRoutestopID() {
        return routestopID;
    }

    public void setRoutestopID(int routestopID) {
        this.routestopID = routestopID;
    }

    public int getRoutID() {
        return routID;
    }

    public void setRoutID(int routID) {
        this.routID = routID;
    }

    public int getStopID() {
        return stopID;
    }

    public void setStopID(int stopID) {
        this.stopID = stopID;
    }

    public int getStopOrder() {
        return stopOrder;
    }

    public void setStopOrder(int stopOrder) {
        this.stopOrder = stopOrder;
    }

    public String getStopName() {
        return stopName;
    }

    public void setStopName(String stopName) {
        this.stopName = stopName;
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

    @Override
    public String toString() {
        return "RouteStop{" + "routestopID=" + routestopID + ", routID=" + routID + ", stopID=" + stopID + ", stopOrder=" + stopOrder + ", stopName=" + stopName + ", latitude=" + latitude + ", longitude=" + longitude + '}';
    }
    
    
}
