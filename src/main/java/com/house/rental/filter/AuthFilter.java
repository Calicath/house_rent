package com.house.rental.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.house.rental.bean.User;

// 暂时禁用过滤器，让Servlet自己处理权限验证
// @WebFilter(urlPatterns = {"/owner/*", "/tenant/*", "/admin/*"})
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化逻辑，如果需要的话
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
            throws IOException, ServletException {
        // 暂时直接放行所有请求，让Servlet自己处理权限验证
        filterChain.doFilter(request, response);
        
        /*
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // 不创建新会话

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // 允许公共资源访问
        if (requestURI.equals(contextPath + "/login") || 
            requestURI.equals(contextPath + "/register") ||
            requestURI.equals(contextPath + "/test-login") ||
            requestURI.equals(contextPath + "/debug-session") ||
            requestURI.startsWith(contextPath + "/css/") || 
            requestURI.startsWith(contextPath + "/js/") ||
            requestURI.startsWith(contextPath + "/images/") ||
            requestURI.startsWith(contextPath + "/uploads/") ||
            requestURI.startsWith(contextPath + "/favicon.ico")) {
            filterChain.doFilter(request, response);
            return;
        }

        // 只做基本的登录检查，让Servlet处理具体的权限验证
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 检查用户类型是否有效
        String userType = user.getType();
        if (userType == null || (!userType.equals("ADMIN") && !userType.equals("OWNER") && !userType.equals("TENANT"))) {
            // 用户类型无效，清除session并重定向到登录页面
            session.invalidate();
            httpResponse.sendRedirect(contextPath + "/login?error=invalid_user_type");
            return;
        }

        // 让Servlet处理具体的权限验证
        filterChain.doFilter(request, response);
        */
    }

    @Override
    public void destroy() {
        // 销毁逻辑，如果需要的话
    }
} 