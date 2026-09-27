package com.house.rental.servlet;

import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.bean.Owner;
import com.house.rental.bean.Tenant;
import com.house.rental.service.UserService;
import com.house.rental.service.OwnerService;
import com.house.rental.service.TenantService;
import com.house.rental.service.impl.UserServiceImpl;
import com.house.rental.service.impl.OwnerServiceImpl;
import com.house.rental.service.impl.TenantServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService;
    private OwnerService ownerService;
    private TenantService tenantService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        ownerService = new OwnerServiceImpl();
        tenantService = new TenantServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 获取表单数据
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String idCard = request.getParameter("idCard");
        String userType = request.getParameter("userType");

        // 验证必填字段
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            idCard == null || idCard.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty()) {
            request.setAttribute("error", "必填字段不能为空");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证密码是否匹配
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不匹配");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证用户类型
        if (!userType.equals("OWNER") && !userType.equals("TENANT")) {
            request.setAttribute("error", "无效的用户类型");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // 创建用户对象
            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // 注意：实际应用中应该对密码进行加密
            user.setEmail(email != null ? email : "");
            user.setPhone(phone);
            user.setIdCard(idCard);
            user.setType(userType);
            user.setStatus("ACTIVE");
            user.setReferenceId(0); // 将在创建owner/tenant后更新

            // 如果是租客，验证租客特有字段
            if (userType.equals("TENANT")) {
                String gender = request.getParameter("gender");
                if (gender == null || gender.trim().isEmpty()) {
                    request.setAttribute("error", "请选择性别");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }
                user.setGender(gender);
            }

            // 注册用户
            userService.registerUser(user);

            // 根据用户类型创建相应的记录
            if (userType.equals("OWNER")) {
                // 创建房主记录
                Owner owner = new Owner();
                owner.setUserId(user.getUserId());
                owner.setName(username); // 使用用户名作为姓名
                owner.setAddress(""); // 可以在后续更新
                owner.setPhone(phone);
                ownerService.addOwner(owner);
                
                // 更新用户的 referenceId
                user.setReferenceId(owner.getOwnerId());
                userService.updateUser(user);
            } else if (userType.equals("TENANT")) {
                // 创建租户记录
                Tenant tenant = new Tenant();
                tenant.setUserId(user.getUserId());
                tenant.setIdCard(idCard);
                tenant.setGender(user.getGender());
                tenant.setStatus("ACTIVE");
                
                // 设置租客特有字段
                String emergencyContact = request.getParameter("emergencyContact");
                String emergencyPhone = request.getParameter("emergencyPhone");
                String occupation = request.getParameter("occupation");
                String employer = request.getParameter("employer");
                String income = request.getParameter("income");
                
                if (emergencyContact != null) tenant.setEmergencyContact(emergencyContact);
                if (emergencyPhone != null) tenant.setEmergencyPhone(emergencyPhone);
                if (occupation != null) tenant.setOccupation(occupation);
                if (employer != null) tenant.setEmployer(employer);
                if (income != null) tenant.setIncome(income);
                
                tenantService.addTenant(tenant);
                
                // 更新用户的 referenceId
                user.setReferenceId(tenant.getTenantId());
                userService.updateUser(user);
            }

            // 注册成功，自动登录用户
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // 根据用户类型重定向到相应的仪表盘
            if (userType.equals("OWNER")) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard?registered=true");
            } else if (userType.equals("TENANT")) {
                response.sendRedirect(request.getContextPath() + "/tenant/dashboard?registered=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?registered=true");
            }
        } catch (Exception e) {
            System.err.println("注册失败: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "注册失败：" + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
} 