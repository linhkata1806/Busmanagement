/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import enums.PassStatus;
import java.time.LocalDate;

/**
 *
 * @author Administrator
 */
public class MonthlyPassDTO {

    private String passCode;
    private LocalDate startDate;
    private LocalDate endDate;
    private PassStatus status;
    private String imageProof;

    //cac truong join themm
    private String routeNumber;
    private String routeName;
    private String typeName;

    //cac truong cho staff quan ly
    private int passID;
    private int accountID;
    private String fullName;
    private String qrCodeToken;
    private String email;
    private String phone;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public MonthlyPassDTO() {
    }

    public String getImageProof() {
        return imageProof;
    }

    public void setImageProof(String imageProof) {
        this.imageProof = imageProof;
    }

    public MonthlyPassDTO(String passCode, LocalDate startDate, LocalDate endDate, PassStatus status, String routeNumber, String routeName, String typeName) {
        this.passCode = passCode;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.routeNumber = routeNumber;
        this.routeName = routeName;
        this.typeName = typeName;
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

    public PassStatus getStatus() {
        return status;
    }

    public void setStatus(PassStatus status) {
        this.status = status;
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

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getQrCodeToken() {
        return qrCodeToken;
    }

    public void setQrCodeToken(String qrCodeToken) {
        this.qrCodeToken = qrCodeToken;
    }

}
