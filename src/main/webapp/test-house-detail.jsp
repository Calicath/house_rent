<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房屋详情测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .test-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/house/search">
                            <i class="bi bi-search"></i> 浏览房屋
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty user}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person"></i> ${user.username}
                                </a>
                                <ul class="dropdown-menu">
                                    <c:if test="${user.type == 'TENANT'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tenant/dashboard">租客中心</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tenant/profile">个人信息</a></li>
                                    </c:if>
                                    <c:if test="${user.type == 'OWNER'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/owner/dashboard">房主中心</a></li>
                                    </c:if>
                                    <c:if test="${user.type == 'ADMIN'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">管理后台</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">退出登录</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">登录</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">注册</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="test-card">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4">
                        <i class="bi bi-house"></i> 房屋详情功能测试
                    </h2>
                </div>
            </div>

            <!-- 测试表单 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-search"></i> 测试房屋详情</h5>
                        </div>
                        <div class="card-body">
                            <form id="testHouseDetailForm" method="GET" action="${pageContext.request.contextPath}/house/detail">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="houseId" class="form-label">房屋ID <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="houseId" name="id" 
                                                   value="1" required placeholder="请输入房屋ID">
                                            <small class="text-muted">请输入一个存在的房屋ID进行测试</small>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-search"></i> 查看房屋详情
                                                </button>
                                                <button type="button" class="btn btn-outline-secondary ms-2" onclick="testMultipleHouses()">
                                                    <i class="bi bi-list"></i> 批量测试
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 快速测试链接 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-lightning"></i> 快速测试链接</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=1" class="btn btn-outline-primary w-100">
                                        房屋ID: 1
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=2" class="btn btn-outline-primary w-100">
                                        房屋ID: 2
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=3" class="btn btn-outline-primary w-100">
                                        房屋ID: 3
                                    </a>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=4" class="btn btn-outline-primary w-100">
                                        房屋ID: 4
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 错误测试 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-exclamation-triangle"></i> 错误测试</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail" class="btn btn-outline-warning w-100">
                                        无ID参数
                                    </a>
                                </div>
                                <div class="col-md-4 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=999" class="btn btn-outline-warning w-100">
                                        不存在的房屋ID
                                    </a>
                                </div>
                                <div class="col-md-4 mb-2">
                                    <a href="${pageContext.request.contextPath}/house/detail?id=abc" class="btn btn-outline-warning w-100">
                                        无效的ID格式
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 使用说明 -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-info-circle"></i> 使用说明</h5>
                        </div>
                        <div class="card-body">
                            <ol>
                                <li><strong>正常测试</strong>：输入存在的房屋ID，查看房屋详情页面是否正常显示</li>
                                <li><strong>快速测试</strong>：点击快速测试链接，直接跳转到对应的房屋详情页面</li>
                                <li><strong>错误测试</strong>：测试各种错误情况下的页面响应</li>
                                <li><strong>功能验证</strong>：
                                    <ul>
                                        <li>房屋基本信息是否正确显示</li>
                                        <li>房主信息是否正确显示（姓名、电话、邮箱）</li>
                                        <li>申请看房按钮是否正常显示（仅租客可见）</li>
                                        <li>编辑/删除按钮是否正常显示（仅房主可见）</li>
                                    </ul>
                                </li>
                            </ol>
                            <div class="alert alert-info">
                                <strong>注意：</strong>如果出现错误，请检查控制台日志和服务器日志以获取详细信息。
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 批量测试功能
        function testMultipleHouses() {
            const houseIds = [1, 2, 3, 4, 5];
            let currentIndex = 0;
            
            function testNextHouse() {
                if (currentIndex < houseIds.length) {
                    const houseId = houseIds[currentIndex];
                    console.log(`测试房屋ID: ${houseId}`);
                    
                    // 在新窗口中打开房屋详情
                    window.open(`${window.location.origin}${window.location.pathname.replace('test-house-detail.jsp', '')}/house/detail?id=${houseId}`, '_blank');
                    
                    currentIndex++;
                    setTimeout(testNextHouse, 1000); // 1秒后测试下一个
                }
            }
            
            testNextHouse();
        }

        // 表单提交处理
        document.getElementById('testHouseDetailForm').addEventListener('submit', function(e) {
            const houseId = document.getElementById('houseId').value;
            if (!houseId || houseId.trim() === '') {
                e.preventDefault();
                alert('请输入房屋ID');
                return;
            }
            
            console.log(`准备测试房屋ID: ${houseId}`);
        });
    </script>
</body>
</html> 