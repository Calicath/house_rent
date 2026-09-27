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

import com.house.rental.bean.ForumPost;
import com.house.rental.bean.User;
import com.house.rental.dao.ForumPostDAO;
import com.house.rental.util.DBUtil;

public class ForumPostDAOImpl implements ForumPostDAO {
    
    @Override
    public void addForumPost(ForumPost post) {
        String sql = "INSERT INTO forum_posts (user_id, title, content, category, status, view_count, like_count, reply_count, is_pinned, is_highlighted, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, post.getUserId());
            pstmt.setString(2, post.getTitle());
            pstmt.setString(3, post.getContent());
            pstmt.setString(4, post.getCategory());
            pstmt.setString(5, post.getStatus());
            pstmt.setInt(6, post.getViewCount());
            pstmt.setInt(7, post.getLikeCount());
            pstmt.setInt(8, post.getReplyCount());
            pstmt.setBoolean(9, post.isPinned());
            pstmt.setBoolean(10, post.isHighlighted());
            pstmt.setTimestamp(11, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setTimestamp(12, Timestamp.valueOf(LocalDateTime.now()));
            
            pstmt.executeUpdate();
            
            // 获取生成的ID
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                post.setPostId(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateForumPost(ForumPost post) {
        String sql = "UPDATE forum_posts SET title=?, content=?, category=?, status=?, is_pinned=?, is_highlighted=?, updated_at=? WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, post.getTitle());
            pstmt.setString(2, post.getContent());
            pstmt.setString(3, post.getCategory());
            pstmt.setString(4, post.getStatus());
            pstmt.setBoolean(5, post.isPinned());
            pstmt.setBoolean(6, post.isHighlighted());
            pstmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(8, post.getPostId());
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteForumPost(int postId) {
        String sql = "DELETE FROM forum_posts WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ForumPost getForumPostById(int postId) {
        String sql = "SELECT * FROM forum_posts WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractForumPost(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ForumPost> getAllForumPosts(int offset, int limit) {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT * FROM forum_posts WHERE status='ACTIVE' ORDER BY is_pinned DESC, created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPost(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    @Override
    public List<ForumPost> getForumPostsByCategory(String category, int offset, int limit) {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT * FROM forum_posts WHERE category=? AND status='ACTIVE' ORDER BY is_pinned DESC, created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, category);
            pstmt.setInt(2, limit);
            pstmt.setInt(3, offset);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPost(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    @Override
    public List<ForumPost> getForumPostsByUserId(int userId) {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT * FROM forum_posts WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPost(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    @Override
    public List<ForumPost> searchForumPosts(String keyword, int offset, int limit) {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT * FROM forum_posts WHERE (title LIKE ? OR content LIKE ?) AND status='ACTIVE' ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, limit);
            pstmt.setInt(4, offset);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPost(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    @Override
    public List<ForumPost> getPinnedForumPosts() {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT * FROM forum_posts WHERE is_pinned=TRUE AND status='ACTIVE' ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPost(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    @Override
    public void incrementViewCount(int postId) {
        String sql = "UPDATE forum_posts SET view_count=view_count+1 WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void incrementLikeCount(int postId) {
        String sql = "UPDATE forum_posts SET like_count=like_count+1 WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void incrementReplyCount(int postId) {
        String sql = "UPDATE forum_posts SET reply_count=reply_count+1 WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void decrementReplyCount(int postId) {
        String sql = "UPDATE forum_posts SET reply_count=GREATEST(reply_count-1, 0) WHERE post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int getForumPostCount() {
        String sql = "SELECT COUNT(*) FROM forum_posts WHERE status='ACTIVE'";
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
    public int getForumPostCountByCategory(String category) {
        String sql = "SELECT COUNT(*) FROM forum_posts WHERE category=? AND status='ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, category);
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
    public int getSearchForumPostCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM forum_posts WHERE (title LIKE ? OR content LIKE ?) AND status='ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
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
    public ForumPost getForumPostWithDetails(int postId) {
        String sql = "SELECT fp.*, u.username, u.email, u.phone, u.type " +
                    "FROM forum_posts fp " +
                    "INNER JOIN users u ON fp.user_id = u.user_id " +
                    "WHERE fp.post_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractForumPostWithDetails(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ForumPost> getForumPostsWithDetails(int offset, int limit) {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT fp.*, u.username, u.email, u.phone, u.type " +
                    "FROM forum_posts fp " +
                    "INNER JOIN users u ON fp.user_id = u.user_id " +
                    "WHERE fp.status='ACTIVE' " +
                    "ORDER BY fp.is_pinned DESC, fp.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                posts.add(extractForumPostWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    private ForumPost extractForumPost(ResultSet rs) throws SQLException {
        ForumPost post = new ForumPost();
        post.setPostId(rs.getInt("post_id"));
        post.setUserId(rs.getInt("user_id"));
        post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setCategory(rs.getString("category"));
        post.setStatus(rs.getString("status"));
        post.setViewCount(rs.getInt("view_count"));
        post.setLikeCount(rs.getInt("like_count"));
        post.setReplyCount(rs.getInt("reply_count"));
        post.setPinned(rs.getBoolean("is_pinned"));
        post.setHighlighted(rs.getBoolean("is_highlighted"));
        
        // 安全地处理时间字段
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            post.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            post.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return post;
    }

    private ForumPost extractForumPostWithDetails(ResultSet rs) throws SQLException {
        ForumPost post = extractForumPost(rs);
        
        // 创建并设置User对象
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setType(rs.getString("type"));
        post.setUser(user);
        
        return post;
    }
} 