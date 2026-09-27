<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.house.rental.bean.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session 调试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            padding: 20px;
        }
        .debug-container {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .info-item {
            background: #f8f9fa;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="debug-container">
            <h2>Session 调试信息</h2>
            
            <div class="info-item">
                <strong>Session ID:</strong> <%= session.getId() %>
            </div>
            
            <div class="info-item">
                <strong>Session 创建时间:</strong> <%= new java.util.Date(session.getCreationTime()) %>
            </div>
            
            <div class="info-item">
                <strong>Session 最后访问时间:</strong> <%= new java.util.Date(session.getLastAccessedTime()) %>
            </div>
            
            <div class="info-item">
                <strong>Session 是否为新创建:</strong> <%= session.isNew() %>
            </div>
            
            <%
                User user = (User) session.getAttribute("user");
                if (user != null) {
            %>
                <div class="alert alert-success">
                    <h4>用户信息</h4>
                    <p><strong>用户ID:</strong> <%= user.getUserId() %></p>
                    <p><strong>用户名:</strong> <%= user.getUsername() %></p>
                    <p><strong>用户类型:</strong> <%= user.getType() %></p>
                    <p><strong>状态:</strong> <%= user.getStatus() %></p>
                    <p><strong>引用ID:</strong> <%= user.getReferenceId() %></p>
                </div>
            <% } else { %>
                <div class="alert alert-warning">
                    <h4>未登录</h4>
                    <p>当前没有用户登录</p>
                </div>
            <% } %>
            
            <div class="mt-3">
                <a href="login" class="btn btn-primary">去登录</a>
                <a href="index.jsp" class="btn btn-secondary">返回首页</a>
                <a href="logout" class="btn btn-danger">清除Session</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 