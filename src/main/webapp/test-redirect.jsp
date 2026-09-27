<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.house.rental.bean.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重定向测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            padding: 20px;
        }
        .test-container {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .status-success { background-color: #28a745; }
        .status-warning { background-color: #ffc107; }
        .status-danger { background-color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <div class="test-container">
            <h2>重定向问题测试</h2>
            
            <%
                User user = (User) session.getAttribute("user");
                String status = "未登录";
                String statusClass = "status-danger";
                if (user != null) {
                    status = "已登录 - " + user.getType();
                    statusClass = "status-success";
                }
            %>
            
            <div class="mb-3">
                <span class="status-indicator <%= statusClass %>"></span>
                <strong>当前状态:</strong> <%= status %>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <h4>测试链接</h4>
                    <div class="d-grid gap-2">
                        <a href="login" class="btn btn-primary">测试登录页面</a>
                        <a href="register?type=owner" class="btn btn-info">测试房主注册</a>
                        <a href="register?type=tenant" class="btn btn-info">测试租户注册</a>
                        <a href="owner/dashboard" class="btn btn-warning">测试房主仪表盘</a>
                        <a href="tenant/dashboard" class="btn btn-warning">测试租户仪表盘</a>
                        <a href="logout" class="btn btn-danger">测试登出</a>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <h4>调试工具</h4>
                    <div class="d-grid gap-2">
                        <a href="debug-session.jsp" class="btn btn-secondary">查看Session详情</a>
                        <a href="test-login.jsp" class="btn btn-secondary">登录功能测试</a>
                        <button onclick="clearCookies()" class="btn btn-outline-danger">清除浏览器Cookie</button>
                        <button onclick="testRedirect()" class="btn btn-outline-primary">测试重定向</button>
                    </div>
                </div>
            </div>
            
            <div class="mt-4">
                <h4>测试说明</h4>
                <ul>
                    <li><strong>绿色圆点</strong>：已登录状态</li>
                    <li><strong>红色圆点</strong>：未登录状态</li>
                    <li><strong>黄色圆点</strong>：警告状态</li>
                    <li>如果遇到重定向循环，请先清除Cookie再测试</li>
                    <li>使用调试工具查看详细的Session信息</li>
                </ul>
            </div>
        </div>
        
        <div class="test-container">
            <h4>重定向历史记录</h4>
            <div id="redirectLog" class="border p-3 bg-light">
                <p class="text-muted">重定向记录将在这里显示...</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function clearCookies() {
            if (confirm('确定要清除所有Cookie吗？这将清除您的登录状态。')) {
                document.cookie.split(";").forEach(function(c) { 
                    document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
                });
                alert('Cookie已清除，请刷新页面');
                location.reload();
            }
        }
        
        function testRedirect() {
            const log = document.getElementById('redirectLog');
            log.innerHTML = '<p>开始测试重定向...</p>';
            
            // 测试登录页面
            fetch('login')
                .then(response => {
                    log.innerHTML += '<p>✓ 登录页面访问成功</p>';
                    return fetch('owner/dashboard');
                })
                .then(response => {
                    log.innerHTML += '<p>✓ 房主主页访问成功</p>';
                    return fetch('tenant/dashboard');
                })
                .then(response => {
                    log.innerHTML += '<p>✓ 租户主页访问成功</p>';
                    log.innerHTML += '<p class="text-success"><strong>所有测试完成！</strong></p>';
                })
                .catch(error => {
                    log.innerHTML += '<p class="text-danger">✗ 测试失败: ' + error.message + '</p>';
                });
        }
        
        // 页面加载时记录
        document.addEventListener('DOMContentLoaded', function() {
            const log = document.getElementById('redirectLog');
            log.innerHTML = '<p>页面加载时间: ' + new Date().toLocaleString() + '</p>';
        });
    </script>
</body>
</html> 