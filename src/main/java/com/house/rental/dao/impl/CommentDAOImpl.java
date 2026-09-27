package com.house.rental.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.Comment;
import com.house.rental.bean.User;
import com.house.rental.dao.CommentDAO;
import com.house.rental.util.DBUtil;

import java.time.LocalDateTime;
import java.sql.Types;

public class CommentDAOImpl implements CommentDAO {
    @Override
    public void addComment(Comment comment) {
        String sql = "INSERT INTO forum_comments (post_id, user_id, parent_id, content, status, like_count, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, comment.getPostId());
            pstmt.setInt(2, comment.getUserId());
            if (comment.getParentId() != null) {
                pstmt.setInt(3, comment.getParentId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            pstmt.setString(4, comment.getContent());
            pstmt.setString(5, comment.getStatus());
            pstmt.setInt(6, comment.getLikeCount());
            pstmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            
            pstmt.executeUpdate();
            
            // 获取生成的ID
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                comment.setCommentId(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateComment(Comment comment) {
        String sql = "UPDATE forum_comments SET content=?, status=?, updated_at=? WHERE comment_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, comment.getContent());
            pstmt.setString(2, comment.getStatus());
            pstmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(4, comment.getCommentId());
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteComment(int commentId) {
        String sql = "DELETE FROM forum_comments WHERE comment_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Comment getCommentById(int commentId) {
        String sql = "SELECT * FROM forum_comments WHERE comment_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractComment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Comment> getCommentsByPostId(int postId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT * FROM forum_comments WHERE post_id=? AND parent_id IS NULL AND status='ACTIVE' ORDER BY created_at ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                comments.add(extractComment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    @Override
    public List<Comment> getCommentsWithDetailsByPostId(int postId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT fc.*, u.username, u.email, u.phone, u.type " +
                    "FROM forum_comments fc " +
                    "INNER JOIN users u ON fc.user_id = u.user_id " +
                    "WHERE fc.post_id=? AND fc.parent_id IS NULL AND fc.status='ACTIVE' " +
                    "ORDER BY fc.created_at ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                comments.add(extractCommentWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    @Override
    public List<Comment> getCommentsByUserId(int userId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT * FROM forum_comments WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                comments.add(extractComment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    @Override
    public List<Comment> getRepliesByParentId(int parentId) {
        List<Comment> replies = new ArrayList<>();
        String sql = "SELECT * FROM forum_comments WHERE parent_id=? AND status='ACTIVE' ORDER BY created_at ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, parentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                replies.add(extractComment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }

    @Override
    public List<Comment> getRepliesWithDetailsByParentId(int parentId) {
        List<Comment> replies = new ArrayList<>();
        String sql = "SELECT fc.*, u.username, u.email, u.phone, u.type " +
                    "FROM forum_comments fc " +
                    "INNER JOIN users u ON fc.user_id = u.user_id " +
                    "WHERE fc.parent_id=? AND fc.status='ACTIVE' " +
                    "ORDER BY fc.created_at ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, parentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                replies.add(extractCommentWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }

    @Override
    public void incrementLikeCount(int commentId) {
        String sql = "UPDATE forum_comments SET like_count=like_count+1 WHERE comment_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int getCommentCount() {
        String sql = "SELECT COUNT(*) FROM forum_comments WHERE status='ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getCommentCountByPostId(int postId) {
        String sql = "SELECT COUNT(*) FROM forum_comments WHERE post_id=? AND status='ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getReplyCountByParentId(int parentId) {
        String sql = "SELECT COUNT(*) FROM forum_comments WHERE parent_id=? AND status='ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, parentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Comment getCommentWithDetails(int commentId) {
        String sql = "SELECT fc.*, u.username, u.email, u.phone, u.type " +
                    "FROM forum_comments fc " +
                    "INNER JOIN users u ON fc.user_id = u.user_id " +
                    "WHERE fc.comment_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractCommentWithDetails(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Comment extractComment(ResultSet rs) throws SQLException {
        Comment comment = new Comment();
        comment.setCommentId(rs.getInt("comment_id"));
        comment.setPostId(rs.getInt("post_id"));
        comment.setUserId(rs.getInt("user_id"));
        
        // 安全地处理parent_id字段
        int parentId = rs.getInt("parent_id");
        if (!rs.wasNull()) {
            comment.setParentId(parentId);
        }
        
        comment.setContent(rs.getString("content"));
        comment.setStatus(rs.getString("status"));
        comment.setLikeCount(rs.getInt("like_count"));
        
        // 安全地处理时间字段
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            comment.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            comment.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return comment;
    }

    private Comment extractCommentWithDetails(ResultSet rs) throws SQLException {
        Comment comment = extractComment(rs);
        
        // 创建并设置User对象
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setType(rs.getString("type"));
        comment.setUser(user);
        
        return comment;
    }
} 