/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import enums.TicketStatus;
import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class TicketDTO {

    private String ticketCode;
    private long price;
    private TicketStatus status;
    private LocalDateTime purchasedAt;
    
    // cac truong de join
    private String routeNumber;
    private String routeName;

    public TicketDTO() {
    }

    public TicketDTO(String ticketCode, long price, TicketStatus status, LocalDateTime purchasedAt, String routeNumber, String routeName) {
        this.ticketCode = ticketCode;
        this.price = price;
        this.status = status;
        this.purchasedAt = purchasedAt;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
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
    
    
}
