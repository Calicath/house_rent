package com.house.rental.dao.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.House;
import com.house.rental.bean.Tenant;
import com.house.rental.bean.Transaction;
import com.house.rental.bean.User;
import com.house.rental.dao.HouseDAO;
import com.house.rental.dao.TenantDAO;
import com.house.rental.dao.TransactionDAO;
import com.house.rental.dao.UserDAO;
import com.house.rental.util.DBUtil;

public class TransactionDAOImpl implements TransactionDAO {
    private final HouseDAO houseDAO;
    private final TenantDAO tenantDAO;
    private final UserDAO userDAO;

    public TransactionDAOImpl() {
        this.houseDAO = new HouseDAOImpl();
        this.tenantDAO = new TenantDAOImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public void createTransaction(Transaction transaction) throws Exception {
        String sql = "INSERT INTO transactions (house_id, tenant_id, owner_id, start_date, end_date, " +
                    "rent_amount, deposit_amount, status, payment_status, contract_number, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, transaction.getHouseId());
            stmt.setInt(2, transaction.getTenantId());
            stmt.setInt(3, transaction.getOwnerId());
            stmt.setDate(4, Date.valueOf(transaction.getStartDate()));
            stmt.setDate(5, Date.valueOf(transaction.getEndDate()));
            stmt.setBigDecimal(6, transaction.getRentAmount());
            stmt.setBigDecimal(7, transaction.getDepositAmount());
            stmt.setString(8, transaction.getStatus());
            stmt.setString(9, transaction.getPaymentStatus());
            stmt.setString(10, transaction.getContractNumber());
            stmt.setString(11, transaction.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("创建交易失败，没有行被影响。");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    transaction.setTransactionId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("创建交易失败，未获取到ID。");
                }
            }
        }
    }

    @Override
    public void updateTransaction(Transaction transaction) throws Exception {
        String sql = "UPDATE transactions SET house_id=?, tenant_id=?, owner_id=?, start_date=?, " +
                    "end_date=?, rent_amount=?, deposit_amount=?, status=?, payment_date=?, " +
                    "payment_method=?, payment_status=?, contract_number=?, notes=? WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, transaction.getHouseId());
            stmt.setInt(2, transaction.getTenantId());
            stmt.setInt(3, transaction.getOwnerId());
            stmt.setDate(4, Date.valueOf(transaction.getStartDate()));
            stmt.setDate(5, Date.valueOf(transaction.getEndDate()));
            stmt.setBigDecimal(6, transaction.getRentAmount());
            stmt.setBigDecimal(7, transaction.getDepositAmount());
            stmt.setString(8, transaction.getStatus());
            stmt.setTimestamp(9, transaction.getPaymentDate() != null ? 
                        Timestamp.valueOf(transaction.getPaymentDate()) : null);
            stmt.setString(10, transaction.getPaymentMethod());
            stmt.setString(11, transaction.getPaymentStatus());
            stmt.setString(12, transaction.getContractNumber());
            stmt.setString(13, transaction.getNotes());
            stmt.setInt(14, transaction.getTransactionId());
            
            stmt.executeUpdate();
        }
    }

    @Override
    public void deleteTransaction(int transactionId) throws Exception {
        String sql = "DELETE FROM transactions WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            stmt.executeUpdate();
        }
    }

    @Override
    public Transaction getTransactionById(int transactionId) throws Exception {
        String sql = "SELECT * FROM transactions WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractTransactionFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Transaction> getAllTransactions() throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByHouseId(int houseId) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE house_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, houseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByTenantId(int tenantId) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tenantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByOwnerId(int ownerId) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE owner_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByStatus(String status) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE status=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByPaymentStatus(String paymentStatus) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE payment_status=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentStatus);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public void updateTransactionStatus(int transactionId, String status) throws Exception {
        String sql = "UPDATE transactions SET status=? WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, transactionId);
            stmt.executeUpdate();
        }
    }

    @Override
    public void updatePaymentStatus(int transactionId, String paymentStatus) throws Exception {
        String sql = "UPDATE transactions SET payment_status=? WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentStatus);
            stmt.setInt(2, transactionId);
            stmt.executeUpdate();
        }
    }

    @Override
    public void updatePaymentInfo(int transactionId, String paymentMethod, LocalDateTime paymentDate) throws Exception {
        String sql = "UPDATE transactions SET payment_method=?, payment_date=? WHERE transaction_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentMethod);
            stmt.setTimestamp(2, java.sql.Timestamp.valueOf(paymentDate));
            stmt.setInt(3, transactionId);
            stmt.executeUpdate();
        }
    }

    @Override
    public List<Transaction> searchTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate, int page, int pageSize) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM transactions WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (contract_number LIKE ? OR status LIKE ? OR payment_status LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status=?");
            params.add(status);
        }
        if (paymentStatus != null && !paymentStatus.isEmpty()) {
            sql.append(" AND payment_status=?");
            params.add(paymentStatus);
        }
        if (startDate != null) {
            sql.append(" AND start_date >= ?");
            params.add(Date.valueOf(startDate));
        }
        if (endDate != null) {
            sql.append(" AND end_date <= ?");
            params.add(Date.valueOf(endDate));
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    @Override
    public List<Transaction> getTransactionsByDateRange(LocalDate startDate, LocalDate endDate) throws Exception {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE start_date >= ? AND end_date <= ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, java.sql.Date.valueOf(startDate));
            stmt.setDate(2, java.sql.Date.valueOf(endDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(extractTransactionFromResultSet(rs));
                }
            }
        }
        return transactions;
    }

    public boolean validateTransaction(Transaction transaction) throws Exception {
        // Validation logic, e.g., check for overlapping dates, valid amounts, etc.
        // This is a placeholder and should be implemented based on business rules.
        // For simplicity, always return true for now.
        return true;
    }

    public boolean isTransactionActive(int transactionId) throws Exception {
        String sql = "SELECT status FROM transactions WHERE transaction_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    return "active".equalsIgnoreCase(status) || "pending".equalsIgnoreCase(status);
                }
            }
        }
        return false;
    }

    public String generateContractNumber() throws Exception {
        // Implement logic to generate a unique contract number
        // For example: TRN-YYYYMMDD-XXXX
        LocalDate now = LocalDate.now();
        String datePart = String.format("%04d%02d%02d", now.getYear(), now.getMonthValue(), now.getDayOfMonth());
        // A simple random number for now, replace with a more robust unique ID generation
        int randomPart = (int) (Math.random() * 10000); 
        return "TRN-" + datePart + "-" + String.format("%04d", randomPart);
    }

    public BigDecimal calculateRent(int houseId, LocalDate startDate, LocalDate endDate) throws Exception {
        House house = houseDAO.getHouseById(houseId);
        if (house == null || house.getRent() == null) {
            throw new IllegalArgumentException("House not found or rent amount not set.");
        }

        long days = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);
        // Assuming rent is per month and converting to daily rate for calculation simplicity
        // This might need more precise business logic depending on how rent is charged
        BigDecimal dailyRent = house.getRent().divide(BigDecimal.valueOf(30), RoundingMode.HALF_UP);
        return dailyRent.multiply(BigDecimal.valueOf(days));
    }

    @Override
    public int getTotalTransactions(String keyword, String status, String paymentStatus, LocalDate startDate, LocalDate endDate) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM transactions WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (contract_number LIKE ? OR status LIKE ? OR payment_status LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status=?");
            params.add(status);
        }
        if (paymentStatus != null && !paymentStatus.isEmpty()) {
            sql.append(" AND payment_status=?");
            params.add(paymentStatus);
        }
        if (startDate != null) {
            sql.append(" AND start_date >= ?");
            params.add(java.sql.Date.valueOf(startDate));
        }
        if (endDate != null) {
            sql.append(" AND end_date <= ?");
            params.add(java.sql.Date.valueOf(endDate));
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private Transaction extractTransactionFromResultSet(ResultSet rs) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setTransactionId(rs.getInt("transaction_id"));
        transaction.setHouseId(rs.getInt("house_id"));
        transaction.setTenantId(rs.getInt("tenant_id"));
        transaction.setOwnerId(rs.getInt("owner_id"));
        
        java.sql.Date startDateSql = rs.getDate("start_date");
        if (startDateSql != null) {
            transaction.setStartDate(startDateSql.toLocalDate());
        }

        java.sql.Date endDateSql = rs.getDate("end_date");
        if (endDateSql != null) {
            transaction.setEndDate(endDateSql.toLocalDate());
        }

        transaction.setRentAmount(rs.getBigDecimal("rent_amount"));
        transaction.setDepositAmount(rs.getBigDecimal("deposit_amount"));
        transaction.setStatus(rs.getString("status"));

        java.sql.Timestamp paymentDateSql = rs.getTimestamp("payment_date");
        if (paymentDateSql != null) {
            transaction.setPaymentDate(paymentDateSql.toLocalDateTime());
        }
        
        transaction.setPaymentMethod(rs.getString("payment_method"));
        transaction.setPaymentStatus(rs.getString("payment_status"));
        transaction.setContractNumber(rs.getString("contract_number"));
        transaction.setNotes(rs.getString("notes"));

        try {
            House house = houseDAO.getHouseById(transaction.getHouseId());
            if (house != null) {
                transaction.setHouse(house);
            }
            Tenant tenant = tenantDAO.getTenantById(transaction.getTenantId());
            if (tenant != null) {
                transaction.setTenant(tenant);
            }
            User owner = userDAO.getUserById(transaction.getOwnerId());
            if (owner != null) {
                transaction.setOwner(owner);
            }
        } catch (Exception e) {
            System.err.println("Error fetching associated entities for transaction: " + e.getMessage());
            // Optionally log the exception or handle it more robustly
        }
        return transaction;
    }
} 