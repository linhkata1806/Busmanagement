package dto;

import java.time.LocalDate;

public class TripHistoryDTO {
    private LocalDate date;
    private String routeNumber;
    private String busPlate;
    private String startPoint;
    private String endPoint;

    public TripHistoryDTO() {
    }

    public TripHistoryDTO(LocalDate date, String routeNumber, String busPlate, String startPoint, String endPoint) {
        this.date = date;
        this.routeNumber = routeNumber;
        this.busPlate = busPlate;
        this.startPoint = startPoint;
        this.endPoint = endPoint;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getRouteNumber() {
        return routeNumber;
    }

    public void setRouteNumber(String routeNumber) {
        this.routeNumber = routeNumber;
    }

    public String getBusPlate() {
        return busPlate;
    }

    public void setBusPlate(String busPlate) {
        this.busPlate = busPlate;
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
}
