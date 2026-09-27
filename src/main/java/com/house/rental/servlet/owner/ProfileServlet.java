package com.house.rental.servlet.owner;

import java.io.IOException;

import com.house.rental.bean.Owner;
import com.house.rental.bean.User;
import com.house.rental.service.OwnerService;
import com.house.rental.service.impl.OwnerServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/owner/profile")
public class ProfileServlet extends HttpServlet {
    private OwnerService ownerService;

    public ProfileServlet() {
        this.ownerService = new OwnerServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是房东
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_user_type");
            return;
        }

        try {
            // 获取房东详细信息
            Owner owner = ownerService.getOwnerById(user.getUserId());
            if (owner == null) {
                request.setAttribute("error", "房东信息不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("owner", owner);
            request.getRequestDispatcher("/owner/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取个人信息失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 