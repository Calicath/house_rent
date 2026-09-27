<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-header h2 {
            color: #333;
            font-weight: 600;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .register-link {
            text-align: center;
            margin-top: 1rem;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>欢迎回来</h2>
            <p class="text-muted">请登录您的账户</p>
        </div>
        
        <!-- 显示错误信息 -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- 显示URL参数中的错误信息 -->
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <% if ("invalid_user_type".equals(request.getParameter("error"))) { %>
                    用户类型无效，请重新登录
                <% } else { %>
                    登录失败，请重试
                <% } %>
            </div>
        <% } %>
        
        <!-- 显示成功信息 -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <!-- 显示URL参数中的成功信息 -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <% if ("logout".equals(request.getParameter("success"))) { %>
                    已成功退出登录
                <% } else { %>
                    <%= request.getParameter("success") %>
                <% } %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">用户名</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">密码</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-login">登录</button>
        </form>
        
        <div class="register-link">
            <p>还没有账户？ <a href="register">立即注册</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 