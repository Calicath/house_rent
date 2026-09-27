package com.house.rental.bean;

import java.time.LocalDateTime;
import java.util.List;

public class Comment {
    private int commentId;
    private int postId;
    private int userId;
    private Integer parentId;
    private String content;
    private String status;
    private int likeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 关联字段
    private User user;
    private ForumPost post;
    private List<Comment> replies;

    public Comment() {
    }

    public Comment(int postId, int userId, String content) {
        this.postId = postId;
        this.userId = userId;
        this.content = content;
        this.status = "ACTIVE";
        this.likeCount = 0;
    }

    public Comment(int postId, int userId, Integer parentId, String content) {
        this.postId = postId;
        this.userId = userId;
        this.parentId = parentId;
        this.content = content;
        this.status = "ACTIVE";
        this.likeCount = 0;
    }

    // Getters and Setters
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ForumPost getPost() {
        return post;
    }

    public void setPost(ForumPost post) {
        this.post = post;
    }

    public List<Comment> getReplies() {
        return replies;
    }

    public void setReplies(List<Comment> replies) {
        this.replies = replies;
    }

    // 判断是否为回复
    public boolean isReply() {
        return parentId != null;
    }

    // 获取状态显示名称
    public String getStatusDisplayName() {
        switch (status) {
            case "ACTIVE":
                return "正常";
            case "HIDDEN":
                return "隐藏";
            case "DELETED":
                return "已删除";
            default:
                return "未知";
        }
    }
} 