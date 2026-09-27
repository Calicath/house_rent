package com.house.rental.servlet.admin;

import com.house.rental.bean.Tenant;
import com.house.rental.bean.User;
import com.house.rental.service.TenantService;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.TenantServiceImpl;
import com.house.rental.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/edit-tenant")
public class EditTenantServlet extends HttpServlet {
    private final TenantService tenantService;
    private UserService userService;

    public EditTenantServlet() {
        this.tenantService = new TenantServiceImpl();
    }

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserServiceImpl();
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
            // 获取租户ID
            int tenantId = Integer.parseInt(request.getParameter("id"));
            
            // 获取租户信息
            Tenant tenant = tenantService.getTenantById(tenantId);
            if (tenant == null) {
                request.setAttribute("error", "租户不存在");
                request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
                return;
            }

            // 设置租户信息到请求属性
            request.setAttribute("tenant", tenant);
            
            // 转发到编辑租户页面
            request.getRequestDispatcher("/admin/edit-tenant.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取租户信息失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/tenants.jsp").forward(request, response);
        }
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
            // 获取表单数据
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            String username = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String idCard = request.getParameter("idCard");
            String gender = request.getParameter("gender");

            // 获取现有租户信息
            Tenant existingTenant = tenantService.getTenantById(tenantId);
            if (existingTenant == null) {
                request.setAttribute("error", "租户不存在");
                request.getRequestDispatcher("/admin/edit-tenant.jsp").forward(request, response);
                return;
            }

            // 更新关联的用户信息
            User associatedUser = userService.getUserById(existingTenant.getUserId());
            if (associatedUser != null) {
                associatedUser.setUsername(username);
                associatedUser.setAddress(address);
                associatedUser.setPhone(phone);
                userService.updateUser(associatedUser);
            }

            // 更新租户信息
            existingTenant.setIdCard(idCard);
            existingTenant.setGender(gender);
            tenantService.updateTenant(existingTenant);

            response.sendRedirect(request.getContextPath() + "/admin/tenants");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新租户失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/edit-tenant.jsp").forward(request, response);
        }
    }
} 