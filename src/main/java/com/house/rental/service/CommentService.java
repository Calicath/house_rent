package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.Comment;

public interface CommentService {
    // 添加评论
    boolean addComment(Comment comment);
    
    // 更新评论
    boolean updateComment(Comment comment);
    
    // 删除评论
    boolean deleteComment(int commentId);
    
    // 根据ID获取评论
    Comment getCommentById(int commentId);
    
    // 根据帖子ID获取评论
    List<Comment> getCommentsByPostId(int postId);
    
    // 根据帖子ID获取评论（包含用户信息）
    List<Comment> getCommentsWithDetailsByPostId(int postId);
    
    // 根据用户ID获取评论
    List<Comment> getCommentsByUserId(int userId);
    
    // 根据父评论ID获取回复
    List<Comment> getRepliesByParentId(int parentId);
    
    // 根据父评论ID获取回复（包含用户信息）
    List<Comment> getRepliesWithDetailsByParentId(int parentId);
    
    // 增加点赞次数
    boolean incrementLikeCount(int commentId);
    
    // 获取评论总数
    int getCommentCount();
    
    // 根据帖子ID获取评论总数
    int getCommentCountByPostId(int postId);
    
    // 根据父评论ID获取回复总数
    int getReplyCountByParentId(int parentId);
    
    // 获取评论详情（包含用户信息）
    Comment getCommentWithDetails(int commentId);
} 