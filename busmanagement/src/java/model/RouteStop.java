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
    private double distanceFromStart;

    public RouteStop() {
    }

    public RouteStop(int routestopID, int routID, int stopID, int stopOrder, double distanceFromStart) {
        this.routestopID = routestopID;
        this.routID = routID;
        this.stopID = stopID;
        this.stopOrder = stopOrder;
        this.distanceFromStart = distanceFromStart;
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

    public double getDistanceFromStart() {
        return distanceFromStart;
    }

    public void setDistanceFromStart(double distanceFromStart) {
        this.distanceFromStart = distanceFromStart;
    }

    @Override
    public String toString() {
        return "RouteStop{" + "routestopID=" + routestopID + ", routID=" + routID + ", stopID=" + stopID + ", stopOrder=" + stopOrder + ", distanceFromStart=" + distanceFromStart + '}';
    }

    
}
