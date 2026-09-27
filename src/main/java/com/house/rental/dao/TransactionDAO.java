package com.house.rental.dao;

import java.util.List;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.math.BigDecimal;

import com.house.rental.bean.Transaction;

public interface TransactionDAO {
    // 创建交易
    void createTransaction(Transaction transaction) throws Exception;
    
    // 更新交易信息
    void updateTransaction(Transaction transaction) throws Exception;
    
    // 删除交易
    void deleteTransaction(int transactionId) throws Exception;
    
    // 根据ID获取交易
    Transaction getTransactionById(int transactionId) throws Exception;
    
    // 获取所有交易
    List<Transaction> getAllTransactions() throws Exception;
    
    // 根据房屋ID获取交易列表
    List<Transaction> getTransactionsByHouseId(int houseId) throws Exception;
    
    // 根据租户ID获取交易列表
    List<Transaction> getTransactionsByTenantId(int tenantId) throws Exception;
    
    // 根据房主ID获取交易列表
    List<Transaction> getTransactionsByOwnerId(int ownerId) throws Exception;
    
    // 根据状态获取交易列表
    List<Transaction> getTransactionsByStatus(String status) throws Exception;
    
    // 根据支付状态获取交易列表
    List<Transaction> getTransactionsByPaymentStatus(String paymentStatus) throws Exception;
    
    // 更新交易状态
    void updateTransactionStatus(int transactionId, String status) throws Exception;
    
    // 更新支付状态
    void updatePaymentStatus(int transactionId, String paymentStatus) throws Exception;
    
    // 更新支付信息
    void updatePaymentInfo(int transactionId, String paymentMethod, LocalDateTime paymentDate) throws Exception;
    
    // 搜索交易
    List<Transaction> searchTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate, int page, int pageSize) throws Exception;
    
    // 获取指定日期范围内的交易
    List<Transaction> getTransactionsByDateRange(LocalDate startDate, LocalDate endDate) throws Exception;
    
    // 获取符合搜索条件的交易总数
    int getTotalTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate) throws Exception;
} 