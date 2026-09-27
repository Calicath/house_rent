package com.house.rental.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.Payment;
import com.house.rental.service.PaymentService;
import com.house.rental.util.DBUtil;

public class PaymentServiceImpl implements PaymentService {

    @Override
    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (transaction_id, user_id, amount, payment_date, payment_method, status, notes, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, payment.getTransactionId());
            stmt.setInt(2, payment.getUserId());
            stmt.setBigDecimal(3, payment.getAmount());
            stmt.setTimestamp(4, Timestamp.valueOf(payment.getPaymentDate()));
            stmt.setString(5, payment.getPaymentMethod());
            stmt.setString(6, payment.getStatus());
            stmt.setString(7, payment.getNotes());
            stmt.setString(8, payment.getType());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        payment.setPaymentId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE payments SET transaction_id = ?, user_id = ?, amount = ?, payment_date = ?, payment_method = ?, status = ?, notes = ?, type = ? WHERE payment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getTransactionId());
            stmt.setInt(2, payment.getUserId());
            stmt.setBigDecimal(3, payment.getAmount());
            stmt.setTimestamp(4, Timestamp.valueOf(payment.getPaymentDate()));
            stmt.setString(5, payment.getPaymentMethod());
            stmt.setString(6, payment.getStatus());
            stmt.setString(7, payment.getNotes());
            stmt.setString(8, payment.getType());
            stmt.setInt(9, payment.getPaymentId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Payment> getPaymentsByTransactionId(int transactionId) {
        String sql = "SELECT * FROM payments WHERE transaction_id = ? ORDER BY payment_date DESC";
        return getPayments(sql, transactionId);
    }

    @Override
    public List<Payment> getPaymentsByUserId(int userId) {
        String sql = "SELECT * FROM payments WHERE user_id = ? ORDER BY payment_date DESC";
        return getPayments(sql, userId);
    }

    @Override
    public List<Payment> getPaymentsByStatus(String status) {
        String sql = "SELECT * FROM payments WHERE status = ? ORDER BY payment_date DESC";
        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(extractPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    @Override
    public List<Payment> getPaymentsByTenantId(int tenantId) {
        String sql = "SELECT p.* FROM payments p JOIN transactions t ON p.transaction_id = t.transaction_id WHERE t.tenant_id = ? ORDER BY p.payment_date DESC";
        return getPayments(sql, tenantId);
    }

    @Override
    public List<Payment> getPaymentsByOwnerId(int ownerId) {
        String sql = "SELECT p.* FROM payments p JOIN transactions t ON p.transaction_id = t.transaction_id JOIN houses h ON t.house_id = h.house_id WHERE h.owner_id = ? ORDER BY p.payment_date DESC";
        return getPayments(sql, ownerId);
    }

    private List<Payment> getPayments(String sql, int id) {
        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(extractPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setTransactionId(rs.getInt("transaction_id"));
        payment.setUserId(rs.getInt("user_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentDate(rs.getTimestamp("payment_date").toLocalDateTime());
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setStatus(rs.getString("status"));
        payment.setNotes(rs.getString("notes"));
        payment.setType(rs.getString("type"));
        return payment;
    }
} 