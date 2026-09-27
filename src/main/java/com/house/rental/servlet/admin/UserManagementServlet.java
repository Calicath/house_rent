package com.house.rental.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.house.rental.bean.User;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.UserServiceImpl;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private UserService userService;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"ADMIN".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取查询参数
            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");
            String status = request.getParameter("status");
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // 使用默认值1
            }

            // 获取用户列表
            List<User> users = userService.searchUsers(keyword, type, status, page, PAGE_SIZE);
            int totalUsers = userService.getTotalUsers(keyword, type, status);
            int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);

            // 设置属性
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsers", totalUsers);

            // 转发到JSP页面
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取用户列表失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 