package com.house.rental.servlet.forum;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.house.rental.bean.ForumPost;
import com.house.rental.bean.User;
import com.house.rental.service.ForumPostService;
import com.house.rental.service.impl.ForumPostServiceImpl;

@WebServlet("/forum/update-post")
public class UpdatePostServlet extends HttpServlet {
    private final ForumPostService forumPostService;

    public UpdatePostServlet() {
        this.forumPostService = new ForumPostServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int postId = Integer.parseInt(request.getParameter("postId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");

            // 验证数据
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("标题不能为空");
            }
            if (content == null || content.trim().isEmpty()) {
                throw new IllegalArgumentException("内容不能为空");
            }
            if (category == null || category.trim().isEmpty()) {
                throw new IllegalArgumentException("请选择分类");
            }

            // 获取原帖子信息
            ForumPost post = forumPostService.getForumPostById(postId);
            if (post == null) {
                throw new IllegalArgumentException("帖子不存在");
            }

            // 验证权限
            if (post.getUserId() != user.getUserId()) {
                throw new IllegalArgumentException("您没有权限修改此帖子");
            }

            // 更新帖子信息
            post.setTitle(title.trim());
            post.setContent(content.trim());
            post.setCategory(category.trim());

            // 保存更新
            forumPostService.updateForumPost(post);

            // 重定向到帖子详情页
            response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新帖子失败：" + e.getMessage());
            request.getRequestDispatcher("/forum/edit-post.jsp").forward(request, response);
        }
    }
} 