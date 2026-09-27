package com.house.rental.servlet.tenant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.bean.Tenant;
import com.house.rental.service.TenantService;
import com.house.rental.service.impl.TenantServiceImpl;

@WebServlet("/tenant/profile")
public class ProfileServlet extends HttpServlet {
    private TenantService tenantService;

    public ProfileServlet() {
        this.tenantService = new TenantServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是租客
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (!"TENANT".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_user_type");
            return;
        }

        try {
            // 获取租客详细信息
            Tenant tenant = tenantService.getTenantByUserId(user.getUserId());
            if (tenant == null) {
                request.setAttribute("error", "租客信息不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 设置属性
            request.setAttribute("tenant", tenant);

            // 转发到JSP页面
            request.getRequestDispatcher("/tenant/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取个人信息失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST请求重定向到GET
        doGet(request, response);
    }
} 