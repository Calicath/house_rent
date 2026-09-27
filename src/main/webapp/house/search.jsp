<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房屋搜索 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .search-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .house-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        .house-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .house-image {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        .house-info {
            padding: 1.5rem;
        }
        .price {
            color: #dc3545;
            font-size: 1.25rem;
            font-weight: bold;
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .filter-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2rem;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
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
        <!-- 搜索过滤器 -->
        <div class="search-container">
            <h4 class="mb-3"><i class="bi bi-funnel"></i> 搜索条件</h4>
            <form action="${pageContext.request.contextPath}/house/search" method="get" id="searchForm">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="keyword" class="form-label">关键词</label>
                        <input type="text" class="form-control" id="keyword" name="keyword" 
                               value="${param.keyword}" placeholder="房屋标题、地址、描述">
                    </div>
                    <div class="col-md-2">
                        <label for="status" class="form-label">状态</label>
                        <select class="form-select" id="status" name="status">
                            <option value="">全部状态</option>
                            <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>可租</option>
                            <option value="RENTED" ${param.status == 'RENTED' ? 'selected' : ''}>已租</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>待定</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="rooms" class="form-label">卧室数</label>
                        <select class="form-select" id="rooms" name="rooms">
                            <option value="">不限</option>
                            <option value="1" ${param.rooms == '1' ? 'selected' : ''}>1室</option>
                            <option value="2" ${param.rooms == '2' ? 'selected' : ''}>2室</option>
                            <option value="3" ${param.rooms == '3' ? 'selected' : ''}>3室</option>
                            <option value="4" ${param.rooms == '4' ? 'selected' : ''}>4室+</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="minPrice" class="form-label">最低价格</label>
                        <input type="number" class="form-control" id="minPrice" name="minPrice" 
                               value="${param.minPrice}" placeholder="元/月">
                    </div>
                    <div class="col-md-2">
                        <label for="maxPrice" class="form-label">最高价格</label>
                        <input type="number" class="form-control" id="maxPrice" name="maxPrice" 
                               value="${param.maxPrice}" placeholder="元/月">
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> 搜索
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                            <i class="bi bi-arrow-clockwise"></i> 重置
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- 搜索结果 -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4><i class="bi bi-house"></i> 搜索结果</h4>
                    <span class="text-muted">共找到 ${totalHouses} 套房屋</span>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty houses}">
                <div class="row g-4">
                    <c:forEach items="${houses}" var="house">
                        <div class="col-lg-4 col-md-6">
                            <div class="house-card position-relative">
                                <div class="house-image">
                                    <i class="bi bi-house"></i>
                                </div>
                                <div class="status-badge">
                                    <span class="badge bg-${house.status == 'AVAILABLE' ? 'success' : 
                                                         house.status == 'RENTED' ? 'danger' : 'warning'}">
                                        ${house.status == 'AVAILABLE' ? '可租' : 
                                          house.status == 'RENTED' ? '已租' : '待定'}
                                    </span>
                                </div>
                                <div class="house-info">
                                    <h5 class="card-title">${house.title}</h5>
                                    <p class="card-text text-muted mb-2">
                                        <i class="bi bi-geo-alt"></i> ${house.address}
                                    </p>
                                    <div class="row mb-2">
                                        <div class="col-6">
                                            <small class="text-muted">
                                                <i class="bi bi-door-open"></i> ${house.bedrooms}室
                                            </small>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted">
                                                <i class="bi bi-droplet"></i> ${house.bathrooms}卫
                                            </small>
                                        </div>
                                    </div>
                                    <div class="row mb-2">
                                        <div class="col-6">
                                            <small class="text-muted">
                                                <i class="bi bi-arrows-angle-expand"></i> ${house.size}㎡
                                            </small>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted">
                                                <i class="bi bi-building"></i> ${house.floor}层
                                            </small>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="price">￥${house.rent}/月</div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/house/detail?id=${house.houseId}" 
                                               class="btn btn-outline-primary btn-sm">
                                                查看详情
                                            </a>
                                            <c:if test="${not empty user && user.type == 'TENANT' && house.status == 'AVAILABLE'}">
                                                <a href="${pageContext.request.contextPath}/tenant/request-viewing?houseId=${house.houseId}" 
                                                   class="btn btn-primary btn-sm">
                                                    申请看房
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 分页 -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <nav aria-label="房屋搜索结果分页">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            上一页
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                            下一页
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="bi bi-search"></i>
                    <h5>暂无符合条件的房屋</h5>
                    <p>请尝试调整搜索条件或稍后再试</p>
                    <button class="btn btn-primary" onclick="resetForm()">
                        <i class="bi bi-arrow-clockwise"></i> 重置搜索条件
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function resetForm() {
            document.getElementById('searchForm').reset();
            document.getElementById('searchForm').submit();
        }
        
        // 价格验证
        document.getElementById('minPrice').addEventListener('blur', function() {
            const minPrice = parseInt(this.value);
            const maxPrice = parseInt(document.getElementById('maxPrice').value);
            
            if (minPrice && maxPrice && minPrice > maxPrice) {
                alert('最低价格不能大于最高价格！');
                this.value = '';
            }
        });
        
        document.getElementById('maxPrice').addEventListener('blur', function() {
            const maxPrice = parseInt(this.value);
            const minPrice = parseInt(document.getElementById('minPrice').value);
            
            if (maxPrice && minPrice && maxPrice < minPrice) {
                alert('最高价格不能小于最低价格！');
                this.value = '';
            }
        });
    </script>
</body>
</html> 