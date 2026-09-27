package com.house.rental.servlet.forum;

import java.io.IOException;

import com.house.rental.bean.ForumPost;
import com.house.rental.bean.User;
import com.house.rental.service.ForumPostService;
import com.house.rental.service.impl.ForumPostServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forum/delete-post")
public class DeletePostServlet extends HttpServlet {
    private ForumPostService forumPostService = new ForumPostServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取帖子ID
            int postId = Integer.parseInt(request.getParameter("postId"));
            
            // 获取帖子信息
            ForumPost post = forumPostService.getForumPostById(postId);
            if (post == null) {
                throw new IllegalArgumentException("帖子不存在");
            }

            // 验证权限
            if (post.getUserId() != user.getUserId()) {
                throw new IllegalArgumentException("您没有权限删除此帖子");
            }

            // 删除帖子
            forumPostService.deleteForumPost(postId);

            // 重定向到论坛首页
            response.sendRedirect(request.getContextPath() + "/forum?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除帖子失败：" + e.getMessage());
            request.getRequestDispatcher("/forum/post?id=" + request.getParameter("postId")).forward(request, response);
        }
    }
} 