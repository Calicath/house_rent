<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>表单测试</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>表单测试</h1>
        
        <!-- 测试表单1: 普通表单 -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>测试表单1: 普通表单（无文件上传）</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/owner/add-house" method="post">
                    <div class="mb-3">
                        <label for="title1" class="form-label">房屋标题 *</label>
                        <input type="text" class="form-control" id="title1" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="address1" class="form-label">地址 *</label>
                        <input type="text" class="form-control" id="address1" name="address" required>
                    </div>
                    <div class="mb-3">
                        <label for="area1" class="form-label">面积 *</label>
                        <input type="number" class="form-control" id="area1" name="area" required>
                    </div>
                    <div class="mb-3">
                        <label for="price1" class="form-label">租金 *</label>
                        <input type="number" class="form-control" id="price1" name="price" required>
                    </div>
                    <div class="mb-3">
                        <label for="type1" class="form-label">类型 *</label>
                        <select class="form-select" id="type1" name="type" required>
                            <option value="">请选择</option>
                            <option value="1">公寓</option>
                            <option value="2">别墅</option>
                            <option value="3">平房</option>
                            <option value="4">其他</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="bedrooms1" class="form-label">卧室 *</label>
                        <input type="number" class="form-control" id="bedrooms1" name="bedrooms" required>
                    </div>
                    <div class="mb-3">
                        <label for="bathrooms1" class="form-label">卫生间 *</label>
                        <input type="number" class="form-control" id="bathrooms1" name="bathrooms" required>
                    </div>
                    <button type="submit" class="btn btn-primary">提交测试表单1</button>
                </form>
            </div>
        </div>

        <!-- 测试表单2: 带文件上传的表单 -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>测试表单2: 带文件上传的表单</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/owner/add-house" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label for="title2" class="form-label">房屋标题 *</label>
                        <input type="text" class="form-control" id="title2" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="address2" class="form-label">地址 *</label>
                        <input type="text" class="form-control" id="address2" name="address" required>
                    </div>
                    <div class="mb-3">
                        <label for="area2" class="form-label">面积 *</label>
                        <input type="number" class="form-control" id="area2" name="area" required>
                    </div>
                    <div class="mb-3">
                        <label for="price2" class="form-label">租金 *</label>
                        <input type="number" class="form-control" id="price2" name="price" required>
                    </div>
                    <div class="mb-3">
                        <label for="type2" class="form-label">类型 *</label>
                        <select class="form-select" id="type2" name="type" required>
                            <option value="">请选择</option>
                            <option value="1">公寓</option>
                            <option value="2">别墅</option>
                            <option value="3">平房</option>
                            <option value="4">其他</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="bedrooms2" class="form-label">卧室 *</label>
                        <input type="number" class="form-control" id="bedrooms2" name="bedrooms" required>
                    </div>
                    <div class="mb-3">
                        <label for="bathrooms2" class="form-label">卫生间 *</label>
                        <input type="number" class="form-control" id="bathrooms2" name="bathrooms" required>
                    </div>
                    <div class="mb-3">
                        <label for="image2" class="form-label">图片（可选）</label>
                        <input type="file" class="form-control" id="image2" name="image" accept="image/*">
                    </div>
                    <button type="submit" class="btn btn-success">提交测试表单2</button>
                </form>
            </div>
        </div>

        <script>
            // 表单提交调试
            document.querySelectorAll('form').forEach(function(form, index) {
                form.addEventListener('submit', function(e) {
                    console.log('表单' + (index + 1) + '提交事件触发');
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
                });
            });
        </script>
    </div>
</body>
</html> 