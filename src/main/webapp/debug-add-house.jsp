<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调试添加房屋表单</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            margin-top: 10px;
            display: none;
        }
        .debug-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">调试添加房屋表单</h1>
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
                <div class="debug-info">
                    <h6>调试信息:</h6>
                    <p>当前用户: ${user.username} (${user.type})</p>
                    <p>Session ID: ${pageContext.session.id}</p>
                    <p>请求方法: ${pageContext.request.method}</p>
                    <p>Content-Type: ${pageContext.request.contentType}</p>
                    <p>Character Encoding: ${pageContext.request.characterEncoding}</p>
                    
                    <!-- 显示所有请求参数 -->
                    <h6>请求参数:</h6>
                    <c:forEach var="param" items="${param}">
                        <p><strong>${param.key}:</strong> [${param.value}] (length: ${param.value.length()})</p>
                    </c:forEach>
                </div>

                <!-- 测试表单1: 普通表单（无文件上传） -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5>测试表单1: 普通表单（无文件上传）</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/owner/add-house" method="post" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="title1" class="form-label">房屋标题 *</label>
                                    <input type="text" class="form-control" id="title1" name="title" required value="${param.title != null ? param.title : (not empty title ? title : '')}">
                                    <div class="invalid-feedback">
                                        请输入房屋标题
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="address1" class="form-label">地址 *</label>
                                    <input type="text" class="form-control" id="address1" name="address" required value="${param.address != null ? param.address : (not empty address ? address : '')}">
                                    <div class="invalid-feedback">
                                        请输入房屋地址
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="area1" class="form-label">面积(㎡) *</label>
                                    <input type="number" class="form-control" id="area1" name="area" step="0.01" min="0" required value="${param.area != null ? param.area : (not empty area ? area : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的面积
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="price1" class="form-label">月租金(元) *</label>
                                    <input type="number" class="form-control" id="price1" name="price" step="0.01" min="0" required value="${param.price != null ? param.price : (not empty price ? price : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的租金
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="type1" class="form-label">房屋类型 *</label>
                                    <select class="form-select" id="type1" name="type" required>
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
                                    <label for="bedrooms1" class="form-label">卧室数量 *</label>
                                    <input type="number" class="form-control" id="bedrooms1" name="bedrooms" min="0" required value="${param.bedrooms != null ? param.bedrooms : (not empty bedrooms ? bedrooms : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的卧室数量
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="bathrooms1" class="form-label">卫生间数量 *</label>
                                    <input type="number" class="form-control" id="bathrooms1" name="bathrooms" min="0" required value="${param.bathrooms != null ? param.bathrooms : (not empty bathrooms ? bathrooms : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的卫生间数量
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="description1" class="form-label">房屋描述</label>
                                    <textarea class="form-control" id="description1" name="description" rows="3">${param.description != null ? param.description : (not empty description ? description : '')}</textarea>
                                </div>

                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> 提交测试表单1
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 测试表单2: 带文件上传的表单 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5>测试表单2: 带文件上传的表单</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/owner/add-house" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="title2" class="form-label">房屋标题 *</label>
                                    <input type="text" class="form-control" id="title2" name="title" required value="${param.title != null ? param.title : (not empty title ? title : '')}">
                                    <div class="invalid-feedback">
                                        请输入房屋标题
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="address2" class="form-label">地址 *</label>
                                    <input type="text" class="form-control" id="address2" name="address" required value="${param.address != null ? param.address : (not empty address ? address : '')}">
                                    <div class="invalid-feedback">
                                        请输入房屋地址
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="area2" class="form-label">面积(㎡) *</label>
                                    <input type="number" class="form-control" id="area2" name="area" step="0.01" min="0" required value="${param.area != null ? param.area : (not empty area ? area : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的面积
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="price2" class="form-label">月租金(元) *</label>
                                    <input type="number" class="form-control" id="price2" name="price" step="0.01" min="0" required value="${param.price != null ? param.price : (not empty price ? price : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的租金
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="type2" class="form-label">房屋类型 *</label>
                                    <select class="form-select" id="type2" name="type" required>
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
                                    <label for="bedrooms2" class="form-label">卧室数量 *</label>
                                    <input type="number" class="form-control" id="bedrooms2" name="bedrooms" min="0" required value="${param.bedrooms != null ? param.bedrooms : (not empty bedrooms ? bedrooms : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的卧室数量
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="bathrooms2" class="form-label">卫生间数量 *</label>
                                    <input type="number" class="form-control" id="bathrooms2" name="bathrooms" min="0" required value="${param.bathrooms != null ? param.bathrooms : (not empty bathrooms ? bathrooms : '')}">
                                    <div class="invalid-feedback">
                                        请输入有效的卫生间数量
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="description2" class="form-label">房屋描述</label>
                                    <textarea class="form-control" id="description2" name="description" rows="3">${param.description != null ? param.description : (not empty description ? description : '')}</textarea>
                                </div>

                                <div class="col-md-12">
                                    <label for="image2" class="form-label">房屋图片（可选）</label>
                                    <input type="file" class="form-control" id="image2" name="image" accept="image/jpeg,image/png,image/gif">
                                    <div class="form-text">支持jpg、png、gif格式，最大10MB</div>
                                </div>

                                <div class="col-12">
                                    <button type="submit" class="btn btn-success">
                                        <i class="bi bi-save"></i> 提交测试表单2
                                    </button>
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
        document.querySelectorAll('form').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                // 调试信息
                console.log('表单提交事件触发');
                console.log('表单action:', form.action);
                console.log('表单method:', form.method);
                console.log('表单enctype:', form.enctype);
                
                const titleInput = form.querySelector('input[name="title"]');
                const addressInput = form.querySelector('input[name="address"]');
                const areaInput = form.querySelector('input[name="area"]');
                const priceInput = form.querySelector('input[name="price"]');
                const typeInput = form.querySelector('select[name="type"]');
                const bedroomsInput = form.querySelector('input[name="bedrooms"]');
                const bathroomsInput = form.querySelector('input[name="bathrooms"]');
                
                console.log('title值:', titleInput ? titleInput.value : 'N/A');
                console.log('address值:', addressInput ? addressInput.value : 'N/A');
                console.log('area值:', areaInput ? areaInput.value : 'N/A');
                console.log('price值:', priceInput ? priceInput.value : 'N/A');
                console.log('type值:', typeInput ? typeInput.value : 'N/A');
                console.log('bedrooms值:', bedroomsInput ? bedroomsInput.value : 'N/A');
                console.log('bathrooms值:', bathroomsInput ? bathroomsInput.value : 'N/A');
                
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                form.classList.add('was-validated');
            });
        });
    </script>
</body>
</html> 