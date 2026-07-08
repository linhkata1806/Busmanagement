/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Administrator
 */
public class BusLocationDTO {

    private int tripID;
    private String routeNumber;
    private String licensePlate;
    private double lat;
    private double lng;
    private int passengerCount;
    private int capacity;
    private int etaMinutes; // Thời gian đến trạm tiếp theo ước lượng (phút)

    public BusLocationDTO() {
    }

    public BusLocationDTO(int tripID, String routeNumber, String licensePlate, double lat, double lng, int passengerCount, int capacity, int etaMinutes) {
        this.tripID = tripID;
        this.routeNumber = routeNumber;
        this.licensePlate = licensePlate;
        this.lat = lat;
        this.lng = lng;
        this.passengerCount = passengerCount;
        this.capacity = capacity;
        this.etaMinutes = etaMinutes;
    }

    // Getters and Setters
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

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLng() {
        return lng;
    }

    public void setLng(double lng) {
        this.lng = lng;
    }

    public int getPassengerCount() {
        return passengerCount;
    }

    public void setPassengerCount(int passengerCount) {
        this.passengerCount = passengerCount;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getEtaMinutes() {
        return etaMinutes;
    }

    public void setEtaMinutes(int etaMinutes) {
        this.etaMinutes = etaMinutes;
    }
}
