package com.house.rental.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.User;
import com.house.rental.dao.UserDAO;
import com.house.rental.util.DBUtil;

public class UserDAOImpl implements UserDAO {
    @Override
    public void addUser(User user) {
        String sql = "INSERT INTO users (username, password, email, type, status, reference_id, id_card, gender, address, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getType());
            stmt.setString(5, user.getStatus());
            stmt.setInt(6, user.getReferenceId());
            stmt.setString(7, user.getIdCard());
            stmt.setString(8, user.getGender());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getPhone());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.err.println("添加用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("添加用户失败", e);
        }
    }

    @Override
    public void updateUser(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, email = ?, type = ?, status = ?, reference_id = ?, id_card = ?, gender = ?, address = ?, phone = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getType());
            stmt.setString(5, user.getStatus());
            stmt.setInt(6, user.getReferenceId());
            stmt.setString(7, user.getIdCard());
            stmt.setString(8, user.getGender());
            stmt.setString(9, user.getAddress());
            stmt.setString(10, user.getPhone());
            stmt.setInt(11, user.getUserId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("更新用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("更新用户失败", e);
        }
    }

    @Override
    public void deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("删除用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("删除用户失败", e);
        }
    }

    @Override
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("获取用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取用户失败", e);
        }
        return null;
    }

    @Override
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("获取用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取用户失败", e);
        }
        return null;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("获取用户列表失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取用户列表失败", e);
        }
        return users;
    }

    @Override
    public User getUserByReferenceId(int referenceId, String type) {
        String sql = "SELECT * FROM users WHERE reference_id = ? AND type = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, referenceId);
            stmt.setString(2, type);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("获取用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取用户失败", e);
        }
        return null;
    }
    
    @Override
    public List<User> getUsersByType(String type) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE type = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(extractUserFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("根据类型获取用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("根据类型获取用户失败", e);
        }
        return users;
    }

    @Override
    public User getUserByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("通过电话号码获取用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("通过电话号码获取用户失败", e);
        }
        return null;
    }

    @Override
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("登录失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("登录失败", e);
        }
        return null;
    }

    @Override
    public List<User> searchUsers(String keyword, String type, String status, int page, int pageSize) throws Exception {
        List<User> users = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sqlBuilder.append(" AND (username LIKE ? OR email LIKE ? OR address LIKE ? OR phone LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (type != null && !type.isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sqlBuilder.append(" AND type = ?");
            params.add(type);
        }
        if (status != null && !status.isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }

        // Add pagination
        sqlBuilder.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(extractUserFromResultSet(rs));
                }
            }
        }
        return users;
    }

    @Override
    public int getTotalUsers(String keyword, String type, String status) throws Exception {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sqlBuilder.append(" AND (username LIKE ? OR email LIKE ? OR address LIKE ? OR phone LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (type != null && !type.isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sqlBuilder.append(" AND type = ?");
            params.add(type);
        }
        if (status != null && !status.isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    @Override
    public boolean isUsernameExists(String username) {
        try {
            return getUserByUsername(username) != null;
        } catch (Exception e) {
            System.err.println("检查用户名是否存在失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("检查用户名是否存在失败", e);
        }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setType(rs.getString("type"));
        user.setStatus(rs.getString("status"));
        user.setReferenceId(rs.getInt("reference_id"));
        user.setIdCard(rs.getString("id_card"));
        user.setGender(rs.getString("gender"));
        user.setAddress(rs.getString("address"));
        user.setPhone(rs.getString("phone"));
        return user;
    }
}