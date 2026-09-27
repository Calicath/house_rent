package com.house.rental.bean;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private int paymentId;
    private int transactionId;
    private int userId; // 支付方用户ID，可以是租户或房东
    private BigDecimal amount;
    private LocalDateTime paymentDate;
    private String paymentMethod;
    private String status; // PENDING, COMPLETED, FAILED, REFUNDED
    private String notes;
    private String type; // 支付类型(RENT租金，FEE手续费)

    public Payment() {}

    public Payment(int transactionId, int userId, BigDecimal amount, LocalDateTime paymentDate, String paymentMethod, String status, String notes) {
        this.transactionId = transactionId;
        this.userId = userId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.notes = notes;
    }

    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
} 