package com.house.rental.servlet.admin;

import com.house.rental.bean.User;
import com.house.rental.service.TenantService;
import com.house.rental.service.impl.TenantServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/delete-tenant")
public class DeleteTenantServlet extends HttpServlet {
    private final TenantService tenantService;

    public DeleteTenantServlet() {
        this.tenantService = new TenantServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否已登录且是管理员
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取租户ID
            int tenantId = Integer.parseInt(request.getParameter("id"));
            
            // 删除租户
            boolean success = tenantService.deleteTenant(tenantId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/tenants");
            } else {
                request.setAttribute("error", "删除租户失败：租户不存在");
                request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除租户失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
        }
    }
} 