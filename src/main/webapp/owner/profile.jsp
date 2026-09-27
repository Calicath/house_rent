<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息 - 房东中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            position: fixed;
            top: 70px;
            bottom: 0;
            left: 0;
            z-index: 100;
            height: calc(100vh - 70px);
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
            background-color: #f8f9fa;
        }
        .main-content {
            margin-left: 220px;
            padding: 20px;
        }
        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f8f9fa;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 2.5rem;
        }
        .info-group {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        .info-value {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">房屋租赁系统</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">主页</a>
                    </li>
                    <li class="nav-item">
                        <span class="navbar-text me-3">
                            <i class="bi bi-person"></i> 欢迎，${user.username}！
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> 退出
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 侧边栏 -->
    <nav class="col-md-3 col-lg-2 d-md-block sidebar">
        <div class="sidebar-sticky">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/owner/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/owner/houses">
                        <i class="bi bi-building"></i> 我的房屋
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/owner/profile">
                        <i class="bi bi-person"></i> 个人信息
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="container-fluid">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <h3>房东个人信息</h3>
                    <p class="text-muted">管理您的账户信息和房东资料</p>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-group mb-3">
                            <div class="info-label">用户名</div>
                            <div class="info-value">${user.username}</div>
                        </div>
                        <div class="info-group mb-3">
                            <div class="info-label">姓名</div>
                            <div class="info-value">${owner.name}</div>
                        </div>
                        <div class="info-group mb-3">
                            <div class="info-label">联系电话</div>
                            <div class="info-value">${owner.phone}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-group mb-3">
                            <div class="info-label">地址</div>
                            <div class="info-value">${owner.address}</div>
                        </div>
                        <div class="info-group mb-3">
                            <div class="info-label">用户ID</div>
                            <div class="info-value">${user.userId}</div>
                        </div>
                        <div class="info-group mb-3">
                            <div class="info-label">房东ID</div>
                            <div class="info-value">${owner.ownerId}</div>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary mt-3">返回</a>
            </div>
        </div>
    </main>
</body>
</html> 