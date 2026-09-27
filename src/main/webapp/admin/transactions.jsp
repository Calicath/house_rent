<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>交易管理 - 房屋租赁系统</title>
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
        .main-content {
            margin-left: 240px;
            padding: 20px;
        }
        .transaction-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .transaction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">房屋租赁系统</a>
            <div class="d-flex">
                <span class="navbar-text me-3">
                    欢迎，${sessionScope.user.username}
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="sidebar-sticky">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="bi bi-speedometer2"></i> 控制台
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                                <i class="bi bi-people"></i> 用户管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/houses">
                                <i class="bi bi-house"></i> 房屋管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/transactions">
                                <i class="bi bi-cash-stack"></i> 交易管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                <i class="bi bi-graph-up"></i> 报表统计
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主要内容 -->
            <main class="main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">交易管理</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTransactionModal">
                            <i class="bi bi-plus"></i> 添加交易
                        </button>
                    </div>
                </div>

                <!-- 搜索和筛选 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/transactions" method="get" class="row g-3">
                            <div class="col-md-3">
                                <input type="text" class="form-control" name="keyword" placeholder="搜索合同号/房屋/租客" value="${param.keyword}">
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="status">
                                    <option value="">所有状态</option>
                                    <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>进行中</option>
                                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>已完成</option>
                                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>已取消</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="paymentStatus">
                                    <option value="">所有支付状态</option>
                                    <option value="PAID" ${param.paymentStatus == 'PAID' ? 'selected' : ''}>已支付</option>
                                    <option value="UNPAID" ${param.paymentStatus == 'UNPAID' ? 'selected' : ''}>未支付</option>
                                    <option value="PARTIAL" ${param.paymentStatus == 'PARTIAL' ? 'selected' : ''}>部分支付</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <input type="date" class="form-control" name="startDate" value="${param.startDate}">
                                    <span class="input-group-text">至</span>
                                    <input type="date" class="form-control" name="endDate" value="${param.endDate}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">搜索</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 交易列表 -->
                <div class="row">
                    <c:forEach items="${transactions}" var="transaction">
                        <div class="col-md-6 col-lg-4">
                            <div class="card transaction-card">
                                <div class="card-body">
                                    <span class="badge ${transaction.status == 'ACTIVE' ? 'bg-success' : transaction.status == 'COMPLETED' ? 'bg-primary' : 'bg-danger'} status-badge">
                                        ${transaction.status == 'ACTIVE' ? '进行中' : transaction.status == 'COMPLETED' ? '已完成' : '已取消'}
                                    </span>
                                    <h5 class="card-title">${transaction.contractNumber}</h5>
                                    <p class="card-text">
                                        <strong>房屋：</strong>${transaction.house.title}<br>
                                        <strong>租客：</strong>${transaction.tenant.username}<br>
                                        <strong>房东：</strong>${transaction.owner.username}<br>
                                        <strong>租期：</strong>${transaction.startDate} 至 ${transaction.endDate}<br>
                                        <strong>租金：</strong>￥${transaction.rentAmount}/月<br>
                                        <strong>押金：</strong>￥${transaction.depositAmount}<br>
                                        <strong>支付状态：</strong>
                                        <span class="badge ${transaction.paymentStatus == 'PAID' ? 'bg-success' : transaction.paymentStatus == 'PARTIAL' ? 'bg-warning' : 'bg-danger'}">
                                            ${transaction.paymentStatus == 'PAID' ? '已支付' : transaction.paymentStatus == 'PARTIAL' ? '部分支付' : '未支付'}
                                        </span>
                                    </p>
                                    <div class="btn-group w-100">
                                        <button type="button" class="btn btn-outline-primary" onclick="editTransaction(${transaction.id})">
                                            <i class="bi bi-pencil"></i> 编辑
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" onclick="deleteTransaction(${transaction.id})">
                                            <i class="bi bi-trash"></i> 删除
                                        </button>
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
                            <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&paymentStatus=${param.paymentStatus}&startDate=${param.startDate}&endDate=${param.endDate}">上一页</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&keyword=${param.keyword}&status=${param.status}&paymentStatus=${param.paymentStatus}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&paymentStatus=${param.paymentStatus}&startDate=${param.startDate}&endDate=${param.endDate}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </main>
        </div>
    </div>

    <!-- 添加交易模态框 -->
    <div class="modal fade" id="addTransactionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加交易</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addTransactionForm" action="${pageContext.request.contextPath}/admin/transaction/add" method="post">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">房屋</label>
                                <select class="form-select" name="houseId" required>
                                    <option value="">选择房屋</option>
                                    <c:forEach items="${houses}" var="house">
                                        <option value="${house.id}">${house.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">租客</label>
                                <select class="form-select" name="tenantId" required>
                                    <option value="">选择租客</option>
                                    <c:forEach items="${tenants}" var="tenant">
                                        <option value="${tenant.id}">${tenant.username}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">开始日期</label>
                                <input type="date" class="form-control" name="startDate" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">结束日期</label>
                                <input type="date" class="form-control" name="endDate" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">月租金</label>
                                <input type="number" class="form-control" name="rentAmount" step="0.01" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">押金</label>
                                <input type="number" class="form-control" name="depositAmount" step="0.01" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">状态</label>
                                <select class="form-select" name="status" required>
                                    <option value="ACTIVE">进行中</option>
                                    <option value="COMPLETED">已完成</option>
                                    <option value="CANCELLED">已取消</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">支付状态</label>
                                <select class="form-select" name="paymentStatus" required>
                                    <option value="UNPAID">未支付</option>
                                    <option value="PARTIAL">部分支付</option>
                                    <option value="PAID">已支付</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注</label>
                            <textarea class="form-control" name="notes" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" form="addTransactionForm" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 编辑交易模态框 -->
    <div class="modal fade" id="editTransactionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑交易</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editTransactionForm" action="${pageContext.request.contextPath}/admin/transaction/edit" method="post">
                        <input type="hidden" name="transactionId" id="editTransactionId">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">房屋</label>
                                <select class="form-select" name="houseId" id="editHouseId" required>
                                    <option value="">选择房屋</option>
                                    <c:forEach items="${houses}" var="house">
                                        <option value="${house.id}">${house.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">租客</label>
                                <select class="form-select" name="tenantId" id="editTenantId" required>
                                    <option value="">选择租客</option>
                                    <c:forEach items="${tenants}" var="tenant">
                                        <option value="${tenant.id}">${tenant.username}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">开始日期</label>
                                <input type="date" class="form-control" name="startDate" id="editStartDate" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">结束日期</label>
                                <input type="date" class="form-control" name="endDate" id="editEndDate" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">月租金</label>
                                <input type="number" class="form-control" name="rentAmount" id="editRentAmount" step="0.01" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">押金</label>
                                <input type="number" class="form-control" name="depositAmount" id="editDepositAmount" step="0.01" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">状态</label>
                                <select class="form-select" name="status" id="editStatus" required>
                                    <option value="ACTIVE">进行中</option>
                                    <option value="COMPLETED">已完成</option>
                                    <option value="CANCELLED">已取消</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">支付状态</label>
                                <select class="form-select" name="paymentStatus" id="editPaymentStatus" required>
                                    <option value="UNPAID">未支付</option>
                                    <option value="PARTIAL">部分支付</option>
                                    <option value="PAID">已支付</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注</label>
                            <textarea class="form-control" name="notes" id="editNotes" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" form="editTransactionForm" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editTransaction(id) {
            fetch('${pageContext.request.contextPath}/admin/transaction/edit?id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editTransactionId').value = data.id;
                    document.getElementById('editHouseId').value = data.houseId;
                    document.getElementById('editTenantId').value = data.tenantId;
                    document.getElementById('editStartDate').value = data.startDate;
                    document.getElementById('editEndDate').value = data.endDate;
                    document.getElementById('editRentAmount').value = data.rentAmount;
                    document.getElementById('editDepositAmount').value = data.depositAmount;
                    document.getElementById('editStatus').value = data.status;
                    document.getElementById('editPaymentStatus').value = data.paymentStatus;
                    document.getElementById('editNotes').value = data.notes;
                    
                    new bootstrap.Modal(document.getElementById('editTransactionModal')).show();
                })
                .catch(error => {
                    alert('获取交易信息失败：' + error);
                });
        }

        function deleteTransaction(id) {
            if (confirm('确定要删除这笔交易吗？')) {
                fetch('${pageContext.request.contextPath}/admin/transaction/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + id
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('删除失败：' + data.error);
                    }
                })
                .catch(error => {
                    alert('删除失败：' + error);
                });
            }
        }
    </script>
</body>
</html> 