package com.house.rental.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 设置字符编码
        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");
        httpResponse.setContentType("text/html;charset=UTF-8");
        
        // 继续处理请求
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 销毁
    }
} 