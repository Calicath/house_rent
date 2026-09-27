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
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/user/delete")
public class DeleteUserServlet extends HttpServlet {
    private UserService userService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        gson = new Gson();
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            // 获取用户ID
            int userId = Integer.parseInt(request.getParameter("userId"));

            // 检查是否是当前登录的管理员
            if (userId == admin.getUserId()) {
                throw new Exception("不能删除当前登录的管理员账户");
            }

            // 删除用户
            userService.deleteUser(userId);

            // 返回成功结果
            result.put("success", true);
            result.put("message", "用户删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "删除用户失败：" + e.getMessage());
        }

        // 返回JSON响应
        response.getWriter().write(gson.toJson(result));
    }
} 