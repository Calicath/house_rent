package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.ForumPost;

public interface ForumPostService {
    // 添加帖子
    boolean addForumPost(ForumPost post);
    
    // 更新帖子
    boolean updateForumPost(ForumPost post);
    
    // 删除帖子
    boolean deleteForumPost(int postId);
    
    // 根据ID获取帖子
    ForumPost getForumPostById(int postId);
    
    // 获取帖子详情（包含用户信息）
    ForumPost getForumPostWithDetails(int postId);
    
    // 获取所有帖子（分页）
    List<ForumPost> getAllForumPosts(int page, int pageSize);
    
    // 获取所有帖子（分页，包含用户信息）
    List<ForumPost> getAllForumPostsWithDetails(int page, int pageSize);
    
    // 根据分类获取帖子
    List<ForumPost> getForumPostsByCategory(String category, int page, int pageSize);
    
    // 根据用户ID获取帖子
    List<ForumPost> getForumPostsByUserId(int userId);
    
    // 搜索帖子
    List<ForumPost> searchForumPosts(String keyword, int page, int pageSize);
    
    // 获取置顶帖子
    List<ForumPost> getPinnedForumPosts();
    
    // 增加浏览次数
    boolean incrementViewCount(int postId);
    
    // 增加点赞次数
    boolean incrementLikeCount(int postId);
    
    // 获取帖子总数
    int getForumPostCount();
    
    // 根据分类获取帖子总数
    int getForumPostCountByCategory(String category);
    
    // 搜索帖子总数
    int getSearchForumPostCount(String keyword);
    
    // 获取总页数
    int getTotalPages(int totalCount, int pageSize);
} 