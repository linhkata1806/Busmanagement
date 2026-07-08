/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Administrator
 */
public class BusTrackingDTO {

    private int busID;
    private String licensePlate;
    private double latitude;
    private double longitude;
    private String routeNumber;
    private String routeName;
    private String tripStatus;
    private String currentStop;
    private String nextStop;
    private int passengerCount;
    private int speed;

    public BusTrackingDTO() {
    }

    public BusTrackingDTO(int busID, String licensePlate, double latitude, double longitude, String routeNumber, String routeName, String tripStatus, String currentStop, String nextStop, int passengerCount, int speed) {
        this.busID = busID;
        this.licensePlate = licensePlate;
        this.latitude = latitude;
        this.longitude = longitude;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.tripStatus = tripStatus;
        this.currentStop = currentStop;
        this.nextStop = nextStop;
        this.passengerCount = passengerCount;
        this.speed = speed;
    }

    // Getters and Setters
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

    public String getTripStatus() {
        return tripStatus;
    }

    public void setTripStatus(String tripStatus) {
        this.tripStatus = tripStatus;
    }

    public String getCurrentStop() {
        return currentStop;
    }

    public void setCurrentStop(String currentStop) {
        this.currentStop = currentStop;
    }

    public String getNextStop() {
        return nextStop;
    }

    public void setNextStop(String nextStop) {
        this.nextStop = nextStop;
    }

    public int getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(int passengerCount) {
        this.passengerCount = passengerCount;
    }

    public int getSpeed() {
        return speed;
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }
}
