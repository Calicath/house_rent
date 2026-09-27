<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑房屋 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .preview-image {
            max-width: 300px;
            max-height: 200px;
            object-fit: cover;
            margin-top: 10px;
        }
        .current-image {
            max-width: 300px;
            max-height: 200px;
            object-fit: cover;
            margin-top: 10px;
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
                    <h1 class="h2">编辑房屋</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> 返回列表
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

                <!-- 编辑房屋表单 -->
                <div class="row">
                    <div class="col-md-8">
                        <form action="${pageContext.request.contextPath}/owner/edit-house" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                            <input type="hidden" name="houseId" value="${house.houseId}">
                            
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="title" class="form-label">房屋标题</label>
                                    <input type="text" class="form-control" id="title" name="title" value="${house.title}" required>
                                    <div class="invalid-feedback">
                                        请输入房屋标题
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="address" class="form-label">地址</label>
                                    <input type="text" class="form-control" id="address" name="address" value="${house.address}" required>
                                    <div class="invalid-feedback">
                                        请输入房屋地址
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="area" class="form-label">面积(㎡)</label>
                                    <input type="number" class="form-control" id="area" name="area" step="0.01" min="0" value="${house.area}" required>
                                    <div class="invalid-feedback">
                                        请输入有效的面积
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="price" class="form-label">月租金(元)</label>
                                    <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" value="${house.price}" required>
                                    <div class="invalid-feedback">
                                        请输入有效的租金
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="rooms" class="form-label">房间数</label>
                                    <input type="number" class="form-control" id="rooms" name="rooms" min="1" value="${house.rooms}" required>
                                    <div class="invalid-feedback">
                                        请输入有效的房间数
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="status" class="form-label">状态</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="可租" ${house.status == '可租' ? 'selected' : ''}>可租</option>
                                        <option value="已租" ${house.status == '已租' ? 'selected' : ''}>已租</option>
                                        <option value="维护中" ${house.status == '维护中' ? 'selected' : ''}>维护中</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        请选择房屋状态
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="description" class="form-label">房屋描述</label>
                                    <textarea class="form-control" id="description" name="description" rows="4" required>${house.description}</textarea>
                                    <div class="invalid-feedback">
                                        请输入房屋描述
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="image" class="form-label">房屋图片</label>
                                    <c:if test="${not empty house.imageUrl}">
                                        <div class="mb-2">
                                            <p class="mb-1">当前图片：</p>
                                            <img src="${pageContext.request.contextPath}/${house.imageUrl}" 
                                                 class="current-image" alt="当前房屋图片">
                                        </div>
                                    </c:if>
                                    <input type="file" class="form-control" id="image" name="image" accept="image/*" onchange="previewImage(this)">
                                    <img id="preview" class="preview-image" alt="预览图片" style="display: none;">
                                    <div class="form-text">支持jpg、png、gif格式，最大10MB。如果不选择新图片，将保持原有图片。</div>
                                </div>

                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> 保存修改
                                    </button>
                                    <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-secondary">
                                        <i class="bi bi-x"></i> 取消
                                    </a>
                                    <button type="button" class="btn btn-danger" onclick="confirmDelete(${house.houseId})">
                                        <i class="bi bi-trash"></i> 删除房屋
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
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
                    <form action="${pageContext.request.contextPath}/owner/delete-house" method="post">
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
        // 表单验证
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()

        // 图片预览
        function previewImage(input) {
            var preview = document.getElementById('preview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }

        // 删除确认
        function confirmDelete(houseId) {
            document.getElementById('deleteHouseId').value = houseId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html> 