<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>租户管理 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>租户管理</h2>
            <a href="${pageContext.request.contextPath}/admin/add-tenant" class="btn btn-primary">
                <i class="fas fa-plus"></i> 添加租户
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>姓名</th>
                                <th>地址</th>
                                <th>电话</th>
                                <th>身份证号</th>
                                <th>性别</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tenants}" var="tenant">
                                <tr>
                                    <td>${tenant.tenantId}</td>
                                    <td>${tenant.name}</td>
                                    <td>${tenant.address}</td>
                                    <td>${tenant.phone}</td>
                                    <td>${tenant.idCard}</td>
                                    <td>${tenant.gender}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/edit-tenant?id=${tenant.tenantId}" 
                                           class="btn btn-sm btn-warning">
                                            <i class="fas fa-edit"></i> 编辑
                                        </a>
                                        <button type="button" class="btn btn-sm btn-danger" 
                                                onclick="deleteTenant(${tenant.tenantId})">
                                            <i class="fas fa-trash"></i> 删除
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 删除确认模态框 -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">确认删除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    确定要删除这个租户吗？此操作不可恢复。
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="id" id="deleteTenantId">
                        <button type="submit" class="btn btn-danger">确认删除</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteTenant(tenantId) {
            document.getElementById('deleteTenantId').value = tenantId;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/delete-tenant';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html> 