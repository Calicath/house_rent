<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑房主 - 租房系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">编辑房主</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/update-owner" method="post">
                            <input type="hidden" name="ownerId" value="${owner.ownerId}">
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">姓名</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${owner.name}" required>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">地址</label>
                                <input type="text" class="form-control" id="address" name="address" 
                                       value="${owner.address}" required>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">电话</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${owner.phone}" required>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/admin/owners" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> 返回
                                </a>
                                <div>
                                    <button type="button" class="btn btn-danger me-2" 
                                            onclick="deleteOwner(${owner.ownerId})">
                                        <i class="fas fa-trash"></i> 删除
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> 保存修改
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
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