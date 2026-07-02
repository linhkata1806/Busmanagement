/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

public class RouteStopDTO {
    // Các trường từ bảng Route_Stop
    private int routeStopID;
    private int routeID;
    private int stopID;
    private int stopOrder;
    private double distanceFromStart; // BỔ SUNG: Khoảng cách từ điểm đầu (km)
    
    // Các trường lấy thêm từ bảng Stops (Qua phép JOIN)
    private String stopName;
    private String address;
    private double latitude;
    private double longitude;
    private boolean isActive;

    // Constructor mặc định
    public RouteStopDTO() {
    }

    // --- CÁC HÀM GETTER & SETTER ---

    public int getRouteStopID() {
        return routeStopID;
    }

    public void setRouteStopID(int routeStopID) {
        this.routeStopID = routeStopID;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
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

    public double getDistanceFromStart() {
        return distanceFromStart;
    }

    public void setDistanceFromStart(double distanceFromStart) {
        this.distanceFromStart = distanceFromStart;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
