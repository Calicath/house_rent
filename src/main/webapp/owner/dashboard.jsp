<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房东主页 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
        }
        .main-content {
            margin-left: 220px;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto 0 auto;
            padding: 24px;
            padding-top: 70px;
            margin-left: 0;
        }
        .stat-card {
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            background: #fff;
            padding: 32px 24px 24px 24px;
            text-align: center;
            margin-bottom: 24px;
        }
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #667eea;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
        }
        .stat-label {
            color: #888;
            font-size: 1rem;
        }
        .action-card {
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            background: #fff;
            padding: 24px 16px;
            margin-bottom: 32px;
        }
        .action-btn {
            min-width: 160px;
            margin: 8px 12px;
            font-size: 1.1rem;
            padding: 12px 0;
            border-radius: 8px;
        }
        .section-card {
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            background: #fff;
            padding: 24px 24px 16px 24px;
            margin-bottom: 32px;
        }
        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 18px;
            color: #333;
        }
        .empty-tip {
            color: #aaa;
            text-align: center;
            margin: 32px 0 16px 0;
        }
        .add-btn {
            display: block;
            margin: 0 auto;
            margin-top: 12px;
        }
        @media (max-width: 991px) {
            .dashboard-container { padding: 8px; }
            .stat-card, .action-card, .section-card { padding: 16px 8px; }
        }
        @media (max-width: 767px) {
            .stat-card { margin-bottom: 16px; }
            .action-btn { min-width: 120px; font-size: 1rem; }
            .section-title { font-size: 1.1rem; }
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/owner/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/owner/houses">
                        <i class="bi bi-building"></i> 我的房屋
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/owner/profile">
                        <i class="bi bi-person"></i> 个人信息
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="dashboard-container">
            <!-- 注册成功欢迎消息 -->
            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i> 
                    <strong>欢迎加入房屋租赁系统！</strong> 您的房主账户已成功创建。现在您可以开始添加房屋和管理租赁业务了。
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- 统计区 -->
            <div class="row g-4 mb-2">
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-building"></i></div>
                        <div class="stat-value">${totalHouses}</div>
                        <div class="stat-label">房屋总数</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-house-door"></i></div>
                        <div class="stat-value">${rentedHouses}</div>
                        <div class="stat-label">已出租</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-clock-history"></i></div>
                        <div class="stat-value">${pendingTransactions}</div>
                        <div class="stat-label">待处理交易</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-currency-yen"></i></div>
                        <div class="stat-value">￥${monthlyIncome}</div>
                        <div class="stat-label">本月收入</div>
                    </div>
                </div>
            </div>

            <!-- 快速操作区 -->
            <div class="action-card text-center mb-4">
                <div class="row justify-content-center">
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/owner/add-house" class="btn btn-primary action-btn"><i class="bi bi-plus-circle"></i> 添加房屋</a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-outline-primary action-btn"><i class="bi bi-bar-chart"></i> 管理房屋</a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/owner/viewing-requests" class="btn btn-outline-warning action-btn"><i class="bi bi-calendar-check"></i> 看房申请</a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-outline-success action-btn"><i class="bi bi-currency-dollar"></i> 查看交易</a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/owner/profile" class="btn btn-outline-info action-btn"><i class="bi bi-person"></i> 个人信息</a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/forum" class="btn btn-outline-info action-btn"><i class="bi bi-chat-dots"></i> 进入论坛</a>
                    </div>
                </div>
            </div>

            <!-- 最近交易区 -->
            <div class="section-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="section-title">最近交易</div>
                    <a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-link">查看全部</a>
                </div>
                <c:choose>
                    <c:when test="${not empty recentTransactions}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>交易ID</th>
                                        <th>房屋ID</th>
                                        <th>租户ID</th>
                                        <th>金额</th>
                                        <th>状态</th>
                                        <th>时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentTransactions}" var="transaction">
                                        <tr>
                                            <td>${transaction.transactionId}</td>
                                            <td>${transaction.house.houseId}</td>
                                            <td>${transaction.tenant.tenantId}</td>
                                            <td>￥${transaction.rentAmount}</td>
                                            <td>${transaction.status}</td>
                                            <td>${transaction.startDate}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/owner/transaction-detail?id=${transaction.transactionId}" class="btn btn-sm btn-outline-primary">详情</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-tip">
                            <i class="bi bi-inbox" style="font-size:2.5rem;"></i><br>
                            暂无交易记录
                        </div>
                        <a href="${pageContext.request.contextPath}/owner/add-house" class="btn btn-primary add-btn">添加第一套房屋</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 我的房屋区 -->
            <div class="section-card">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="section-title">我的房屋</div>
                    <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-link">管理房屋</a>
                </div>
                <c:choose>
                    <c:when test="${not empty houses}">
                        <div class="row g-3">
                            <c:forEach items="${houses}" var="house">
                                <div class="col-md-4 col-sm-6">
                                    <div class="card h-100 shadow-sm">
                                        <div class="card-body">
                                            <h5 class="card-title"><i class="bi bi-house-door"></i> ${house.title}</h5>
                                            <p class="card-text text-muted mb-1">地址：${house.address}</p>
                                            <p class="card-text mb-1">状态：<span class="badge ${house.status == 'RENTED' ? 'bg-success' : 'bg-secondary'}">${house.status}</span></p>
                                            <p class="card-text">月租：<span class="text-primary">￥${house.rent}</span></p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-tip">
                            <i class="bi bi-building" style="font-size:2.5rem;"></i><br>
                            暂无房屋信息
                        </div>
                        <a href="${pageContext.request.contextPath}/owner/add-house" class="btn btn-primary add-btn">+ 添加房屋</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 