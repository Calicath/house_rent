package com.house.rental.servlet.admin;

import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.service.OwnerService;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.OwnerServiceImpl;
import com.house.rental.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/delete-owner")
public class DeleteOwnerServlet extends HttpServlet {
    private OwnerService ownerService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        ownerService = new OwnerServiceImpl();
        userService = new UserServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (currentUser == null || !"ADMIN".equals(currentUser.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            
            // 获取要删除的房主对应的用户ID
            User ownerUser = userService.getUserByReferenceId(ownerId, "OWNER");
            if (ownerUser != null) {
                // 删除用户（如果需要，先删除与用户相关的其他数据，例如房屋）
                // 这里假设删除房主会级联删除其房屋，或者需要单独处理房屋的归属
                // 暂时只删除用户和房主记录
                ownerService.deleteOwner(ownerId);
                userService.deleteUser(ownerUser.getUserId());
            } else {
                // 如果没有找到对应的用户，仍然尝试删除房主记录
                ownerService.deleteOwner(ownerId);
            }

            response.sendRedirect(request.getContextPath() + "/admin/owners");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除房主失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/owners.jsp").forward(request, response);
        }
    }
} 