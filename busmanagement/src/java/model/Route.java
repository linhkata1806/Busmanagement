/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class Route {
    private int routeID;
    private String routeNumber;
    private String routeName;
    private String startPoint;
    private String endPoint;
    private String operatingHours;
    private String frequence;
    private long ticketPrice;
    private double totalDistance;
    private boolean isActive;

    public Route() {
    }

    public Route(int routeID, String routeNumber, String routeName, String startPoint, String endPoint, String operatingHours, String frequence, long ticketPrice, double totalDistance, boolean isActive) {
        this.routeID = routeID;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.startPoint = startPoint;
        this.endPoint = endPoint;
        this.operatingHours = operatingHours;
        this.frequence = frequence;
        this.ticketPrice = ticketPrice;
        this.totalDistance = totalDistance;
        this.isActive = isActive;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
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

    public String getStartPoint() {
        return startPoint;
    }

    public void setStartPoint(String startPoint) {
        this.startPoint = startPoint;
    }

    public String getEndPoint() {
        return endPoint;
    }

    public void setEndPoint(String endPoint) {
        this.endPoint = endPoint;
    }

    public String getOperatingHours() {
        return operatingHours;
    }

    public void setOperatingHours(String operatingHours) {
        this.operatingHours = operatingHours;
    }

    public String getFrequence() {
        return frequence;
    }

    public void setFrequence(String frequence) {
        this.frequence = frequence;
    }

    public long getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(long ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public double getTotalDistance() {
        return totalDistance;
    }

    public void setTotalDistance(double totalDistance) {
        this.totalDistance = totalDistance;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Route{" + "routeID=" + routeID + ", routeNumber=" + routeNumber + ", routeName=" + routeName + ", startPoint=" + startPoint + ", endPoint=" + endPoint + ", operatingHours=" + operatingHours + ", frequence=" + frequence + ", ticketPrice=" + ticketPrice + ", totalDistance=" + totalDistance + ", isActive=" + isActive + '}';
    }

    
    
    
}
