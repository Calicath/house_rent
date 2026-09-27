package com.house.rental.service.impl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.house.rental.bean.House;
import com.house.rental.bean.Payment;
import com.house.rental.bean.Tenant;
import com.house.rental.bean.Transaction;
import com.house.rental.bean.User;
import com.house.rental.dao.HouseDAO;
import com.house.rental.dao.TenantDAO;
import com.house.rental.dao.TransactionDAO;
import com.house.rental.dao.UserDAO;
import com.house.rental.dao.impl.HouseDAOImpl;
import com.house.rental.dao.impl.TenantDAOImpl;
import com.house.rental.dao.impl.TransactionDAOImpl;
import com.house.rental.dao.impl.UserDAOImpl;
import com.house.rental.service.PaymentService;
import com.house.rental.service.TransactionService;

public class TransactionServiceImpl implements TransactionService {
    private TransactionDAO transactionDAO;
    private HouseDAO houseDAO;
    private TenantDAO tenantDAO;
    private UserDAO userDAO;

    public TransactionServiceImpl() {
        this.transactionDAO = new TransactionDAOImpl();
        this.houseDAO = new HouseDAOImpl();
        this.tenantDAO = new TenantDAOImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public void createTransaction(Transaction transaction) throws Exception {
        // 验证交易信息
        if (!validateTransaction(transaction)) {
            throw new Exception("交易信息验证失败");
        }

        // 检查房屋是否存在且可用
        House house = houseDAO.getHouseById(transaction.getHouseId());
        if (house == null) {
            throw new Exception("房屋不存在");
        }
        if (!"AVAILABLE".equals(house.getStatus())) {
            throw new Exception("房屋不可用");
        }

        // 检查租户是否存在且活跃
        Tenant tenant = tenantDAO.getTenantById(transaction.getTenantId());
        if (tenant == null) {
            throw new Exception("租户不存在");
        }
        if (!"ACTIVE".equals(tenant.getStatus())) {
            throw new Exception("租户状态不活跃");
        }

        // 检查房主是否存在
        User owner = userDAO.getUserById(transaction.getOwnerId());
        if (owner == null) {
            throw new Exception("房主不存在");
        }

        // 生成合同编号
        transaction.setContractNumber(generateContractNumber());

        // 设置初始状态
        transaction.setStatus("PENDING");
        transaction.setPaymentStatus("UNPAID");

        // 创建交易
        transactionDAO.createTransaction(transaction);

        // 更新房屋状态
        house.setStatus("RENTED");
        houseDAO.updateHouse(house);
    }

    @Override
    public void updateTransaction(Transaction transaction) throws Exception {
        // 验证交易信息
        if (!validateTransaction(transaction)) {
            throw new Exception("交易信息验证失败");
        }

        // 检查交易是否存在
        Transaction existingTransaction = transactionDAO.getTransactionById(transaction.getTransactionId());
        if (existingTransaction == null) {
            throw new Exception("交易不存在");
        }

        // 更新交易信息
        transactionDAO.updateTransaction(transaction);
    }

    @Override
    public void deleteTransaction(int transactionId) throws Exception {
        // 检查交易是否存在
        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        if (transaction == null) {
            throw new Exception("交易不存在");
        }

        // 删除交易
        transactionDAO.deleteTransaction(transactionId);

        // 更新房屋状态
        House house = houseDAO.getHouseById(transaction.getHouseId());
        if (house != null) {
            house.setStatus("AVAILABLE");
            houseDAO.updateHouse(house);
        }
    }

    @Override
    public Transaction getTransactionById(int transactionId) throws Exception {
        return transactionDAO.getTransactionById(transactionId);
    }

    @Override
    public List<Transaction> getAllTransactions() throws Exception {
        return transactionDAO.getAllTransactions();
    }

    @Override
    public List<Transaction> getTransactionsByHouseId(int houseId) throws Exception {
        return transactionDAO.getTransactionsByHouseId(houseId);
    }

    @Override
    public List<Transaction> getTransactionsByTenantId(int tenantId) throws Exception {
        return transactionDAO.getTransactionsByTenantId(tenantId);
    }

    @Override
    public List<Transaction> getTransactionsByOwnerId(int ownerId) throws Exception {
        return transactionDAO.getTransactionsByOwnerId(ownerId);
    }

    @Override
    public List<Transaction> getTransactionsByStatus(String status) throws Exception {
        return transactionDAO.getTransactionsByStatus(status);
    }

    @Override
    public List<Transaction> getTransactionsByPaymentStatus(String paymentStatus) throws Exception {
        return transactionDAO.getTransactionsByPaymentStatus(paymentStatus);
    }

    @Override
    public void updateTransactionStatus(int transactionId, String status) throws Exception {
        // 检查交易是否存在
        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        if (transaction == null) {
            throw new Exception("交易不存在");
        }

        // 验证状态值
        if (!isValidStatus(status)) {
            throw new Exception("无效的状态值");
        }

        // 更新状态
        transactionDAO.updateTransactionStatus(transactionId, status);

        // 如果交易完成，更新房屋状态并插入手续费
        if ("COMPLETED".equals(status)) {
            House house = houseDAO.getHouseById(transaction.getHouseId());
            if (house != null) {
                house.setStatus("AVAILABLE");
                houseDAO.updateHouse(house);
            }
            // 自动插入手续费
            PaymentService paymentService = new PaymentServiceImpl();
            Payment fee = new Payment();
            fee.setTransactionId(transactionId);
            fee.setUserId(0); // 系统收取
            fee.setAmount(transaction.getRentAmount().multiply(new java.math.BigDecimal("0.03")));
            fee.setPaymentDate(java.time.LocalDateTime.now());
            fee.setPaymentMethod("SYSTEM");
            fee.setStatus("SUCCESS");
            fee.setNotes("租赁服务手续费");
            fee.setType("FEE");
            paymentService.createPayment(fee);
        }
    }

    @Override
    public void updatePaymentStatus(int transactionId, String paymentStatus) throws Exception {
        // 检查交易是否存在
        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        if (transaction == null) {
            throw new Exception("交易不存在");
        }

        // 验证支付状态值
        if (!isValidPaymentStatus(paymentStatus)) {
            throw new Exception("无效的支付状态值");
        }

        // 更新支付状态
        transactionDAO.updatePaymentStatus(transactionId, paymentStatus);
    }

    @Override
    public void updatePaymentInfo(int transactionId, String paymentMethod, LocalDateTime paymentDate) throws Exception {
        // 检查交易是否存在
        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        if (transaction == null) {
            throw new Exception("交易不存在");
        }

        // 验证支付方式
        if (!isValidPaymentMethod(paymentMethod)) {
            throw new Exception("无效的支付方式");
        }

        // 更新支付信息
        transactionDAO.updatePaymentInfo(transactionId, paymentMethod, paymentDate);
    }

    @Override
    public List<Transaction> searchTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate, int page, int pageSize) throws Exception {
        return transactionDAO.searchTransactions(keyword, status, paymentStatus, startDate, endDate, page, pageSize);
    }

    @Override
    public List<Transaction> getTransactionsByDateRange(LocalDate startDate, LocalDate endDate) throws Exception {
        if (startDate == null || endDate == null) {
            throw new Exception("日期范围不能为空");
        }
        if (startDate.isAfter(endDate) || startDate.isEqual(endDate)) {
            throw new Exception("开始日期不能晚于结束日期");
        }
        return transactionDAO.getTransactionsByDateRange(startDate, endDate);
    }

    @Override
    public boolean validateTransaction(Transaction transaction) throws Exception {
        if (transaction == null) {
            return false;
        }

        // 验证必填字段
        if (transaction.getHouseId() <= 0 ||
            transaction.getTenantId() <= 0 ||
            transaction.getOwnerId() <= 0 ||
            transaction.getStartDate() == null ||
            transaction.getEndDate() == null ||
            transaction.getRentAmount() == null ||
            transaction.getDepositAmount() == null) {
            return false;
        }

        // 验证日期
        if (transaction.getStartDate().isAfter(transaction.getEndDate()) || transaction.getStartDate().isEqual(transaction.getEndDate())) {
            throw new Exception("开始日期不能晚于结束日期");
        }

        // 验证金额
        if (transaction.getRentAmount().doubleValue() <= 0 || transaction.getDepositAmount().doubleValue() < 0) {
            throw new Exception("租金和押金必须是非负数");
        }

        // 验证状态和支付状态
        if (!isValidStatus(transaction.getStatus()) || !isValidPaymentStatus(transaction.getPaymentStatus())) {
            throw new Exception("无效的状态或支付状态");
        }

        return true;
    }

    @Override
    public boolean isTransactionActive(int transactionId) throws Exception {
        Transaction transaction = transactionDAO.getTransactionById(transactionId);
        return transaction != null && "ACTIVE".equals(transaction.getStatus());
    }

    @Override
    public String generateContractNumber() throws Exception {
        return "CONTRACT_" + System.currentTimeMillis();
    }

    @Override
    public BigDecimal calculateRent(int houseId, LocalDate startDate, LocalDate endDate) throws Exception {
        House house = houseDAO.getHouseById(houseId);
        if (house == null) {
            throw new Exception("房屋不存在");
        }
        // Simple calculation: rentAmount per day * number of days
        long days = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);
        return house.getRent().multiply(BigDecimal.valueOf(days));
    }

    private boolean isValidStatus(String status) {
        return "PENDING".equals(status) || "ACTIVE".equals(status) || "COMPLETED".equals(status) || "CANCELLED".equals(status);
    }

    private boolean isValidPaymentStatus(String paymentStatus) {
        return "UNPAID".equals(paymentStatus) || "PARTIAL".equals(paymentStatus) || "PAID".equals(paymentStatus);
    }

    private boolean isValidPaymentMethod(String paymentMethod) {
        return "BANK_TRANSFER".equals(paymentMethod) || "ALIPAY".equals(paymentMethod) || "WECHAT_PAY".equals(paymentMethod) || "CASH".equals(paymentMethod);
    }

    @Override
    public int getTotalTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate) throws Exception {
        return transactionDAO.getTotalTransactions(keyword, status, paymentStatus, startDate, endDate);
    }

    @Override
    public Transaction getActiveTransactionByTenantAndHouse(int tenantId, int houseId) {
        try {
            List<Transaction> list = transactionDAO.getTransactionsByTenantId(tenantId);
            for (Transaction t : list) {
                if (t.getHouseId() == houseId && "ACTIVE".equalsIgnoreCase(t.getStatus())) {
                    return t;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
} 