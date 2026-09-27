<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加房屋 - 简化版</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">添加房屋 - 简化版</h1>
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

                <!-- 调试信息 -->
                <div class="alert alert-info">
                    <h6>调试信息:</h6>
                    <p>当前用户: ${user.username} (${user.type})</p>
                    <p>Session ID: ${pageContext.session.id}</p>
                    <p>请求方法: ${pageContext.request.method}</p>
                    <p>Content-Type: ${pageContext.request.contentType}</p>
                </div>

        <!-- 简化版表单（无文件上传） -->
        <div class="card">
            <div class="card-header">
                <h5>简化版表单测试</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/owner/add-house" method="post" class="needs-validation" novalidate>
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label for="title" class="form-label">房屋标题 *</label>
                            <input type="text" class="form-control" id="title" name="title" required value="${param.title != null ? param.title : (not empty title ? title : '')}">
                            <div class="invalid-feedback">
                                请输入房屋标题
                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="address" class="form-label">地址 *</label>
                            <input type="text" class="form-control" id="address" name="address" required value="${param.address != null ? param.address : (not empty address ? address : '')}">
                            <div class="invalid-feedback">
                                请输入房屋地址
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="area" class="form-label">面积(㎡) *</label>
                            <input type="number" class="form-control" id="area" name="area" step="0.01" min="0" required value="${param.area != null ? param.area : (not empty area ? area : '')}">
                            <div class="invalid-feedback">
                                请输入有效的面积
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="price" class="form-label">月租金(元) *</label>
                            <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required value="${param.price != null ? param.price : (not empty price ? price : '')}">
                            <div class="invalid-feedback">
                                请输入有效的租金
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="type" class="form-label">房屋类型 *</label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">请选择房屋类型</option>
                                <option value="1" ${param.type == '1' ? 'selected' : (not empty type && type == 1 ? 'selected' : '')}>公寓</option>
                                <option value="2" ${param.type == '2' ? 'selected' : (not empty type && type == 2 ? 'selected' : '')}>别墅</option>
                                <option value="3" ${param.type == '3' ? 'selected' : (not empty type && type == 3 ? 'selected' : '')}>平房</option>
                                <option value="4" ${param.type == '4' ? 'selected' : (not empty type && type == 4 ? 'selected' : '')}>其他</option>
                            </select>
                            <div class="invalid-feedback">
                                请选择房屋类型
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="bedrooms" class="form-label">卧室数量 *</label>
                            <input type="number" class="form-control" id="bedrooms" name="bedrooms" min="0" required value="${param.bedrooms != null ? param.bedrooms : (not empty bedrooms ? bedrooms : '')}">
                            <div class="invalid-feedback">
                                请输入有效的卧室数量
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="bathrooms" class="form-label">卫生间数量 *</label>
                            <input type="number" class="form-control" id="bathrooms" name="bathrooms" min="0" required value="${param.bathrooms != null ? param.bathrooms : (not empty bathrooms ? bathrooms : '')}">
                            <div class="invalid-feedback">
                                请输入有效的卫生间数量
                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="description" class="form-label">房屋描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${param.description != null ? param.description : (not empty description ? description : '')}</textarea>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save"></i> 保存房屋
                            </button>
                            <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-secondary">
                                <i class="bi bi-x"></i> 取消
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    // 调试信息
                    console.log('表单提交事件触发');
                    console.log('title值:', document.getElementById('title').value);
                    console.log('address值:', document.getElementById('address').value);
                    console.log('area值:', document.getElementById('area').value);
                    console.log('price值:', document.getElementById('price').value);
                    console.log('type值:', document.getElementById('type').value);
                    console.log('bedrooms值:', document.getElementById('bedrooms').value);
                    console.log('bathrooms值:', document.getElementById('bathrooms').value);
                    
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html> 