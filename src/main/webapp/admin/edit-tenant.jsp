<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑租户 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title mb-0">编辑租户</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/edit-tenant" method="post">
                            <input type="hidden" name="tenantId" value="${tenant.tenantId}">
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">姓名</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${tenant.name}" required>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">地址</label>
                                <input type="text" class="form-control" id="address" name="address" 
                                       value="${tenant.address}" required>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">电话</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${tenant.phone}" required>
                            </div>

                            <div class="mb-3">
                                <label for="idCard" class="form-label">身份证号</label>
                                <input type="text" class="form-control" id="idCard" name="idCard" 
                                       value="${tenant.idCard}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">性别</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="gender" id="male" 
                                           value="男" ${tenant.gender == '男' ? 'checked' : ''}>
                                    <label class="form-check-label" for="male">男</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="gender" id="female" 
                                           value="女" ${tenant.gender == '女' ? 'checked' : ''}>
                                    <label class="form-check-label" for="female">女</label>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <div>
                                    <a href="${pageContext.request.contextPath}/admin/tenants" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> 返回
                                    </a>
                                    <button type="button" class="btn btn-danger" onclick="deleteTenant(${tenant.tenantId})">
                                        <i class="fas fa-trash"></i> 删除
                                    </button>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> 保存
                                </button>
                            </div>
                        </form>
                    </div>
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