<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userType = (String) session.getAttribute("userType");
    String username = ((com.house.rental.bean.User) session.getAttribute("user")).getUsername();
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">房屋租赁系统</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="register.jsp">注册</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">登录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/forum">
                        <i class="bi bi-chat-dots"></i> 论坛
                    </a>
                </li>
                <%-- 用户已登录时显示退出 --%>
                <% if (session.getAttribute("user") != null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> 退出
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav> 