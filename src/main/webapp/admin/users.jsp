<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 房屋租赁系统</title>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
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
                <h2>用户管理</h2>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="bi bi-plus"></i> 添加用户
                </button>
            </div>

            <!-- 搜索和筛选 -->
            <div class="card mb-4">
                <div class="card-body">
                    <form class="row g-3" method="get" action="${pageContext.request.contextPath}/admin/users">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="keyword" placeholder="搜索用户名或邮箱" 
                                   value="${param.keyword}">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="type">
                                <option value="">所有类型</option>
                                <option value="ADMIN" ${param.type == 'ADMIN' ? 'selected' : ''}>管理员</option>
                                <option value="OWNER" ${param.type == 'OWNER' ? 'selected' : ''}>房主</option>
                                <option value="TENANT" ${param.type == 'TENANT' ? 'selected' : ''}>租户</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="">所有状态</option>
                                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>活跃</option>
                                <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>未激活</option>
                                <option value="SUSPENDED" ${param.status == 'SUSPENDED' ? 'selected' : ''}>已暂停</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> 搜索
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 用户列表 -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>用户名</th>
                                    <th>邮箱</th>
                                    <th>类型</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="user">
                                    <tr>
                                        <td>${user.userId}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="badge bg-${user.type == 'ADMIN' ? 'danger' : user.type == 'OWNER' ? 'primary' : 'success'}">${user.type}</span>
                                        </td>
                                        <td>
                                            <span class="badge bg-${user.status == 'ACTIVE' ? 'success' : user.status == 'INACTIVE' ? 'warning' : 'danger'}">${user.status}</span>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="editUser(${user.userId})">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteUser(${user.userId})">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页 -->
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&type=${param.type}&status=${param.status}">
                                    上一页
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&keyword=${param.keyword}&type=${param.type}&status=${param.status}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&type=${param.type}&status=${param.status}">
                                    下一页
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </main>

    <!-- 添加用户模态框 -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加用户</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/user/add" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-control" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">邮箱</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">密码</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">用户类型</label>
                            <select class="form-select" name="type" required>
                                <option value="OWNER">房主</option>
                                <option value="TENANT">租户</option>
                            </select>
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

    <!-- 编辑用户模态框 -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑用户</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editUserForm" action="${pageContext.request.contextPath}/admin/user/edit" method="post">
                    <input type="hidden" name="userId" id="editUserId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-control" name="username" id="editUsername" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">邮箱</label>
                            <input type="email" class="form-control" name="email" id="editEmail" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">用户类型</label>
                            <select class="form-select" name="type" id="editType" required>
                                <option value="OWNER">房主</option>
                                <option value="TENANT">租户</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status" id="editStatus" required>
                                <option value="ACTIVE">活跃</option>
                                <option value="INACTIVE">未激活</option>
                                <option value="SUSPENDED">已暂停</option>
                            </select>
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
        function editUser(userId) {
            // 发送AJAX请求获取用户信息
            $.get('${pageContext.request.contextPath}/admin/user/' + userId, function(user) {
                $('#editUserId').val(user.userId);
                $('#editUsername').val(user.username);
                $('#editEmail').val(user.email);
                $('#editType').val(user.type);
                $('#editStatus').val(user.status);
                $('#editUserModal').modal('show');
            });
        }

        function deleteUser(userId) {
            if (confirm('确定要删除这个用户吗？')) {
                $.post('${pageContext.request.contextPath}/admin/user/delete', {
                    userId: userId
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