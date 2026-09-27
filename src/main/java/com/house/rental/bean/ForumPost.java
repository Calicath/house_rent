package com.house.rental.bean;

import java.time.LocalDateTime;
import java.util.List;

public class ForumPost {
    private int postId;
    private int userId;
    private String title;
    private String content;
    private String category; // 帖子分类：问题、建议、经验分享等
    private String status;
    private int viewCount;
    private int likeCount;
    private int replyCount;
    private boolean isPinned;
    private boolean isHighlighted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 关联字段
    private User user;
    private List<Comment> comments;

    public ForumPost() {
    }

    public ForumPost(int userId, String title, String content, String category) {
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.status = "ACTIVE";
        this.viewCount = 0;
        this.likeCount = 0;
        this.replyCount = 0;
        this.isPinned = false;
        this.isHighlighted = false;
    }

    // Getters and Setters
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(int replyCount) {
        this.replyCount = replyCount;
    }

    public boolean isPinned() {
        return isPinned;
    }

    public void setPinned(boolean pinned) {
        isPinned = pinned;
    }

    public boolean isHighlighted() {
        return isHighlighted;
    }

    public void setHighlighted(boolean highlighted) {
        isHighlighted = highlighted;
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

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    // 获取分类显示名称
    public String getCategoryDisplayName() {
        switch (category) {
            case "GENERAL":
                return "综合讨论";
            case "RENTAL_TIPS":
                return "租赁技巧";
            case "COMPLAINT":
                return "投诉建议";
            case "QUESTION":
                return "问题咨询";
            case "EXPERIENCE":
                return "经验分享";
            default:
                return "其他";
        }
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