/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import enums.PassStatus;
import java.time.LocalDate;
import model.MonthlyPass;

/**
 *
 * @author Administrator
 */
public class MonthlyPass {

    private int passID;
    private int accountID;
    private Integer routeID; // Có thể NULL nếu đi liên tuyến
    private int passTypeID;
    private String passCode;
    private LocalDate startDate;
    private LocalDate endDate;
    private long price;
    private PassStatus status; // Enum: PENDING, APPROVED, REJECTED, EXPIRED
    private String imageProof;
    private Integer approvedBy;
    private LocalDate approvedAt;
    private LocalDate createdAt;
    private String qrCodeToken;          // BỔ SUNG: Token bảo mật QR Code
    private java.sql.Timestamp lastUsedAt; // BỔ SUNG: Lần quét thẻ gần nhất

    public MonthlyPass() {
    }

 
public MonthlyPass(int passID, int accountID, Integer routeID, int passTypeID, String passCode, LocalDate startDate, LocalDate endDate, long price, PassStatus status, String imageProof, Integer approvedBy, LocalDate approvedAt, LocalDate createdAt, String qrCodeToken, java.sql.Timestamp lastUsedAt) {
    this.passID = passID;
    this.accountID = accountID;
    this.routeID = routeID;
    this.passTypeID = passTypeID;
    this.passCode = passCode;
    this.startDate = startDate;
    this.endDate = endDate;
    this.price = price;
    this.status = status;
    this.imageProof = imageProof;
    this.approvedBy = approvedBy;
    this.approvedAt = approvedAt;
    this.createdAt = createdAt;
    this.qrCodeToken = qrCodeToken; // Added
    this.lastUsedAt = lastUsedAt;   // Added
}

    public int getPassID() {
        return passID;
    }

    public void setPassID(int passID) {
        this.passID = passID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public Integer getRouteID() {
        return routeID;
    }

    public void setRouteID(Integer routeID) {
        this.routeID = routeID;
    }

    public int getPassTypeID() {
        return passTypeID;
    }

    public void setPassTypeID(int passTypeID) {
        this.passTypeID = passTypeID;
    }

    public String getPassCode() {
        return passCode;
    }

    public void setPassCode(String passCode) {
        this.passCode = passCode;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public PassStatus getStatus() {
        return status;
    }

    public void setStatus(PassStatus status) {
        this.status = status;
    }

    public String getImageProof() {
        return imageProof;
    }

    public void setImageProof(String imageProof) {
        this.imageProof = imageProof;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDate getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDate approvedAt) {
        this.approvedAt = approvedAt;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public String getQrCodeToken() {
        return qrCodeToken;
    }

    public void setQrCodeToken(String qrCodeToken) {
        this.qrCodeToken = qrCodeToken;
    }

    public java.sql.Timestamp getLastUsedAt() {
        return lastUsedAt;
    }

    public void setLastUsedAt(java.sql.Timestamp lastUsedAt) {
        this.lastUsedAt = lastUsedAt;
    }

    @Override
    public String toString() {
        return "MonthlyPass{" + "passCode='" + passCode + '\'' + ", status=" + status + ", qrCodeToken=" + qrCodeToken + '}';
    }
}
