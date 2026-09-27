<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>看房申请管理 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .request-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid #007bff;
        }
        .request-card.pending {
            border-left-color: #ffc107;
        }
        .request-card.approved {
            border-left-color: #28a745;
        }
        .request-card.rejected {
            border-left-color: #dc3545;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .tenant-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .stats-card {
            text-align: center;
            padding: 1.5rem;
            border-radius: 10px;
            color: white;
            margin-bottom: 1rem;
        }
        .stats-card.pending {
            background: linear-gradient(135deg, #ffc107 0%, #ff8c00 100%);
        }
        .stats-card.approved {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .stats-card.rejected {
            background: linear-gradient(135deg, #dc3545 0%, #e74c3c 100%);
        }
        .stats-card.total {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-house-door"></i> 房屋租赁系统
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/owner/dashboard">
                            <i class="bi bi-speedometer2"></i> 个人中心
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/owner/houses">
                            <i class="bi bi-house"></i> 我的房屋
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/owner/viewing-requests">
                            <i class="bi bi-calendar-check"></i> 看房申请
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person"></i> ${user.username}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/owner/dashboard">房主中心</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">退出登录</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <!-- 成功消息显示 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 错误消息显示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="dashboard-card">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4">
                        <i class="bi bi-calendar-check"></i> 看房申请管理
                    </h2>
                </div>
            </div>

            <!-- 统计信息 -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card total">
                        <h3>${totalRequests}</h3>
                        <p class="mb-0">总申请数</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card pending">
                        <h3>${pendingCount}</h3>
                        <p class="mb-0">待处理</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card approved">
                        <h3>${approvedCount}</h3>
                        <p class="mb-0">已同意</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card rejected">
                        <h3>${rejectedCount}</h3>
                        <p class="mb-0">已拒绝</p>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty message}">
                    <div class="text-center py-5">
                        <i class="bi bi-inbox display-1 text-muted"></i>
                        <h4 class="mt-3 text-muted">${message}</h4>
                        <a href="${pageContext.request.contextPath}/owner/add-house" class="btn btn-primary mt-3">
                            <i class="bi bi-plus-circle"></i> 发布房屋
                        </a>
                    </div>
                </c:when>
                <c:when test="${empty viewingRecords}">
                    <div class="text-center py-5">
                        <i class="bi bi-calendar-x display-1 text-muted"></i>
                        <h4 class="mt-3 text-muted">暂无看房申请</h4>
                        <p class="text-muted">当有租客申请看房时，申请会显示在这里</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- 看房申请列表 -->
                    <div class="row">
                        <div class="col-12">
                            <h5 class="mb-3">申请列表</h5>
                        </div>
                    </div>

                    <c:forEach items="${viewingRecords}" var="record">
                        <div class="request-card ${record.status.toLowerCase()}">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="mb-0">
                                            <i class="bi bi-house"></i> ${record.house.title}
                                        </h6>
                                        <span class="badge status-badge bg-${record.status == 'PENDING' ? 'warning' : 
                                                                           record.status == 'APPROVED' ? 'success' : 'danger'}">
                                            ${record.status == 'PENDING' ? '待处理' : 
                                              record.status == 'APPROVED' ? '已同意' : '已拒绝'}
                                        </span>
                                    </div>
                                    
                                    <p class="text-muted mb-2">
                                        <i class="bi bi-geo-alt"></i> ${record.house.address}
                                    </p>
                                    
                                    <div class="tenant-info">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong>租客信息：</strong><br>
                                                <small class="text-muted">
                                                    <i class="bi bi-person"></i> ${record.tenant.user.username}<br>
                                                    <i class="bi bi-telephone"></i> ${record.tenant.user.phone}<br>
                                                    <i class="bi bi-envelope"></i> ${record.tenant.user.email}
                                                </small>
                                            </div>
                                            <div class="col-md-6">
                                                <strong>看房时间：</strong><br>
                                                <small class="text-muted">
                                                    <i class="bi bi-calendar"></i> 
                                                    <c:choose>
                                                        <c:when test="${not empty record.viewingTime}">
                                                            ${record.viewingTime.toLocalDate()}<br>
                                                            <i class="bi bi-clock"></i> 
                                                            ${record.viewingTime.toLocalTime()}
                                                        </c:when>
                                                        <c:otherwise>
                                                            未设置<br>
                                                            <i class="bi bi-clock"></i> 
                                                            未设置
                                                        </c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty record.message}">
                                            <div class="mt-2">
                                                <strong>留言：</strong><br>
                                                <small class="text-muted">${record.message}</small>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 text-end">
                                    <c:if test="${record.status == 'PENDING'}">
                                        <button class="btn btn-success btn-sm mb-1" 
                                                onclick="approveViewing(${record.recordId})">
                                            <i class="bi bi-check-circle"></i> 同意
                                        </button>
                                        <button class="btn btn-danger btn-sm mb-1" 
                                                onclick="rejectViewing(${record.recordId})">
                                            <i class="bi bi-x-circle"></i> 拒绝
                                        </button>
                                    </c:if>
                                    
                                    <c:if test="${record.status == 'APPROVED'}">
                                        <span class="badge bg-success">
                                            <i class="bi bi-check-circle"></i> 已同意
                                        </span>
                                    </c:if>
                                    
                                    <c:if test="${record.status == 'REJECTED'}">
                                        <span class="badge bg-danger">
                                            <i class="bi bi-x-circle"></i> 已拒绝
                                        </span>
                                    </c:if>
                                    
                                    <div class="mt-2">
                                        <small class="text-muted">
                                            申请时间：
                                            <c:choose>
                                                <c:when test="${not empty record.createdAt}">
                                                    ${record.createdAt.toLocalDate()} ${record.createdAt.toLocalTime()}
                                                </c:when>
                                                <c:otherwise>
                                                    未知
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 更新看房申请状态
        function updateViewingStatus(recordId, action) {
            fetch('${pageContext.request.contextPath}/owner/process-viewing', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `recordId=${recordId}&action=${action}`
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                    return;
                }
                return response.text();
            })
            .then(data => {
                alert(action === 'APPROVED' ? '已同意看房申请' : '已拒绝看房申请');
                location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作时发生错误');
            });
        }

        // 同意看房申请
        function approveViewing(recordId) {
            if (confirm('确定同意这个看房申请吗？')) {
                updateViewingStatus(recordId, 'APPROVED');
            }
        }

        // 拒绝看房申请
        function rejectViewing(recordId) {
            if (confirm('确定拒绝这个看房申请吗？')) {
                updateViewingStatus(recordId, 'REJECTED');
            }
        }
    </script>
</body>
</html> 