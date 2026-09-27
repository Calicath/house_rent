package com.house.rental.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.ViewingRecord;
import com.house.rental.bean.House;
import com.house.rental.bean.Tenant;
import com.house.rental.bean.User;
import com.house.rental.dao.ViewingRecordDAO;
import com.house.rental.util.DBUtil;

public class ViewingRecordDAOImpl implements ViewingRecordDAO {
    
    @Override
    public void addViewingRecord(ViewingRecord record) {
        String sql = "INSERT INTO viewing_records (house_id, tenant_id, viewing_time, status, message) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, record.getHouseId());
            pstmt.setInt(2, record.getTenantId());
            pstmt.setTimestamp(3, Timestamp.valueOf(record.getViewingTime()));
            pstmt.setString(4, record.getStatus());
            pstmt.setString(5, record.getMessage());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        record.setRecordId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateViewingRecord(ViewingRecord record) {
        String sql = "UPDATE viewing_records SET house_id=?, tenant_id=?, viewing_time=?, status=?, message=? WHERE record_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, record.getHouseId());
            pstmt.setInt(2, record.getTenantId());
            pstmt.setTimestamp(3, Timestamp.valueOf(record.getViewingTime()));
            pstmt.setString(4, record.getStatus());
            pstmt.setString(5, record.getMessage());
            pstmt.setInt(6, record.getRecordId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteViewingRecord(int recordId) {
        String sql = "DELETE FROM viewing_records WHERE record_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, recordId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ViewingRecord getViewingRecordById(int recordId) {
        String sql = "SELECT * FROM viewing_records WHERE record_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, recordId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractViewingRecord(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByTenantId(int tenantId) {
        List<ViewingRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM viewing_records WHERE tenant_id=? ORDER BY viewing_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                records.add(extractViewingRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByHouseId(int houseId) {
        List<ViewingRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM viewing_records WHERE house_id=? ORDER BY viewing_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, houseId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                records.add(extractViewingRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByHouseIds(List<Integer> houseIds) {
        List<ViewingRecord> records = new ArrayList<>();
        if (houseIds == null || houseIds.isEmpty()) {
            return records;
        }
        
        // 构建 IN 子句的占位符
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < houseIds.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        
        String sql = "SELECT * FROM viewing_records WHERE house_id IN (" + placeholders.toString() + ") ORDER BY viewing_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < houseIds.size(); i++) {
                pstmt.setInt(i + 1, houseIds.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                records.add(extractViewingRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    @Override
    public List<ViewingRecord> getViewingRecordsWithDetailsByOwnerId(int ownerId) {
        List<ViewingRecord> records = new ArrayList<>();
        
        // 使用JOIN查询一次性获取所有相关数据
        String sql = "SELECT " +
                    "vr.record_id, vr.house_id, vr.tenant_id, vr.viewing_time, vr.status, vr.message, " +
                    "h.title as house_title, h.address as house_address, h.rent_amount, h.bedrooms, h.bathrooms, " +
                    "t.id_card, t.gender, t.status as tenant_status, " +
                    "u.username as tenant_username, u.email as tenant_user_email, u.phone as tenant_user_phone " +
                    "FROM viewing_records vr " +
                    "INNER JOIN houses h ON vr.house_id = h.house_id " +
                    "INNER JOIN tenants t ON vr.tenant_id = t.tenant_id " +
                    "INNER JOIN users u ON t.user_id = u.user_id " +
                    "WHERE h.owner_id = ? " +
                    "ORDER BY vr.viewing_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                records.add(extractViewingRecordWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    @Override
    public List<ViewingRecord> getAllViewingRecords() {
        List<ViewingRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM viewing_records ORDER BY viewing_time DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                records.add(extractViewingRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    private ViewingRecord extractViewingRecord(ResultSet rs) throws SQLException {
        ViewingRecord record = new ViewingRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setHouseId(rs.getInt("house_id"));
        record.setTenantId(rs.getInt("tenant_id"));
        
        // 安全地处理viewing_time字段
        java.sql.Timestamp viewingTime = rs.getTimestamp("viewing_time");
        if (viewingTime != null) {
            record.setViewingTime(viewingTime.toLocalDateTime());
        }
        
        record.setStatus(rs.getString("status"));
        record.setMessage(rs.getString("message"));
        
        // 设置默认的创建时间和更新时间（因为数据库中没有这些字段）
        LocalDateTime now = LocalDateTime.now();
        record.setCreatedAt(now);
        record.setUpdatedAt(now);
        
        return record;
    }

    private ViewingRecord extractViewingRecordWithDetails(ResultSet rs) throws SQLException {
        ViewingRecord record = new ViewingRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setHouseId(rs.getInt("house_id"));
        record.setTenantId(rs.getInt("tenant_id"));
        
        // 安全地处理viewing_time字段
        java.sql.Timestamp viewingTime = rs.getTimestamp("viewing_time");
        if (viewingTime != null) {
            record.setViewingTime(viewingTime.toLocalDateTime());
        }
        
        record.setStatus(rs.getString("status"));
        record.setMessage(rs.getString("message"));
        
        // 设置默认的创建时间和更新时间（因为数据库中没有这些字段）
        LocalDateTime now = LocalDateTime.now();
        record.setCreatedAt(now);
        record.setUpdatedAt(now);
        
        // 创建并设置House对象
        House house = new House();
        house.setHouseId(rs.getInt("house_id"));
        house.setTitle(rs.getString("house_title"));
        house.setAddress(rs.getString("house_address"));
        house.setRent(rs.getBigDecimal("rent_amount"));
        house.setBedrooms(rs.getInt("bedrooms"));
        house.setBathrooms(rs.getInt("bathrooms"));
        record.setHouse(house);
        
        // 创建并设置Tenant对象
        Tenant tenant = new Tenant();
        tenant.setTenantId(rs.getInt("tenant_id"));
        tenant.setIdCard(rs.getString("id_card"));
        tenant.setGender(rs.getString("gender"));
        tenant.setStatus(rs.getString("tenant_status"));
        
        // 创建并设置User对象
        User user = new User();
        user.setUsername(rs.getString("tenant_username"));
        user.setEmail(rs.getString("tenant_user_email"));
        user.setPhone(rs.getString("tenant_user_phone"));
        tenant.setUser(user);
        
        record.setTenant(tenant);
        
        return record;
    }
} 