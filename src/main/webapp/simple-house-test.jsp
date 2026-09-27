<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房屋添加测试 - 简化版</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>房屋添加测试 - 简化版</h1>
        <p class="text-muted">现在使用和用户注册相同的简单逻辑</p>
        
        <!-- 错误消息显示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 成功消息显示 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 简化版房屋添加表单 -->
        <div class="card">
            <div class="card-header">
                <h5>房屋添加表单（简化版）</h5>
                <small class="text-muted">使用与用户注册相同的逻辑，无文件上传</small>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/owner/add-house" method="post" class="needs-validation" novalidate>
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label for="title" class="form-label">房屋标题 *</label>
                            <input type="text" class="form-control" id="title" name="title" required value="测试房屋标题">
                            <div class="invalid-feedback">
                                请输入房屋标题
                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="address" class="form-label">地址 *</label>
                            <input type="text" class="form-control" id="address" name="address" required value="测试地址">
                            <div class="invalid-feedback">
                                请输入房屋地址
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="area" class="form-label">面积(㎡) *</label>
                            <input type="number" class="form-control" id="area" name="area" step="0.01" min="0" required value="100">
                            <div class="invalid-feedback">
                                请输入有效的面积
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="price" class="form-label">月租金(元) *</label>
                            <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required value="3000">
                            <div class="invalid-feedback">
                                请输入有效的租金
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="type" class="form-label">房屋类型 *</label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">请选择房屋类型</option>
                                <option value="1" selected>公寓</option>
                                <option value="2">别墅</option>
                                <option value="3">平房</option>
                                <option value="4">其他</option>
                            </select>
                            <div class="invalid-feedback">
                                请选择房屋类型
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="bedrooms" class="form-label">卧室数量 *</label>
                            <input type="number" class="form-control" id="bedrooms" name="bedrooms" min="0" required value="2">
                            <div class="invalid-feedback">
                                请输入有效的卧室数量
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="bathrooms" class="form-label">卫生间数量 *</label>
                            <input type="number" class="form-control" id="bathrooms" name="bathrooms" min="0" required value="1">
                            <div class="invalid-feedback">
                                请输入有效的卫生间数量
                            </div>
                        </div>

                        <div class="col-md-12">
                            <label for="description" class="form-label">房屋描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3">这是一个测试房屋描述</textarea>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save"></i> 添加房屋
                            </button>
                            <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> 返回房屋列表
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- 说明 -->
        <div class="alert alert-info mt-4">
            <h6>修改说明：</h6>
            <ul>
                <li><strong>移除了文件上传功能</strong>：不再使用 `enctype="multipart/form-data"`</li>
                <li><strong>简化了参数获取</strong>：直接使用 `request.getParameter()` 获取所有字段</li>
                <li><strong>移除了复杂的 multipart 处理</strong>：现在和用户注册使用相同的简单逻辑</li>
                <li><strong>表单已预填测试数据</strong>：可以直接提交测试</li>
            </ul>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            console.log('表单提交事件触发');
            console.log('表单action:', this.action);
            console.log('表单method:', this.method);
            console.log('表单enctype:', this.enctype);
            
            const titleInput = document.getElementById('title');
            const addressInput = document.getElementById('address');
            const areaInput = document.getElementById('area');
            const priceInput = document.getElementById('price');
            const typeInput = document.getElementById('type');
            const bedroomsInput = document.getElementById('bedrooms');
            const bathroomsInput = document.getElementById('bathrooms');
            
            console.log('title值:', titleInput ? titleInput.value : 'N/A');
            console.log('address值:', addressInput ? addressInput.value : 'N/A');
            console.log('area值:', areaInput ? areaInput.value : 'N/A');
            console.log('price值:', priceInput ? priceInput.value : 'N/A');
            console.log('type值:', typeInput ? typeInput.value : 'N/A');
            console.log('bedrooms值:', bedroomsInput ? bedroomsInput.value : 'N/A');
            console.log('bathrooms值:', bathroomsInput ? bathroomsInput.value : 'N/A');
            
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            this.classList.add('was-validated');
        });
    </script>
</body>
</html> 