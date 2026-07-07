package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho trạng thái tiến độ chuyến đi theo thời gian thực.
 * Khớp với bảng TripProgress trong CSDL.
 * Hỗ trợ tính năng Map Animation và ETA.
 */
public class TripProgress {

    private int tripProgressID;
    private int tripID;
    private int currentStopID;
    private Integer nextStopID;       // NULL nếu đây là trạm cuối cùng
    private Double distanceRemaining; // km còn lại đến trạm tiếp theo
    private Timestamp estimatedArrival;
    private Timestamp updatedAt;

    // Các trường JOIN thêm để hiển thị
    private String currentStopName;
    private String nextStopName;
    private double currentLat;
    private double currentLng;

    public TripProgress() {}

    public TripProgress(int tripProgressID, int tripID, int currentStopID, Integer nextStopID, Double distanceRemaining, Timestamp estimatedArrival, Timestamp updatedAt, String currentStopName, String nextStopName, double currentLat, double currentLng) {
        this.tripProgressID = tripProgressID;
        this.tripID = tripID;
        this.currentStopID = currentStopID;
        this.nextStopID = nextStopID;
        this.distanceRemaining = distanceRemaining;
        this.estimatedArrival = estimatedArrival;
        this.updatedAt = updatedAt;
        this.currentStopName = currentStopName;
        this.nextStopName = nextStopName;
        this.currentLat = currentLat;
        this.currentLng = currentLng;
    }
    
    

    public int getTripProgressID() { return tripProgressID; }
    public void setTripProgressID(int tripProgressID) { this.tripProgressID = tripProgressID; }

    public int getTripID() { return tripID; }
    public void setTripID(int tripID) { this.tripID = tripID; }

    public int getCurrentStopID() { return currentStopID; }
    public void setCurrentStopID(int currentStopID) { this.currentStopID = currentStopID; }

    public Integer getNextStopID() { return nextStopID; }
    public void setNextStopID(Integer nextStopID) { this.nextStopID = nextStopID; }

    public Double getDistanceRemaining() { return distanceRemaining; }
    public void setDistanceRemaining(Double distanceRemaining) { this.distanceRemaining = distanceRemaining; }

    public Timestamp getEstimatedArrival() { return estimatedArrival; }
    public void setEstimatedArrival(Timestamp estimatedArrival) { this.estimatedArrival = estimatedArrival; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCurrentStopName() { return currentStopName; }
    public void setCurrentStopName(String currentStopName) { this.currentStopName = currentStopName; }

    public String getNextStopName() { return nextStopName; }
    public void setNextStopName(String nextStopName) { this.nextStopName = nextStopName; }

    public double getCurrentLat() { return currentLat; }
    public void setCurrentLat(double currentLat) { this.currentLat = currentLat; }

    public double getCurrentLng() { return currentLng; }
    public void setCurrentLng(double currentLng) { this.currentLng = currentLng; }

    @Override
    public String toString() {
        return "TripProgress{tripID=" + tripID + ", currentStop=" + currentStopName
                + ", distanceRemaining=" + distanceRemaining + "km, eta=" + estimatedArrival + '}';
    }
}
