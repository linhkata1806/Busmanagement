/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Favorite {

    private int accountID;
    private int routeID;
    private LocalDateTime createdAt;

    public Favorite() {
    }

    public Favorite(int accountID, int routeID, LocalDateTime createdAt) {
        this.accountID = accountID;
        this.routeID = routeID;
        this.createdAt = createdAt;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Favorite{" + "accountID=" + accountID + ", routeID=" + routeID + '}';
    }
}
