/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import enums.SaleChannel;
import enums.TicketStatus;
import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Ticket {

    private int ticketID;
    private Integer accountID; // Có thể NULL khi bán tiền mặt
    private Integer tripID;    // Có thể NULL 
    private int routeID;
    private String ticketCode;
    private long price;
    private SaleChannel saleChannel; // Enum: ONLINE, COUNTER, ON_BUS
    private TicketStatus status;     // Enum: UNUSED, USED, EXPIRED
    private LocalDateTime purchasedAt;
    private LocalDateTime usedAt;

    public Ticket() {
    }

    public Ticket(int ticketID, Integer accountID, Integer tripID, int routeID, String ticketCode, long price, SaleChannel saleChannel, TicketStatus status, LocalDateTime purchasedAt, LocalDateTime usedAt) {
        this.ticketID = ticketID;
        this.accountID = accountID;
        this.tripID = tripID;
        this.routeID = routeID;
        this.ticketCode = ticketCode;
        this.price = price;
        this.saleChannel = saleChannel;
        this.status = status;
        this.purchasedAt = purchasedAt;
        this.usedAt = usedAt;
    }

    public int getTicketID() {
        return ticketID;
    }

    public void setTicketID(int ticketID) {
        this.ticketID = ticketID;
    }

    public Integer getAccountID() {
        return accountID;
    }

    public void setAccountID(Integer accountID) {
        this.accountID = accountID;
    }

    public Integer getTripID() {
        return tripID;
    }

    public void setTripID(Integer tripID) {
        this.tripID = tripID;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public SaleChannel getSaleChannel() {
        return saleChannel;
    }

    public void setSaleChannel(SaleChannel saleChannel) {
        this.saleChannel = saleChannel;
    }

    public TicketStatus getStatus() {
        return status;
    }

    public void setStatus(TicketStatus status) {
        this.status = status;
    }

    public LocalDateTime getPurchasedAt() {
        return purchasedAt;
    }

    public void setPurchasedAt(LocalDateTime purchasedAt) {
        this.purchasedAt = purchasedAt;
    }

    public LocalDateTime getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }

    @Override
    public String toString() {
        return "Ticket{" + "ticketCode='" + ticketCode + '\'' + ", status=" + status + '}';
    }
}