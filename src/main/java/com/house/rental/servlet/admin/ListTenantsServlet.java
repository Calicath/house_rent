package com.house.rental.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.house.rental.bean.Tenant;
import com.house.rental.bean.User;
import com.house.rental.service.TenantService;
import com.house.rental.service.impl.TenantServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/tenants")
public class ListTenantsServlet extends HttpServlet {
    private final TenantService tenantService;

    public ListTenantsServlet() {
        this.tenantService = new TenantServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否已登录且是管理员
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取所有租户列表
            List<Tenant> tenants = tenantService.getAllTenants();
            request.setAttribute("tenants", tenants);
            
            // 转发到租户列表页面
            request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取租户列表失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
        }
    }
} 