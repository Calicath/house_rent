package com.house.rental.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.house.rental.bean.User;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.UserServiceImpl;

@WebServlet("/admin/user/edit")
public class EditUserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (admin == null || !"ADMIN".equals(admin.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取用户ID
            int userId = Integer.parseInt(request.getParameter("userId"));

            // 获取用户信息
            User user = userService.getUserById(userId);
            if (user == null) {
                throw new Exception("用户不存在");
            }

            // 返回用户信息（JSON格式）
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.format(
                "{\"userId\":%d,\"username\":\"%s\",\"email\":\"%s\",\"type\":\"%s\",\"status\":\"%s\"}",
                user.getUserId(), user.getUsername(), user.getEmail(), user.getType(), user.getStatus()
            ));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (admin == null || !"ADMIN".equals(admin.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String type = request.getParameter("type");
            String status = request.getParameter("status");

            // 获取现有用户
            User user = userService.getUserById(userId);
            if (user == null) {
                throw new Exception("用户不存在");
            }

            // 更新用户信息
            user.setUsername(username);
            user.setEmail(email);
            user.setType(type);
            user.setStatus(status);

            // 保存更新
            userService.updateUser(user);

            // 重定向到用户列表页面
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新用户失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 