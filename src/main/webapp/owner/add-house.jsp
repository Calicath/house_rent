<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
// 设置请求和响应的字符编码
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加房屋 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .preview-image {
            max-width: 300px;
            max-height: 200px;
            object-fit: cover;
            display: none;
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
                    <h1 class="h2">添加房屋</h1>
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

                <!-- 添加房屋表单 -->
                <div class="row">
                    <div class="col-md-8">
                        <form action="${pageContext.request.contextPath}/owner/add-house" method="post" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="title" class="form-label">房屋标题</label>
                                    <input type="text" class="form-control" id="title" name="title" required value="${param.title != null ? param.title : (not empty title ? title : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入房屋标题
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="address" class="form-label">地址</label>
                                    <input type="text" class="form-control" id="address" name="address" required value="${param.address != null ? param.address : (not empty address ? address : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入房屋地址
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="area" class="form-label">面积(㎡)</label>
                                    <input type="number" class="form-control" id="area" name="area" step="0.01" min="0" required value="${param.area != null ? param.area : (not empty area ? area : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入有效的面积
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="price" class="form-label">月租金(元)</label>
                                    <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required value="${param.price != null ? param.price : (not empty price ? price : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入有效的租金
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="type" class="form-label">房屋类型</label>
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
                                    <label for="floor" class="form-label">楼层</label>
                                    <input type="text" class="form-control" id="floor" name="floor" value="${param.floor != null ? param.floor : (not empty floor ? floor : '')}" autocomplete="off">
                                    <div class="form-text">例如：3楼、顶层等</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="bedrooms" class="form-label">卧室数量</label>
                                    <input type="number" class="form-control" id="bedrooms" name="bedrooms" min="0" required value="${param.bedrooms != null ? param.bedrooms : (not empty bedrooms ? bedrooms : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入有效的卧室数量
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="bathrooms" class="form-label">卫生间数量</label>
                                    <input type="number" class="form-control" id="bathrooms" name="bathrooms" min="0" required value="${param.bathrooms != null ? param.bathrooms : (not empty bathrooms ? bathrooms : '')}" autocomplete="off">
                                    <div class="invalid-feedback">
                                        请输入有效的卫生间数量
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="decorate" class="form-label">装修情况</label>
                                    <select class="form-select" id="decorate" name="decorate">
                                        <option value="">请选择装修情况</option>
                                        <option value="精装修" ${param.decorate == '精装修' ? 'selected' : (not empty decorate && decorate == '精装修' ? 'selected' : '')}>精装修</option>
                                        <option value="简装修" ${param.decorate == '简装修' ? 'selected' : (not empty decorate && decorate == '简装修' ? 'selected' : '')}>简装修</option>
                                        <option value="毛坯" ${param.decorate == '毛坯' ? 'selected' : (not empty decorate && decorate == '毛坯' ? 'selected' : '')}>毛坯</option>
                                        <option value="其他" ${param.decorate == '其他' ? 'selected' : (not empty decorate && decorate == '其他' ? 'selected' : '')}>其他</option>
                                    </select>
                                </div>

                                <div class="col-md-12">
                                    <label for="description" class="form-label">房屋描述</label>
                                    <textarea class="form-control" id="description" name="description" rows="4" required autocomplete="off">${param.description != null ? param.description : (not empty description ? description : '')}</textarea>
                                    <div class="invalid-feedback">
                                        请输入房屋描述
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="rules" class="form-label">租赁规则</label>
                                    <textarea class="form-control" id="rules" name="rules" rows="3" autocomplete="off">${param.rules != null ? param.rules : (not empty rules ? rules : '')}</textarea>
                                    <div class="form-text">可选的租赁规则和注意事项</div>
                                </div>

                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> 保存
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

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
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