package com.house.rental.servlet.forum;

import com.house.rental.bean.Comment;
import com.house.rental.bean.User;
import com.house.rental.service.CommentService;
import com.house.rental.service.impl.CommentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forum/add-comment")
public class AddCommentServlet extends HttpServlet {
    private final CommentService commentService;

    public AddCommentServlet() {
        this.commentService = new CommentServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 获取评论信息
        int postId = Integer.parseInt(request.getParameter("postId"));
        String content = request.getParameter("content");

        // 创建评论对象
        Comment comment = new Comment(postId, user.getUserId(), content);

        try {
            // 添加评论
            commentService.addComment(comment);
            // 重定向回帖子详情页
            response.sendRedirect(request.getContextPath() + "/forum/view-post?id=" + postId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加评论失败：" + e.getMessage());
            request.getRequestDispatcher("/forum/view-post?id=" + postId).forward(request, response);
        }
    }
} 