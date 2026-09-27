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
        .house-image {
            width: 200px;
            height: 150px;
            object-fit: cover;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 0.4em 0.8em;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/owner/dashboard">
                                <i class="bi bi-house-door"></i> 首页
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/owner/houses">
                                <i class="bi bi-building"></i> 房屋管理
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 主要内容区域 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">房屋管理</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/owner/add-house" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i> 添加房屋
                        </a>
                    </div>
                </div>

                <!-- 错误消息显示 -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- 房屋列表 -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>图片</th>
                                <th>标题</th>
                                <th>地址</th>
                                <th>面积(㎡)</th>
                                <th>价格(元/月)</th>
                                <th>房间数</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${houses}" var="house">
                                <tr>
                                    <td>
                                        <c:if test="${not empty house.images and not empty house.images[0]}">
                                            <img src="${pageContext.request.contextPath}/${house.images[0]}" 
                                                 class="house-image" alt="${house.title}">
                                        </c:if>
                                        <c:if test="${empty house.images or empty house.images[0]}">
                                            <img src="${pageContext.request.contextPath}/images/no-image.jpg" 
                                                 class="house-image" alt="无图片">
                                        </c:if>
                                    </td>
                                    <td>${house.title}</td>
                                    <td>${house.address}</td>
                                    <td>${house.size}</td>
                                    <td>${house.rent}</td>
                                    <td>${house.bedrooms}室${house.bathrooms}卫</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/owner/update-house-status" method="post" style="display:inline-flex;align-items:center;">
                                            <input type="hidden" name="houseId" value="${house.houseId}" />
                                            <select name="status" class="form-select form-select-sm me-2" style="width:auto;">
                                                <option value="RENTED" ${house.status == 'RENTED' ? 'selected' : ''}>已出租</option>
                                                <option value="PENDING" ${house.status == 'PENDING' ? 'selected' : ''}>待审核</option>
                                                <option value="AVAILABLE" ${house.status == 'AVAILABLE' ? 'selected' : ''}>下架</option>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-outline-success me-2">变更</button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/tenant/create-payment?houseId=${house.houseId}" class="btn btn-sm btn-outline-warning ms-2">申请支付</a>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="${pageContext.request.contextPath}/owner/edit-house?id=${house.houseId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i> 编辑
                                            </a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                    onclick="confirmDelete(${house.houseId})">
                                                <i class="bi bi-trash"></i> 删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>

    <!-- 删除确认模态框 -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">确认删除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    确定要删除这个房屋吗？此操作不可恢复。
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/owner/delete-house" method="post">
                        <input type="hidden" name="id" id="deleteHouseId">
                        <button type="submit" class="btn btn-danger">确认删除</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(houseId) {
            document.getElementById('deleteHouseId').value = houseId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html> 