package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.ForumPost;

public interface ForumPostDAO {
    // 添加帖子
    void addForumPost(ForumPost post);
    
    // 更新帖子
    void updateForumPost(ForumPost post);
    
    // 删除帖子
    void deleteForumPost(int postId);
    
    // 根据ID获取帖子
    ForumPost getForumPostById(int postId);
    
    // 获取所有帖子（分页）
    List<ForumPost> getAllForumPosts(int offset, int limit);
    
    // 根据分类获取帖子
    List<ForumPost> getForumPostsByCategory(String category, int offset, int limit);
    
    // 根据用户ID获取帖子
    List<ForumPost> getForumPostsByUserId(int userId);
    
    // 搜索帖子
    List<ForumPost> searchForumPosts(String keyword, int offset, int limit);
    
    // 获取置顶帖子
    List<ForumPost> getPinnedForumPosts();
    
    // 增加浏览次数
    void incrementViewCount(int postId);
    
    // 增加点赞次数
    void incrementLikeCount(int postId);
    
    // 增加回复次数
    void incrementReplyCount(int postId);
    
    // 减少回复次数
    void decrementReplyCount(int postId);
    
    // 获取帖子总数
    int getForumPostCount();
    
    // 根据分类获取帖子总数
    int getForumPostCountByCategory(String category);
    
    // 搜索帖子总数
    int getSearchForumPostCount(String keyword);
    
    // 获取帖子详情（包含用户信息和评论数）
    ForumPost getForumPostWithDetails(int postId);
    
    // 获取帖子列表（包含用户信息）
    List<ForumPost> getForumPostsWithDetails(int offset, int limit);
} 