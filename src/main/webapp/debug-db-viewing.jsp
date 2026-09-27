<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.house.rental.util.DBUtil" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数据库调试 - 看房申请系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .debug-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-database"></i> 数据库调试 - 看房申请系统
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/test-viewing-system.jsp">
                    <i class="bi bi-arrow-left"></i> 返回测试页面
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="debug-card">
            <h2 class="mb-4"><i class="bi bi-database"></i> 数据库关联检查</h2>

            <%
            try (Connection conn = DBUtil.getConnection()) {
                // 1. 检查用户表
                %>
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-people"></i> 用户表检查</h5>
                    </div>
                    <div class="card-body">
                        <%
                        String userSql = "SELECT user_id, username, type, reference_id, status FROM users ORDER BY user_id";
                        try (PreparedStatement pstmt = conn.prepareStatement(userSql);
                             ResultSet rs = pstmt.executeQuery()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>用户ID</th>
                                        <th>用户名</th>
                                        <th>类型</th>
                                        <th>Reference ID</th>
                                        <th>状态</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% while (rs.next()) { %>
                                    <tr>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><%= rs.getString("username") %></td>
                                        <td>
                                            <span class="badge <%= "OWNER".equals(rs.getString("type")) ? "bg-primary" : "TENANT".equals(rs.getString("type")) ? "bg-success" : "bg-secondary" %>">
                                                <%= rs.getString("type") %>
                                            </span>
                                        </td>
                                        <td><%= rs.getInt("reference_id") %></td>
                                        <td>
                                            <span class="badge <%= "ACTIVE".equals(rs.getString("status")) ? "bg-success" : "bg-warning" %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- 2. 检查房主表 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-house"></i> 房主表检查</h5>
                    </div>
                    <div class="card-body">
                        <%
                        String ownerSql = "SELECT o.owner_id, o.user_id, u.username, o.name, o.phone, o.email FROM owners o JOIN users u ON o.user_id = u.user_id ORDER BY o.owner_id";
                        try (PreparedStatement pstmt = conn.prepareStatement(ownerSql);
                             ResultSet rs = pstmt.executeQuery()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>房主ID</th>
                                        <th>用户ID</th>
                                        <th>用户名</th>
                                        <th>姓名</th>
                                        <th>电话</th>
                                        <th>邮箱</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% while (rs.next()) { %>
                                    <tr>
                                        <td><%= rs.getInt("owner_id") %></td>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><%= rs.getString("username") %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("phone") %></td>
                                        <td><%= rs.getString("email") %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- 3. 检查房屋表 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-building"></i> 房屋表检查</h5>
                    </div>
                    <div class="card-body">
                        <%
                        String houseSql = "SELECT h.house_id, h.owner_id, h.title, h.address, h.rent_amount, h.status, o.name as owner_name FROM houses h LEFT JOIN owners o ON h.owner_id = o.owner_id ORDER BY h.house_id";
                        try (PreparedStatement pstmt = conn.prepareStatement(houseSql);
                             ResultSet rs = pstmt.executeQuery()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>房屋ID</th>
                                        <th>房主ID</th>
                                        <th>标题</th>
                                        <th>地址</th>
                                        <th>租金</th>
                                        <th>状态</th>
                                        <th>房主姓名</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% while (rs.next()) { %>
                                    <tr>
                                        <td><%= rs.getInt("house_id") %></td>
                                        <td><%= rs.getInt("owner_id") %></td>
                                        <td><%= rs.getString("title") %></td>
                                        <td><%= rs.getString("address") %></td>
                                        <td>￥<%= rs.getBigDecimal("rent_amount") %></td>
                                        <td>
                                            <span class="badge <%= "AVAILABLE".equals(rs.getString("status")) ? "bg-success" : "bg-warning" %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                        <td><%= rs.getString("owner_name") %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- 4. 检查看房记录表 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-calendar-check"></i> 看房记录表检查</h5>
                    </div>
                    <div class="card-body">
                        <%
                        String viewingSql = "SELECT vr.viewing_id, vr.house_id, vr.tenant_id, vr.viewing_date, vr.viewing_time, vr.status, vr.message, h.title as house_title, t.name as tenant_name FROM viewing_records vr LEFT JOIN houses h ON vr.house_id = h.house_id LEFT JOIN tenants t ON vr.tenant_id = t.tenant_id ORDER BY vr.viewing_id DESC";
                        try (PreparedStatement pstmt = conn.prepareStatement(viewingSql);
                             ResultSet rs = pstmt.executeQuery()) {
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>记录ID</th>
                                        <th>房屋ID</th>
                                        <th>租客ID</th>
                                        <th>看房日期</th>
                                        <th>看房时间</th>
                                        <th>状态</th>
                                        <th>留言</th>
                                        <th>房屋标题</th>
                                        <th>租客姓名</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% while (rs.next()) { %>
                                    <tr>
                                        <td><%= rs.getInt("viewing_id") %></td>
                                        <td><%= rs.getInt("house_id") %></td>
                                        <td><%= rs.getInt("tenant_id") %></td>
                                        <td><%= rs.getDate("viewing_date") %></td>
                                        <td><%= rs.getString("viewing_time") %></td>
                                        <td>
                                            <span class="badge <%= "PENDING".equals(rs.getString("status")) ? "bg-warning" : "APPROVED".equals(rs.getString("status")) ? "bg-success" : "bg-danger" %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                        <td><%= rs.getString("message") %></td>
                                        <td><%= rs.getString("house_title") %></td>
                                        <td><%= rs.getString("tenant_name") %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

            <% } catch (Exception e) { %>
                <div class="alert alert-danger">
                    <h5><i class="bi bi-exclamation-triangle"></i> 数据库连接错误</h5>
                    <p><%= e.getMessage() %></p>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 