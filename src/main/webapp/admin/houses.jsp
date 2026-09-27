<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房屋管理 - 房屋租赁系统</title>
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
        }
        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,.075);
        }
        .house-card {
            transition: transform 0.2s;
        }
        .house-card:hover {
            transform: translateY(-5px);
        }
        .house-image {
            height: 200px;
            object-fit: cover;
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
                <ul class="navbar-nav ms-auto">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house-door"></i> 主页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="bi bi-people"></i> 用户管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/houses">
                        <i class="bi bi-building"></i> 房屋管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/transactions">
                        <i class="bi bi-currency-dollar"></i> 交易管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                        <i class="bi bi-file-earmark-text"></i> 报表统计
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- 页面标题 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>房屋管理</h2>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addHouseModal">
                    <i class="bi bi-plus"></i> 添加房屋
                </button>
            </div>

            <!-- 搜索和筛选 -->
            <div class="card mb-4">
                <div class="card-body">
                    <form class="row g-3" method="get" action="${pageContext.request.contextPath}/admin/houses">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="keyword" placeholder="搜索房屋标题或地址" 
                                   value="${param.keyword}">
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" name="status">
                                <option value="">所有状态</option>
                                <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>可租</option>
                                <option value="RENTED" ${param.status == 'RENTED' ? 'selected' : ''}>已租</option>
                                <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>待审核</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" name="rooms">
                                <option value="">所有户型</option>
                                <option value="1" ${param.rooms == '1' ? 'selected' : ''}>一室</option>
                                <option value="2" ${param.rooms == '2' ? 'selected' : ''}>二室</option>
                                <option value="3" ${param.rooms == '3' ? 'selected' : ''}>三室</option>
                                <option value="4" ${param.rooms == '4' ? 'selected' : ''}>四室及以上</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <input type="number" class="form-control" name="minPrice" placeholder="最低价格" 
                                   value="${param.minPrice}">
                        </div>
                        <div class="col-md-2">
                            <input type="number" class="form-control" name="maxPrice" placeholder="最高价格" 
                                   value="${param.maxPrice}">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> 搜索
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/houses" class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> 重置
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 房屋列表 -->
            <div class="row">
                <c:forEach items="${houses}" var="house">
                    <div class="col-md-4 mb-4">
                        <div class="card house-card">
                            <img src="${house.images[0]}" class="card-img-top house-image" alt="${house.title}">
                            <div class="card-body">
                                <h5 class="card-title">${house.title}</h5>
                                <p class="card-text">
                                    <i class="bi bi-geo-alt"></i> ${house.address}<br>
                                    <i class="bi bi-currency-dollar"></i> ${house.rent}/月<br>
                                    <i class="bi bi-house"></i> ${house.bedrooms}室<br>
                                    <i class="bi bi-person"></i> 房主：${house.ownerId}
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-${house.status == 'AVAILABLE' ? 'success' : 
                                                           house.status == 'RENTED' ? 'warning' : 'secondary'}">
                                        ${house.status}
                                    </span>
                                    <div>
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="editHouse(${house.houseId})">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                onclick="deleteHouse(${house.houseId})">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 分页 -->
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                            上一页
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&rooms=${param.rooms}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                            下一页
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </main>

    <!-- 添加房屋模态框 -->
    <div class="modal fade" id="addHouseModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加房屋</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/house/add" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">标题</label>
                                    <input type="text" class="form-control" name="title" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">地址</label>
                                    <input type="text" class="form-control" name="address" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">面积（平方米）</label>
                                    <input type="number" class="form-control" name="area" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房间数</label>
                                    <select class="form-select" name="rooms" required>
                                        <option value="1">一室</option>
                                        <option value="2">二室</option>
                                        <option value="3">三室</option>
                                        <option value="4">四室及以上</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">价格（元/月）</label>
                                    <input type="number" class="form-control" name="price" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房主</label>
                                    <select class="form-select" name="ownerId" required>
                                        <c:forEach items="${owners}" var="owner">
                                            <option value="${owner.userId}">${owner.username}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">状态</label>
                                    <select class="form-select" name="status" required>
                                        <option value="AVAILABLE">可租</option>
                                        <option value="PENDING">待审核</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房屋图片</label>
                                    <input type="file" class="form-control" name="image" accept="image/*" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">描述</label>
                            <textarea class="form-control" name="description" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">添加</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 编辑房屋模态框 -->
    <div class="modal fade" id="editHouseModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑房屋</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editHouseForm" action="${pageContext.request.contextPath}/admin/house/edit" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="houseId" id="editHouseId">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">标题</label>
                                    <input type="text" class="form-control" name="title" id="editTitle" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">地址</label>
                                    <input type="text" class="form-control" name="address" id="editAddress" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">面积（平方米）</label>
                                    <input type="number" class="form-control" name="area" id="editArea" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房间数</label>
                                    <select class="form-select" name="rooms" id="editRooms" required>
                                        <option value="1">一室</option>
                                        <option value="2">二室</option>
                                        <option value="3">三室</option>
                                        <option value="4">四室及以上</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">价格（元/月）</label>
                                    <input type="number" class="form-control" name="price" id="editPrice" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房主</label>
                                    <select class="form-select" name="ownerId" id="editOwnerId" required>
                                        <c:forEach items="${owners}" var="owner">
                                            <option value="${owner.userId}">${owner.username}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">状态</label>
                                    <select class="form-select" name="status" id="editStatus" required>
                                        <option value="AVAILABLE">可租</option>
                                        <option value="RENTED">已租</option>
                                        <option value="PENDING">待审核</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">房屋图片</label>
                                    <input type="file" class="form-control" name="image" accept="image/*">
                                    <small class="text-muted">如果不选择新图片，将保持原图片不变</small>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">描述</label>
                            <textarea class="form-control" name="description" id="editDescription" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editHouse(houseId) {
            // 发送AJAX请求获取房屋信息
            $.get('${pageContext.request.contextPath}/admin/house/' + houseId, function(house) {
                $('#editHouseId').val(house.houseId);
                $('#editTitle').val(house.title);
                $('#editAddress').val(house.address);
                $('#editArea').val(house.area);
                $('#editRooms').val(house.rooms);
                $('#editPrice').val(house.price);
                $('#editOwnerId').val(house.owner.userId);
                $('#editStatus').val(house.status);
                $('#editDescription').val(house.description);
                $('#editHouseModal').modal('show');
            });
        }

        function deleteHouse(houseId) {
            if (confirm('确定要删除这个房屋吗？')) {
                $.post('${pageContext.request.contextPath}/admin/house/delete', {
                    houseId: houseId
                }, function(response) {
                    if (response.success) {
                        location.reload();
                    } else {
                        alert('删除失败：' + response.message);
                    }
                });
            }
        }
    </script>
</body>
</html> 