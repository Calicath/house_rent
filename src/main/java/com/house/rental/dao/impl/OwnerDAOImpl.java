package com.house.rental.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.Owner;
import com.house.rental.dao.OwnerDAO;
import com.house.rental.util.DBUtil;

public class OwnerDAOImpl implements OwnerDAO {
    
    @Override
    public void addOwner(Owner owner) {
        String sql = "INSERT INTO owners (user_id, name, address, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, owner.getUserId());
            pstmt.setString(2, owner.getName());
            pstmt.setString(3, owner.getAddress());
            pstmt.setString(4, owner.getPhone());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("创建房主失败，没有行被影响。");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    owner.setOwnerId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("创建房主失败，未获取到ID。");
                }
            }
        } catch (SQLException e) {
            System.err.println("创建房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("创建房主失败：" + e.getMessage());
        }
    }

    @Override
    public void updateOwner(Owner owner) {
        String sql = "UPDATE owners SET user_id=?, name=?, address=?, phone=? WHERE owner_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, owner.getUserId());
            pstmt.setString(2, owner.getName());
            pstmt.setString(3, owner.getAddress());
            pstmt.setString(4, owner.getPhone());
            pstmt.setInt(5, owner.getOwnerId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("更新房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("更新房主失败：" + e.getMessage());
        }
    }

    @Override
    public void deleteOwner(int ownerId) {
        String sql = "DELETE FROM owners WHERE owner_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ownerId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("删除房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("删除房主失败：" + e.getMessage());
        }
    }

    @Override
    public Owner getOwnerById(int ownerId) {
        String sql = "SELECT * FROM owners WHERE owner_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractOwnerFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("获取房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取房主失败：" + e.getMessage());
        }
        return null;
    }

    @Override
    public Owner getOwnerByUserId(int userId) {
        String sql = "SELECT * FROM owners WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractOwnerFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("通过用户ID获取房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("通过用户ID获取房主失败：" + e.getMessage());
        }
        return null;
    }

    @Override
    public List<Owner> getAllOwners() {
        List<Owner> owners = new ArrayList<>();
        String sql = "SELECT * FROM owners";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                owners.add(extractOwnerFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("获取所有房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取所有房主失败：" + e.getMessage());
        }
        return owners;
    }

    @Override
    public Owner getOwnerByPhone(String phone) {
        String sql = "SELECT * FROM owners WHERE phone=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, phone);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractOwnerFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("通过电话获取房主失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("通过电话获取房主失败：" + e.getMessage());
        }
        return null;
    }

    private Owner extractOwnerFromResultSet(ResultSet rs) throws SQLException {
        Owner owner = new Owner();
        owner.setOwnerId(rs.getInt("owner_id"));
        owner.setUserId(rs.getInt("user_id"));
        owner.setName(rs.getString("name"));
        owner.setAddress(rs.getString("address"));
        owner.setPhone(rs.getString("phone"));
        return owner;
    }
} 