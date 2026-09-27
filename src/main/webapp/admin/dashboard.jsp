<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员仪表盘 - 房屋租赁系统</title>
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
            color: #dc3545;
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
        .navbar-custom {
            background-color: #ffa12d !important;
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
            <a class="navbar-brand" href="#">房屋租赁系统 - 管理员</a>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="bi bi-people"></i> 用户管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/houses">
                        <i class="bi bi-building"></i> 房屋管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/transactions">
                        <i class="bi bi-currency-dollar"></i> 交易管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/forum">
                        <i class="bi bi-chat-dots"></i> 论坛管理
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="dashboard-container">
            <!-- 统计区 -->
            <div class="row g-4 mb-2">
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-people"></i></div>
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-label">总用户数</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-building"></i></div>
                        <div class="stat-value">${totalHouses}</div>
                        <div class="stat-label">房屋总数</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
                        <div class="stat-value">${activeTransactions}</div>
                        <div class="stat-label">活跃交易</div>
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
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-danger action-btn">
                            <i class="bi bi-people"></i> 用户管理
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/admin/houses" class="btn btn-outline-danger action-btn">
                            <i class="bi bi-building"></i> 房屋管理
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-outline-warning action-btn">
                            <i class="bi bi-currency-dollar"></i> 交易管理
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/forum" class="btn btn-outline-primary action-btn">
                            <i class="bi bi-chat-dots"></i> 论坛管理
                        </a>
                    </div>
                </div>
            </div>

            <!-- 用户统计区 -->
            <div class="section-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="section-title">用户统计</div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-link">查看全部</a>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title text-danger">
                                    <i class="bi bi-person-badge"></i> 房主
                                </h5>
                                <h3 class="text-danger">${ownerCount}</h3>
                                <p class="text-muted">注册房主数量</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title text-primary">
                                    <i class="bi bi-person-check"></i> 租户
                                </h5>
                                <h3 class="text-primary">${tenantCount}</h3>
                                <p class="text-muted">注册租户数量</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title text-success">
                                    <i class="bi bi-shield-check"></i> 管理员
                                </h5>
                                <h3 class="text-success">1</h3>
                                <p class="text-muted">系统管理员</p>
                            </div>
                        </div>
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
                                        <th>房屋</th>
                                        <th>房主</th>
                                        <th>租户</th>
                                        <th>金额</th>
                                        <th>状态</th>
                                        <th>开始日期</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentTransactions}" var="transaction">
                                        <tr>
                                            <td>${transaction.transactionId}</td>
                                            <td>${transaction.house.title}</td>
                                            <td>${transaction.owner.user.username}</td>
                                            <td>${transaction.tenant.user.username}</td>
                                            <td>￥${transaction.rentAmount}</td>
                                            <td>
                                                <span class="badge bg-${transaction.status == 'ACTIVE' ? 'success' : 
                                                                       transaction.status == 'PENDING' ? 'warning' : 
                                                                       transaction.status == 'COMPLETED' ? 'info' : 'secondary'}">
                                                    ${transaction.status}
                                                </span>
                                            </td>
                                            <td>${transaction.startDate}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/transaction/edit?id=${transaction.transactionId}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    编辑
                                                </a>
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
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 系统概览区 -->
            <div class="section-card">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="section-title">系统概览</div>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-graph-up text-success"></i> 交易统计
                                </h5>
                                <div class="row text-center">
                                    <div class="col-4">
                                        <h4 class="text-success">${activeTransactionCount}</h4>
                                        <small class="text-muted">活跃</small>
                                    </div>
                                    <div class="col-4">
                                        <h4 class="text-warning">${pendingTransactionCount}</h4>
                                        <small class="text-muted">待处理</small>
                                    </div>
                                    <div class="col-4">
                                        <h4 class="text-info">${completedTransactionCount}</h4>
                                        <small class="text-muted">已完成</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-gear text-primary"></i> 系统状态
                                </h5>
                                <div class="row text-center">
                                    <div class="col-6">
                                        <h4 class="text-primary">${totalHouses}</h4>
                                        <small class="text-muted">房屋总数</small>
                                    </div>
                                    <div class="col-6">
                                        <h4 class="text-danger">${totalUsers}</h4>
                                        <small class="text-muted">用户总数</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 