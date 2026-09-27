package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.Payment;

public interface PaymentService {
    boolean createPayment(Payment payment);
    boolean updatePayment(Payment payment);
    boolean deletePayment(int paymentId);
    Payment getPaymentById(int paymentId);
    List<Payment> getPaymentsByTransactionId(int transactionId);
    List<Payment> getPaymentsByUserId(int userId);
    List<Payment> getPaymentsByStatus(String status);
    List<Payment> getPaymentsByTenantId(int tenantId);
    List<Payment> getPaymentsByOwnerId(int ownerId);
} 