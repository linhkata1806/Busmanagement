/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class MonthlyPassType {

    private int passTypeID;
    private String typeName;
    private double discountPercentage; // DECIMAL(5,2)
    private String description;

    public MonthlyPassType() {
    }

    public MonthlyPassType(int passTypeID, String typeName, double discountPercentage, String description) {
        this.passTypeID = passTypeID;
        this.typeName = typeName;
        this.discountPercentage = discountPercentage;
        this.description = description;
    }

    public int getPassTypeID() {
        return passTypeID;
    }

    public void setPassTypeID(int passTypeID) {
        this.passTypeID = passTypeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "MonthlyPassType{" + "typeName='" + typeName + '\'' + '}';
    }
}
