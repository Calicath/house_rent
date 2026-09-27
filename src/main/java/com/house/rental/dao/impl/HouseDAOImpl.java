package com.house.rental.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.house.rental.bean.House;
import com.house.rental.dao.HouseDAO;
import com.house.rental.util.DBUtil;

public class HouseDAOImpl implements HouseDAO {
    
    @Override
    public void addHouse(House house) {
        String sql = "INSERT INTO houses (owner_id, title, description, address, rent_amount, status, type, size, decorate, floor, bedrooms, bathrooms, images, rules) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, house.getOwnerId());
            pstmt.setString(2, house.getTitle());
            pstmt.setString(3, house.getDescription());
            pstmt.setString(4, house.getAddress());
            pstmt.setBigDecimal(5, house.getRent());
            pstmt.setString(6, house.getStatus());
            pstmt.setInt(7, house.getType());
            pstmt.setInt(8, house.getSize());
            pstmt.setString(9, house.getDecorate());
            pstmt.setString(10, house.getFloor());
            pstmt.setInt(11, house.getBedrooms());
            pstmt.setInt(12, house.getBathrooms());
            // Convert List<String> images to comma-separated string
            String imagesStr = (house.getImages() != null && !house.getImages().isEmpty()) ? 
                String.join(",", house.getImages()) : null;
            pstmt.setString(13, imagesStr);
            pstmt.setString(14, house.getRules());
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        house.setHouseId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateHouse(House house) {
        String sql = "UPDATE houses SET owner_id=?, title=?, description=?, address=?, rent_amount=?, status=?, type=?, size=?, decorate=?, floor=?, bedrooms=?, bathrooms=?, images=?, rules=? " +
                    "WHERE house_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, house.getOwnerId());
            pstmt.setString(2, house.getTitle());
            pstmt.setString(3, house.getDescription());
            pstmt.setString(4, house.getAddress());
            pstmt.setBigDecimal(5, house.getRent());
            pstmt.setString(6, house.getStatus());
            pstmt.setInt(7, house.getType());
            pstmt.setInt(8, house.getSize());
            pstmt.setString(9, house.getDecorate());
            pstmt.setString(10, house.getFloor());
            pstmt.setInt(11, house.getBedrooms());
            pstmt.setInt(12, house.getBathrooms());
            pstmt.setString(13, String.join(",", house.getImages()));
            pstmt.setString(14, house.getRules());
            pstmt.setInt(15, house.getHouseId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteHouse(int houseId) {
        String sql = "DELETE FROM houses WHERE house_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, houseId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public House getHouseById(int houseId) {
        String sql = "SELECT * FROM houses WHERE house_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, houseId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractHouse(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<House> getAllHouses() {
        List<House> houses = new ArrayList<>();
        String sql = "SELECT * FROM houses ORDER BY house_id DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public List<House> getHousesByOwnerId(int ownerId) {
        List<House> houses = new ArrayList<>();
        String sql = "SELECT * FROM houses WHERE owner_id=? ORDER BY house_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public List<House> getHousesByStatus(String status) {
        List<House> houses = new ArrayList<>();
        String sql = "SELECT * FROM houses WHERE status = ? ORDER BY house_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public List<House> searchHouses(String keyword) {
        List<House> houses = new ArrayList<>();
        String sql = "SELECT * FROM houses WHERE title LIKE ? OR address LIKE ? OR description LIKE ? ORDER BY house_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, "%" + keyword + "%");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public List<House> searchHouses(String keyword, String status, String rooms, String minPrice, String maxPrice, int page, int pageSize) {
        List<House> houses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM houses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (title LIKE ? OR address LIKE ? OR description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (rooms != null && !rooms.isEmpty()) {
            try {
                int numRooms = Integer.parseInt(rooms);
                sql.append(" AND bedrooms = ?");
                params.add(numRooms);
            } catch (NumberFormatException e) {
                // Ignored, not a valid number
            }
        }
        if (minPrice != null && !minPrice.isEmpty()) {
            try {
                BigDecimal minP = new BigDecimal(minPrice);
                sql.append(" AND rent_amount >= ?");
                params.add(minP);
            } catch (NumberFormatException e) {
                // Ignored, not a valid number
            }
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            try {
                BigDecimal maxP = new BigDecimal(maxPrice);
                sql.append(" AND rent_amount <= ?");
                params.add(maxP);
            } catch (NumberFormatException e) {
                // Ignored, not a valid number
            }
        }

        sql.append(" ORDER BY house_id DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public int getTotalHouses(String keyword, String status, String rooms, String minPrice, String maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM houses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (title LIKE ? OR address LIKE ? OR description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (rooms != null && !rooms.isEmpty()) {
            try {
                int numRooms = Integer.parseInt(rooms);
                sql.append(" AND bedrooms = ?");
                params.add(numRooms);
            } catch (NumberFormatException e) {
                // Ignored
            }
        }
        if (minPrice != null && !minPrice.isEmpty()) {
            try {
                BigDecimal minP = new BigDecimal(minPrice);
                sql.append(" AND rent_amount >= ?");
                params.add(minP);
            } catch (NumberFormatException e) {
                // Ignored
            }
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            try {
                BigDecimal maxP = new BigDecimal(maxPrice);
                sql.append(" AND rent_amount <= ?");
                params.add(maxP);
            } catch (NumberFormatException e) {
                // Ignored
            }
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<House> getAvailableHouses() {
        List<House> houses = new ArrayList<>();
        String sql = "SELECT * FROM houses WHERE status='Available' ORDER BY house_id DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                houses.add(extractHouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return houses;
    }

    @Override
    public void updateHouseStatus(int houseId, String status) {
        String sql = "UPDATE houses SET status=? WHERE house_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, houseId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private House extractHouse(ResultSet rs) throws SQLException {
        House house = new House();
        house.setHouseId(rs.getInt("house_id"));
        house.setOwnerId(rs.getInt("owner_id"));
        house.setTitle(rs.getString("title"));
        house.setDescription(rs.getString("description"));
        house.setAddress(rs.getString("address"));
        house.setRent(rs.getBigDecimal("rent_amount"));
        house.setStatus(rs.getString("status"));
        house.setType(rs.getInt("type"));
        house.setSize(rs.getInt("size"));
        house.setDecorate(rs.getString("decorate"));
        house.setFloor(rs.getString("floor"));
        house.setBedrooms(rs.getInt("bedrooms"));
        house.setBathrooms(rs.getInt("bathrooms"));
        // Convert comma-separated string back to List<String>
        String imagesStr = rs.getString("images");
        if (imagesStr != null && !imagesStr.isEmpty()) {
            house.setImages(Arrays.asList(imagesStr.split(",")));
        } else {
            house.setImages(new ArrayList<>());
        }
        house.setRules(rs.getString("rules"));
        return house;
    }
} 