package com.house.rental.servlet.forum;

import java.io.IOException;

import com.house.rental.bean.Comment;
import com.house.rental.bean.User;
import com.house.rental.service.CommentService;
import com.house.rental.service.impl.CommentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forum/delete-comment")
public class DeleteCommentServlet extends HttpServlet {
    private final CommentService commentService;

    public DeleteCommentServlet() {
        this.commentService = new CommentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 获取评论ID
        int commentId = Integer.parseInt(request.getParameter("id"));
        
        try {
            // 获取评论信息
            Comment comment = commentService.getCommentById(commentId);
            if (comment == null) {
                throw new RuntimeException("评论不存在");
            }

            // 验证用户是否有权限删除评论
            if (comment.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/forum/post?id=" + comment.getPostId());
                return;
            }

            // 删除评论
            commentService.deleteComment(commentId);
            
            // 重定向回帖子详情页
            response.sendRedirect(request.getContextPath() + "/forum/view-post?id=" + comment.getPostId());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除评论失败：" + e.getMessage());
            request.getRequestDispatcher("/forum/view-post?id=" + 
                    (commentService.getCommentById(commentId) != null ? 
                    commentService.getCommentById(commentId).getPostId() : "")).forward(request, response);
        }
    }
} 