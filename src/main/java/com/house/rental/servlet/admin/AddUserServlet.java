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

@WebServlet("/admin/user/add")
public class AddUserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
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
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String type = request.getParameter("type");

            // 创建新用户
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password); // 注意：实际应用中应该对密码进行加密
            newUser.setType(type);
            newUser.setStatus("ACTIVE");

            // 添加用户
            userService.registerUser(newUser);

            // 重定向到用户列表页面
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加用户失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 