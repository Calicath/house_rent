<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房主管理 - 租房系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>房主管理</h2>
            <a href="${pageContext.request.contextPath}/admin/add-owner.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> 添加房主
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>姓名</th>
                                <th>地址</th>
                                <th>电话</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${owners}" var="owner">
                                <tr>
                                    <td>${owner.ownerId}</td>
                                    <td>${owner.name}</td>
                                    <td>${owner.address}</td>
                                    <td>${owner.phone}</td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/admin/edit-owner.jsp?id=${owner.ownerId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit"></i> 编辑
                                            </a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                    onclick="deleteOwner(${owner.ownerId})">
                                                <i class="fas fa-trash"></i> 删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteOwner(ownerId) {
            if (confirm('确定要删除这个房主吗？此操作不可恢复！')) {
                window.location.href = '${pageContext.request.contextPath}/admin/delete-owner?id=' + ownerId;
            }
        }
    </script>
</body>
</html> 