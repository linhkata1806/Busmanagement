package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho một mã giảm giá (Discount Code).
 */
public class Discount {

    private int discountID;
    private String discountCode;
    private double discountPercent;
    private long minimumAmount;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;
    private String description;

    public Discount() {}

    public Discount(int discountID, String discountCode, double discountPercent, long minimumAmount, Timestamp startDate, Timestamp endDate, boolean isActive, String description) {
        this.discountID = discountID;
        this.discountCode = discountCode;
        this.discountPercent = discountPercent;
        this.minimumAmount = minimumAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.description = description;
    }
    

    public int getDiscountID() { return discountID; }
    public void setDiscountID(int discountID) { this.discountID = discountID; }

    public String getDiscountCode() { return discountCode; }
    public void setDiscountCode(String discountCode) { this.discountCode = discountCode; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public long getMinimumAmount() { return minimumAmount; }
    public void setMinimumAmount(long minimumAmount) { this.minimumAmount = minimumAmount; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return "Discount{code='" + discountCode + "', percent=" + discountPercent + "%, active=" + isActive + '}';
    }
}
