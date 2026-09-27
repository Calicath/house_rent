package com.house.rental.servlet.forum;

import com.house.rental.bean.Comment;
import com.house.rental.bean.ForumPost;
import com.house.rental.bean.User;
import com.house.rental.service.CommentService;
import com.house.rental.service.ForumPostService;
import com.house.rental.service.impl.CommentServiceImpl;
import com.house.rental.service.impl.ForumPostServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/forum/post/*")
public class PostDetailServlet extends HttpServlet {
    private ForumPostService forumPostService = new ForumPostServiceImpl();
    private CommentService commentService = new CommentServiceImpl();

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

        try {
            // 从URL路径中获取帖子ID
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            int postId;
            try {
                postId = Integer.parseInt(pathInfo.substring(1));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            // 获取帖子详情
            ForumPost post = forumPostService.getForumPostWithDetails(postId);
            if (post == null) {
                request.setAttribute("error", "帖子不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 增加浏览次数
            forumPostService.incrementViewCount(postId);

            // 获取评论列表
            List<Comment> comments = commentService.getCommentsWithDetailsByPostId(postId);

            // 设置请求属性
            request.setAttribute("post", post);
            request.setAttribute("comments", comments);

            // 添加调试信息
            System.out.println("=== PostDetailServlet 调试信息 ===");
            System.out.println("用户ID: " + user.getUserId());
            System.out.println("用户名: " + user.getUsername());
            System.out.println("帖子ID: " + postId);
            System.out.println("帖子标题: " + post.getTitle());
            System.out.println("评论数量: " + (comments != null ? comments.size() : "null"));
            System.out.println("=== 调试信息结束 ===");

            request.getRequestDispatcher("/forum/post-detail.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("PostDetailServlet 发生异常:");
            e.printStackTrace();
            request.setAttribute("error", "获取帖子详情失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 