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
public class SearchHistory {

    private int historyID;
    private int accountID;
    private int fromStopID;
    private int toStopID;
    private LocalDateTime searchedAt;

    public SearchHistory() {
    }

    public SearchHistory(int historyID, int accountID, int fromStopID, int toStopID, LocalDateTime searchedAt) {
        this.historyID = historyID;
        this.accountID = accountID;
        this.fromStopID = fromStopID;
        this.toStopID = toStopID;
        this.searchedAt = searchedAt;
    }

    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getFromStopID() {
        return fromStopID;
    }

    public void setFromStopID(int fromStopID) {
        this.fromStopID = fromStopID;
    }

    public int getToStopID() {
        return toStopID;
    }

    public void setToStopID(int toStopID) {
        this.toStopID = toStopID;
    }

    public LocalDateTime getSearchedAt() {
        return searchedAt;
    }

    public void setSearchedAt(LocalDateTime searchedAt) {
        this.searchedAt = searchedAt;
    }

    @Override
    public String toString() {
        return "SearchHistory{" + "fromStopID=" + fromStopID + ", toStopID=" + toStopID + '}';
    }
}
