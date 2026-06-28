/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Administrator
 */
public class RouteDTO {
    private int routeID;
    private String routeNumber;
    private String routeName;
    private String startPoint;
    private String endPoint;
    private String operatingHours;
    private String frequency;
    private long ticketPrice;
    private boolean isActive;

    public RouteDTO() {
    }

    public RouteDTO(int routeID, String routeNumber, String routeName, String startPoint, String endPoint, String operatingHours, String frequency, long ticketPrice, boolean isActive) {
        this.routeID = routeID;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.startPoint = startPoint;
        this.endPoint = endPoint;
        this.operatingHours = operatingHours;
        this.frequency = frequency;
        this.ticketPrice = ticketPrice;
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

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public long getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(long ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
}
