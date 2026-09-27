package com.house.rental.servlet;

import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService;

    public LoginServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 如果用户已登录，重定向到相应的首页
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            // 检查用户类型是否有效
            String userType = user.getType();
            if (userType != null && (userType.equals("ADMIN") || userType.equals("OWNER") || userType.equals("TENANT"))) {
                redirectToHomePage(user, request, response);
                return;
            } else {
                // 用户类型无效，清除session
                session.invalidate();
            }
        }

        // 否则显示登录页面
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // 验证用户
            User user = userService.login(username, password);
            if (user != null) {
                // 登录成功，设置session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // 重定向到相应的首页
                redirectToHomePage(user, request, response);
            } else {
                // 登录失败
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "登录失败：" + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void redirectToHomePage(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        switch (user.getType().toUpperCase()) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
            case "OWNER":
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                break;
            case "TENANT":
                response.sendRedirect(request.getContextPath() + "/tenant/dashboard");
                break;
            default:
                // 用户类型无效，重定向到登录页面并清除session
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/login?error=invalid_user_type");
        }
    }
} 