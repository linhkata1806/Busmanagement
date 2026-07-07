package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho một bản ghi lịch sử vị trí GPS của xe buýt.
 * Khớp với bảng BusLocationHistory trong CSDL.
 */
public class BusLocationHistory {

    private int historyID;
    private int busID;
    private int tripID;
    private double latitude;
    private double longitude;
    private Timestamp recordedAt;

    public BusLocationHistory() {
    }

    public BusLocationHistory(int historyID, int busID, int tripID, double latitude, double longitude, Timestamp recordedAt) {
        this.historyID = historyID;
        this.busID = busID;
        this.tripID = tripID;
        this.latitude = latitude;
        this.longitude = longitude;
        this.recordedAt = recordedAt;
    }

    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public int getBusID() {
        return busID;
    }

    public void setBusID(int busID) {
        this.busID = busID;
    }

    public int getTripID() {
        return tripID;
    }

    public void setTripID(int tripID) {
        this.tripID = tripID;
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

    public Timestamp getRecordedAt() {
        return recordedAt;
    }

    public void setRecordedAt(Timestamp recordedAt) {
        this.recordedAt = recordedAt;
    }

    @Override
    public String toString() {
        return "BusLocationHistory{" + "historyID=" + historyID + ", busID=" + busID + ", tripID=" + tripID + ", latitude=" + latitude + ", longitude=" + longitude + ", recordedAt=" + recordedAt + '}';
    }

    
}
