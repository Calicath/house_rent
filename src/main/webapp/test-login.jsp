<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .test-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 500px;
        }
        .test-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .test-header h2 {
            color: #333;
            font-weight: 600;
        }
        .btn-test {
            margin: 0.5rem;
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-header">
            <h2>登录功能测试</h2>
            <p class="text-muted">测试不同的登录场景</p>
        </div>
        
        <div class="d-grid gap-3">
            <a href="login" class="btn btn-primary btn-test">测试正常登录页面</a>
            <a href="login?error=invalid_user_type" class="btn btn-warning btn-test">测试用户类型错误</a>
            <a href="login?success=logout" class="btn btn-success btn-test">测试登出成功消息</a>
            <a href="register?type=owner" class="btn btn-info btn-test">测试房主注册</a>
            <a href="register?type=tenant" class="btn btn-info btn-test">测试租户注册</a>
            <a href="owner/dashboard" class="btn btn-secondary btn-test">测试房主仪表盘（未登录）</a>
            <a href="tenant/dashboard" class="btn btn-secondary btn-test">测试租户仪表盘（未登录）</a>
        </div>
        
        <div class="mt-4 text-center">
            <a href="index.jsp" class="btn btn-outline-primary">返回首页</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 