package com.house.rental.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.house.rental.bean.Owner;
import com.house.rental.bean.User;
import com.house.rental.service.OwnerService;
import com.house.rental.service.impl.OwnerServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/owners")
public class ListOwnersServlet extends HttpServlet {
    private final OwnerService ownerService;

    public ListOwnersServlet() {
        this.ownerService = new OwnerServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户权限
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取所有房主信息
            List<Owner> owners = ownerService.getAllOwners();
            // 设置属性
            request.setAttribute("owners", owners);
            // 转发到房主列表页面
            request.getRequestDispatcher("/admin/owners.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取房主列表失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
} 