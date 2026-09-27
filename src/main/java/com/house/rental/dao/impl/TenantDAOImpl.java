package com.house.rental.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.house.rental.bean.Tenant;
import com.house.rental.bean.User;
import com.house.rental.dao.TenantDAO;
import com.house.rental.dao.UserDAO;
import com.house.rental.util.DBUtil;

public class TenantDAOImpl implements TenantDAO {
    private UserDAO userDAO;

    public TenantDAOImpl() {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public void addTenant(Tenant tenant) throws Exception {
        String sql = "INSERT INTO tenants (user_id, id_card, gender, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, tenant.getUserId());
            stmt.setString(2, tenant.getIdCard());
            stmt.setString(3, tenant.getGender());
            stmt.setString(4, tenant.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("创建租户失败，没有行被影响。");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    tenant.setTenantId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("创建租户失败，未获取到ID。");
                }
            }
        }
    }

    @Override
    public void updateTenant(Tenant tenant) throws Exception {
        String sql = "UPDATE tenants SET id_card=?, gender=?, move_in_date=?, move_out_date=?, " +
                    "status=?, emergency_contact=?, emergency_phone=?, occupation=?, employer=?, " +
                    "income=?, credit_score=?, notes=? WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tenant.getIdCard());
            stmt.setString(2, tenant.getGender());
            stmt.setDate(3, tenant.getMoveInDate() != null ? new java.sql.Date(tenant.getMoveInDate().getTime()) : null);
            stmt.setDate(4, tenant.getMoveOutDate() != null ? new java.sql.Date(tenant.getMoveOutDate().getTime()) : null);
            stmt.setString(5, tenant.getStatus());
            stmt.setString(6, tenant.getEmergencyContact());
            stmt.setString(7, tenant.getEmergencyPhone());
            stmt.setString(8, tenant.getOccupation());
            stmt.setString(9, tenant.getEmployer());
            stmt.setString(10, tenant.getIncome());
            stmt.setString(11, tenant.getCreditScore());
            stmt.setString(12, tenant.getNotes());
            stmt.setInt(13, tenant.getTenantId());
            
            stmt.executeUpdate();
        }
    }

    @Override
    public void deleteTenant(int tenantId) throws Exception {
        String sql = "DELETE FROM tenants WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tenantId);
            stmt.executeUpdate();
        }
    }

    @Override
    public Tenant getTenantById(int tenantId) throws Exception {
        String sql = "SELECT * FROM tenants WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tenantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractTenantFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public Tenant getTenantByUserId(int userId) throws Exception {
        String sql = "SELECT * FROM tenants WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractTenantFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Tenant> getAllTenants() throws Exception {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT * FROM tenants";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                tenants.add(extractTenantFromResultSet(rs));
            }
        }
        return tenants;
    }

    @Override
    public List<Tenant> getTenantsByStatus(String status) throws Exception {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT * FROM tenants WHERE status=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tenants.add(extractTenantFromResultSet(rs));
                }
            }
        }
        return tenants;
    }

    @Override
    public void updateTenantStatus(int tenantId, String status) throws Exception {
        String sql = "UPDATE tenants SET status=? WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, tenantId);
            stmt.executeUpdate();
        }
    }

    @Override
    public void updateMoveInDate(int tenantId, Date moveInDate) throws Exception {
        String sql = "UPDATE tenants SET move_in_date=? WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(moveInDate.getTime()));
            stmt.setInt(2, tenantId);
            stmt.executeUpdate();
        }
    }

    @Override
    public void updateMoveOutDate(int tenantId, Date moveOutDate) throws Exception {
        String sql = "UPDATE tenants SET move_out_date=? WHERE tenant_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(moveOutDate.getTime()));
            stmt.setInt(2, tenantId);
            stmt.executeUpdate();
        }
    }

    @Override
    public List<Tenant> searchTenants(String keyword) throws Exception {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.* FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "WHERE u.name LIKE ? OR t.id_card LIKE ? OR u.phone LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tenants.add(extractTenantFromResultSet(rs));
                }
            }
        }
        return tenants;
    }

    @Override
    public Tenant getTenantByIdCard(String idCard) throws Exception {
        String sql = "SELECT * FROM tenants WHERE id_card=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, idCard);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractTenantFromResultSet(rs);
                }
            }
        }
        return null;
    }

    private Tenant extractTenantFromResultSet(ResultSet rs) throws SQLException {
        Tenant tenant = new Tenant();
        tenant.setTenantId(rs.getInt("tenant_id"));
        tenant.setUserId(rs.getInt("user_id"));
        tenant.setIdCard(rs.getString("id_card"));
        tenant.setGender(rs.getString("gender"));
        tenant.setMoveInDate(rs.getDate("move_in_date"));
        tenant.setMoveOutDate(rs.getDate("move_out_date"));
        tenant.setStatus(rs.getString("status"));
        tenant.setEmergencyContact(rs.getString("emergency_contact"));
        tenant.setEmergencyPhone(rs.getString("emergency_phone"));
        tenant.setOccupation(rs.getString("occupation"));
        tenant.setEmployer(rs.getString("employer"));
        tenant.setIncome(rs.getString("income"));
        tenant.setCreditScore(rs.getString("credit_score"));
        tenant.setNotes(rs.getString("notes"));
        
        // 获取关联的用户信息
        try {
            User user = userDAO.getUserById(tenant.getUserId());
            tenant.setUser(user);
        } catch (Exception e) {
            // 如果获取用户信息失败，记录错误但不影响租户信息的获取
            e.printStackTrace();
        }
        
        return tenant;
    }
} 