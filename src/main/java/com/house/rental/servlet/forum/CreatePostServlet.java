package com.house.rental.servlet.forum;

import com.house.rental.bean.ForumPost;
import com.house.rental.bean.User;
import com.house.rental.service.ForumPostService;
import com.house.rental.service.impl.ForumPostServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/forum/create-post")
public class CreatePostServlet extends HttpServlet {
    private ForumPostService forumPostService = new ForumPostServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 显示发帖页面
        request.getRequestDispatcher("/forum/create-post.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单参数
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");

            // 验证参数
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "标题不能为空");
                request.getRequestDispatcher("/forum/create-post.jsp").forward(request, response);
                return;
            }

            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("error", "内容不能为空");
                request.getRequestDispatcher("/forum/create-post.jsp").forward(request, response);
                return;
            }

            if (category == null || category.trim().isEmpty()) {
                category = "GENERAL";
            }

            // 创建帖子对象
            ForumPost post = new ForumPost(user.getUserId(), title.trim(), content.trim(), category);

            // 保存帖子
            boolean success = forumPostService.addForumPost(post);

            if (success) {
                // 发帖成功，重定向到论坛首页
                response.sendRedirect(request.getContextPath() + "/forum?success=1");
            } else {
                request.setAttribute("error", "发帖失败，请重试");
                request.setAttribute("title", title);
                request.setAttribute("content", content);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/forum/create-post.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("CreatePostServlet 发生异常:");
            e.printStackTrace();
            request.setAttribute("error", "发帖失败：" + e.getMessage());
            request.getRequestDispatcher("/forum/create-post.jsp").forward(request, response);
        }
    }
} 