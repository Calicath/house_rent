<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>租户主页 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 48px 0 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
            background-color: #f8f9fa;
        }
        .sidebar-sticky {
            position: relative;
            top: 0;
            height: calc(100vh - 48px);
            padding-top: .5rem;
            overflow-x: hidden;
            overflow-y: auto;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .main-content {
            margin-left: 240px;
            padding: 20px;
            padding-top: 80px;
        }
        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,.075);
        }
        .stat-card {
            border-left: 4px solid #764ba2;
        }
        .navbar-custom {
            background-color: #764BA2FF !important;
        }
        .navbar-custom .navbar-brand,
        .navbar-custom .nav-link,
        .navbar-custom .navbar-text,
        .navbar-custom .bi {
            color: #fff !important;
        }
        .navbar-custom .nav-link:hover,
        .navbar-custom .navbar-brand:hover {
            color: #e0e0e0 !important;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top">
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/tenant/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/tenant/rentals">
                        <i class="bi bi-building"></i> 我的租赁
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/tenant/payments">
                        <i class="bi bi-currency-dollar"></i> 支付记录
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/tenant/profile">
                        <i class="bi bi-person"></i> 个人信息
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- 注册成功欢迎消息 -->
            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i> 
                    <strong>欢迎加入房屋租赁系统！</strong> 您的租客账户已成功创建。现在您可以开始浏览房屋和申请租赁了。
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- 统计卡片 -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <h5 class="card-title">当前租赁</h5>
                            <h2 class="card-text">${activeRentalsCount}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <h5 class="card-title">待支付</h5>
                            <h2 class="card-text">${pendingPayments}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <h5 class="card-title">本月支出</h5>
                            <h2 class="card-text">￥${monthlyExpenses}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <h5 class="card-title">待处理申请</h5>
                            <h2 class="card-text">${pendingApplications}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 快速操作 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">快速操作</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/house/search" class="btn btn-primary w-100">
                                        <i class="bi bi-search"></i><br>
                                        浏览房屋
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/tenant/rentals" class="btn btn-outline-primary w-100">
                                        <i class="bi bi-building"></i><br>
                                        我的租赁
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/tenant/payments" class="btn btn-outline-success w-100">
                                        <i class="bi bi-currency-dollar"></i><br>
                                        支付记录
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/tenant/profile" class="btn btn-outline-info w-100">
                                        <i class="bi bi-person"></i><br>
                                        个人信息
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/forum" class="btn btn-outline-info w-100">
                                        <i class="bi bi-chat-dots"></i><br>
                                        进入论坛
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 当前租赁 -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">当前租赁</h5>
                    <a href="${pageContext.request.contextPath}/tenant/rentals" class="btn btn-primary btn-sm">
                        查看全部
                    </a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty activeRentals}">
                            <div class="row">
                                <c:forEach items="${activeRentals}" var="rental">
                                    <div class="col-md-6 mb-4">
                                        <div class="card h-100">
                                            <img src="${rental.house.imageUrl}" class="card-img-top" alt="${rental.house.title}">
                                            <div class="card-body">
                                                <h5 class="card-title">${rental.house.title}</h5>
                                                <p class="card-text">
                                                    <i class="bi bi-geo-alt"></i> ${rental.house.address}<br>
                                                    <i class="bi bi-currency-dollar"></i> ${rental.rentAmount}/月<br>
                                                    <i class="bi bi-calendar"></i> ${rental.startDate} 至 ${rental.endDate}
                                                </p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="badge bg-${rental.status == 'ACTIVE' ? 'success' : 
                                                                       rental.status == 'PENDING' ? 'warning' : 'secondary'}">
                                                        ${rental.status}
                                                    </span>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/tenant/rental?id=${rental.transactionId}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            详情
                                                        </a>
                                                        <c:if test="${rental.status == 'ACTIVE'}">
                                                            <a href="${pageContext.request.contextPath}/tenant/payment?rentalId=${rental.transactionId}" 
                                                               class="btn btn-sm btn-outline-success">
                                                                支付租金
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="bi bi-building display-1 text-muted"></i>
                                <p class="text-muted mt-3">您还没有任何租赁记录</p>
                                <a href="${pageContext.request.contextPath}/house/search" class="btn btn-primary">
                                    开始浏览房屋
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 最近支付记录 -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">最近支付记录</h5>
                    <a href="${pageContext.request.contextPath}/tenant/payments" class="btn btn-primary btn-sm">
                        查看全部
                    </a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty recentPayments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>支付编号</th>
                                            <th>房屋</th>
                                            <th>金额</th>
                                            <th>支付日期</th>
                                            <th>状态</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentPayments}" var="payment">
                                            <tr>
                                                <td>${payment.paymentId}</td>
                                                <td>${payment.transaction.house.title}</td>
                                                <td>￥${payment.amount}</td>
                                                <td>${payment.paymentDate}</td>
                                                <td>
                                                    <span class="badge bg-${payment.status == 'SUCCESS' ? 'success' : 
                                                                       payment.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${payment.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/tenant/payment?id=${payment.paymentId}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        详情
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="bi bi-credit-card display-1 text-muted"></i>
                                <p class="text-muted mt-3">暂无支付记录</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 