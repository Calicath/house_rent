package com.house.rental.servlet.admin;

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

@WebServlet("/admin/update-owner")
public class UpdateOwnerServlet extends HttpServlet {
    private final OwnerService ownerService;

    public UpdateOwnerServlet() {
        this.ownerService = new OwnerServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户权限
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 获取房主信息
        int ownerId = Integer.parseInt(request.getParameter("ownerId"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        // 创建房主对象
        Owner owner = new Owner(name, address, phone);
        owner.setOwnerId(ownerId);

        try {
            // 更新房主信息
            ownerService.updateOwner(owner);
            // 重定向到房主列表页面
            response.sendRedirect(request.getContextPath() + "/admin/owners");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新房主信息失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/edit-owner.jsp?id=" + ownerId).forward(request, response);
        }
    }
} 