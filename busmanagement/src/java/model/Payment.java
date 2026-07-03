package model;

import java.sql.Timestamp;

/**
 * Model đại diện cho một giao dịch thanh toán.
 * Hỗ trợ thanh toán cho Vé lẻ (TicketID) HOẶC Vé tháng (PassID).
 */
public class Payment {

    public enum PaymentStatus { PENDING, SUCCESS, FAILED, REFUNDED }

    private int paymentID;
    private int accountID;
    private Integer ticketID;   // NULL nếu thanh toán vé tháng
    private Integer passID;     // NULL nếu thanh toán vé lẻ
    private long amount;
    private String paymentMethod; // VNPAY, MOMO, QR_BANK, CASH, ...
    private String transactionCode;
    private String qrImage;
    private PaymentStatus paymentStatus;
    private Timestamp paidAt;
    private Timestamp createdAt;

    public Payment() {}

    public int getPaymentID() { return paymentID; }
    public void setPaymentID(int paymentID) { this.paymentID = paymentID; }

    public int getAccountID() { return accountID; }
    public void setAccountID(int accountID) { this.accountID = accountID; }

    public Integer getTicketID() { return ticketID; }
    public void setTicketID(Integer ticketID) { this.ticketID = ticketID; }

    public Integer getPassID() { return passID; }
    public void setPassID(Integer passID) { this.passID = passID; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionCode() { return transactionCode; }
    public void setTransactionCode(String transactionCode) { this.transactionCode = transactionCode; }

    public String getQrImage() { return qrImage; }
    public void setQrImage(String qrImage) { this.qrImage = qrImage; }

    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Payment{paymentID=" + paymentID + ", amount=" + amount
                + ", method=" + paymentMethod + ", status=" + paymentStatus + '}';
    }
}
