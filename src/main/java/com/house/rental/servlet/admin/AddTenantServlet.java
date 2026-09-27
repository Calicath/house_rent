package com.house.rental.servlet.admin;

import java.io.IOException;

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

@WebServlet("/admin/add-tenant")
public class AddTenantServlet extends HttpServlet {
    private final TenantService tenantService;
    private UserService userService;

    public AddTenantServlet() {
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

        // 转发到添加租户页面
        request.getRequestDispatcher("/admin/add-tenant.jsp").forward(request, response);
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
            String username = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String idCard = request.getParameter("idCard");
            String gender = request.getParameter("gender");
            String password = "defaultPassword";
            String email = "default@example.com";
            String userStatus = "ACTIVE";

            // 创建用户对象
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(password);
            newUser.setEmail(email);
            newUser.setType("TENANT");
            newUser.setStatus(userStatus);
            newUser.setReferenceId(0);

            userService.registerUser(newUser);
            
            // 创建租户对象
            Tenant tenant = new Tenant();
            tenant.setUserId(newUser.getUserId());
            tenant.setIdCard(idCard);
            tenant.setGender(gender);
            tenant.setStatus("ACTIVE");

            // 添加租户
            tenantService.addTenant(tenant);
            
            response.sendRedirect(request.getContextPath() + "/admin/tenants");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加租户失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/add-tenant.jsp").forward(request, response);
        }
    }
} 