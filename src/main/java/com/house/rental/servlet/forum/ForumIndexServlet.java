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
import java.util.List;

@WebServlet("/forum")
public class ForumIndexServlet extends HttpServlet {
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

        try {
            // 获取分页参数
            String pageStr = request.getParameter("page");
            String category = request.getParameter("category");
            String keyword = request.getParameter("keyword");
            
            int page = 1;
            int pageSize = 10;
            
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            List<ForumPost> posts = null;
            int totalCount = 0;
            int totalPages = 0;

            // 获取置顶帖子
            List<ForumPost> pinnedPosts = forumPostService.getPinnedForumPosts();
            request.setAttribute("pinnedPosts", pinnedPosts);

            // 根据条件获取帖子
            if (keyword != null && !keyword.trim().isEmpty()) {
                // 搜索帖子
                posts = forumPostService.searchForumPosts(keyword, page, pageSize);
                totalCount = forumPostService.getSearchForumPostCount(keyword);
                request.setAttribute("keyword", keyword);
                request.setAttribute("searchMode", true);
            } else if (category != null && !category.trim().isEmpty()) {
                // 按分类获取帖子
                posts = forumPostService.getForumPostsByCategory(category, page, pageSize);
                totalCount = forumPostService.getForumPostCountByCategory(category);
                request.setAttribute("category", category);
                request.setAttribute("categoryMode", true);
            } else {
                // 获取所有帖子（包含用户信息）
                posts = forumPostService.getAllForumPostsWithDetails(page, pageSize);
                totalCount = forumPostService.getForumPostCount();
            }

            totalPages = forumPostService.getTotalPages(totalCount, pageSize);

            // 设置请求属性
            request.setAttribute("posts", posts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pageSize", pageSize);

            // 添加调试信息
            System.out.println("=== ForumIndexServlet 调试信息 ===");
            System.out.println("用户ID: " + user.getUserId());
            System.out.println("用户名: " + user.getUsername());
            System.out.println("用户类型: " + user.getType());
            System.out.println("当前页: " + page);
            System.out.println("分类: " + category);
            System.out.println("关键词: " + keyword);
            System.out.println("帖子数量: " + (posts != null ? posts.size() : "null"));
            System.out.println("总数量: " + totalCount);
            System.out.println("总页数: " + totalPages);
            System.out.println("置顶帖子数量: " + (pinnedPosts != null ? pinnedPosts.size() : "null"));
            System.out.println("=== 调试信息结束 ===");

            request.getRequestDispatcher("/forum/index.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("ForumIndexServlet 发生异常:");
            e.printStackTrace();
            request.setAttribute("error", "获取论坛帖子失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 