<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房屋租赁系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background-color: #f8f9fa;
            padding: 100px 0;
            text-align: center;
        }
        .feature-section {
            padding: 60px 0;
        }
        .feature-card {
            text-align: center;
            padding: 20px;
            margin-bottom: 20px;
        }
        .feature-icon {
            font-size: 48px;
            margin-bottom: 20px;
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">房屋租赁管理系统</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">登录</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp">注册</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <section class="hero-section">
        <div class="container">
            <h1 class="display-4">欢迎使用房屋租赁管理系统</h1>
            <p class="lead">为您提供安全、便捷的房屋租赁服务</p>
            <div class="mt-4">
                <a href="register.jsp" class="btn btn-primary btn-lg me-2">立即注册</a>
                <a href="login.jsp" class="btn btn-outline-primary btn-lg">登录</a>
            </div>
        </div>
    </section>

    <section class="feature-section">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">🏠</div>
                        <h3>房源管理</h3>
                        <p>房主可以轻松发布和管理房源信息</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">🔍</div>
                        <h3>房源搜索</h3>
                        <p>租户可以快速找到心仪的房源</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">💬</div>
                        <h3>在线交流</h3>
                        <p>提供便捷的在线沟通平台</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="bg-light py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">数据库应用课程设计-房屋租赁管理系统-陈新蕾、邵学雯、方晓瑞</p>
        </div>
    </footer>

    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html> 