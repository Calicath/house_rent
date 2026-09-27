<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息 - 租客中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 48px 0 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
            background-color: #fff;
        }
        .main-content {
            margin-left: 240px;
            padding: 20px;
            padding-top: 80px;
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
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
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
        .navbar-custom .navbar-nav {
            align-items: center;
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/tenant/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/house/search">
                        <i class="bi bi-search"></i> 浏览房屋
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/tenant/profile">
                        <i class="bi bi-person"></i> 个人信息
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="container-fluid">
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

            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="bi bi-person"></i>
                    </div>
                    <h3>个人信息</h3>
                    <p class="text-muted">管理您的账户信息和租赁资料</p>
                </div>

                <form action="${pageContext.request.contextPath}/tenant/update-profile" method="post">
                    <div class="row">
                        <!-- 基本信息 -->
                        <div class="col-md-6">
                            <h5 class="mb-3"><i class="bi bi-person-badge"></i> 基本信息</h5>
                            
                            <div class="mb-3">
                                <label for="username" class="form-label">用户名</label>
                                <input type="text" class="form-control" id="username" value="${user.username}" readonly>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">邮箱</label>
                                <input type="email" class="form-control" id="email" name="email" value="${user.email}">
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">手机号码</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                            </div>

                            <div class="mb-3">
                                <label for="idCard" class="form-label">身份证号</label>
                                <input type="text" class="form-control" id="idCard" value="${user.idCard}" readonly>
                            </div>
                        </div>

                        <!-- 租客特有信息 -->
                        <div class="col-md-6">
                            <h5 class="mb-3"><i class="bi bi-file-person"></i> 租客信息</h5>
                            
                            <div class="mb-3">
                                <label for="gender" class="form-label">性别</label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="">请选择性别</option>
                                    <option value="M" ${tenant.gender == 'M' ? 'selected' : ''}>男</option>
                                    <option value="F" ${tenant.gender == 'F' ? 'selected' : ''}>女</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="emergencyContact" class="form-label">紧急联系人</label>
                                <input type="text" class="form-control" id="emergencyContact" name="emergencyContact" value="${tenant.emergencyContact}">
                            </div>

                            <div class="mb-3">
                                <label for="emergencyPhone" class="form-label">紧急联系电话</label>
                                <input type="tel" class="form-control" id="emergencyPhone" name="emergencyPhone" value="${tenant.emergencyPhone}">
                            </div>

                            <div class="mb-3">
                                <label for="occupation" class="form-label">职业</label>
                                <input type="text" class="form-control" id="occupation" name="occupation" value="${tenant.occupation}">
                            </div>

                            <div class="mb-3">
                                <label for="employer" class="form-label">工作单位</label>
                                <input type="text" class="form-control" id="employer" name="employer" value="${tenant.employer}">
                            </div>

                            <div class="mb-3">
                                <label for="income" class="form-label">月收入</label>
                                <input type="text" class="form-control" id="income" name="income" value="${tenant.income}" placeholder="例如：8000">
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <h5 class="mb-3"><i class="bi bi-info-circle"></i> 租赁状态</h5>
                            <div class="info-group">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="info-label">租客状态</div>
                                        <div class="info-value">
                                            <span class="badge bg-${tenant.status == 'ACTIVE' ? 'success' : 'secondary'}">${tenant.status}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="info-label">入住日期</div>
                                        <div class="info-value">${tenant.moveInDate != null ? tenant.moveInDate : '未设置'}</div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="info-label">搬出日期</div>
                                        <div class="info-value">${tenant.moveOutDate != null ? tenant.moveOutDate : '未设置'}</div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="info-label">信用评分</div>
                                        <div class="info-value">${tenant.creditScore != null ? tenant.creditScore : '未评估'}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between">
                                <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                                    <i class="bi bi-arrow-left"></i> 返回
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> 保存更改
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const phone = document.getElementById('phone').value;
            const gender = document.getElementById('gender').value;
            
            if (!phone || phone.trim() === '') {
                e.preventDefault();
                alert('请输入手机号码！');
                return;
            }
            
            if (!gender) {
                e.preventDefault();
                alert('请选择性别！');
                return;
            }
            
            // 手机号格式验证
            const phonePattern = /^1[3-9]\d{9}$/;
            if (!phonePattern.test(phone)) {
                e.preventDefault();
                alert('请输入正确的手机号码！');
                return;
            }
        });
    </script>
</body>
</html> 