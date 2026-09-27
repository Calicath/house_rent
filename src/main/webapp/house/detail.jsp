<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${house.title} - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .house-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .thumbnail {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            margin: 5px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .thumbnail:hover, .thumbnail.active {
            border-color: #667eea;
            transform: scale(1.05);
        }
        .detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.5rem 0;
        }
        .info-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 1rem;
        }
        .price-tag {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            border-radius: 15px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: bold;
        }
        .status-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 10;
        }
        .owner-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 1.5rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 24px;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .feature-item {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-house-door"></i> 房屋租赁系统
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/house/search">
                            <i class="bi bi-search"></i> 浏览房屋
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty user}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person"></i> ${user.username}
                                </a>
                                <ul class="dropdown-menu">
                                    <c:if test="${user.type == 'TENANT'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tenant/dashboard">租客中心</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tenant/profile">个人信息</a></li>
                                    </c:if>
                                    <c:if test="${user.type == 'OWNER'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/owner/dashboard">房主中心</a></li>
                                    </c:if>
                                    <c:if test="${user.type == 'ADMIN'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">管理后台</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">退出登录</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">登录</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">注册</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <!-- 成功消息显示 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 错误消息显示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- 左侧内容区域 -->
            <div class="col-lg-8">
                <!-- 房屋图片 -->
                <div class="detail-card position-relative">
                    <div class="status-badge">
                        <span class="badge bg-${house.status == 'AVAILABLE' ? 'success' : 
                                             house.status == 'RENTED' ? 'danger' : 'warning'} fs-6">
                            ${house.status == 'AVAILABLE' ? '可租' : 
                              house.status == 'RENTED' ? '已租' : '待定'}
                        </span>
                    </div>
                    
                    <div class="text-center mb-3">
                        <img src="${house.images != null && not empty house.images ? house.images[0] : '/images/default-house.jpg'}" 
                             class="house-image" id="mainImage" alt="${house.title}">
                    </div>
                    
                    <c:if test="${house.images != null && not empty house.images}">
                        <div class="d-flex justify-content-center flex-wrap">
                            <c:forEach items="${house.images}" var="image" varStatus="status">
                                <img src="${image}" class="thumbnail ${status.index == 0 ? 'active' : ''}" 
                                     onclick="changeMainImage(this.src, this)" alt="房源图片 ${status.index + 1}">
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- 房屋基本信息 -->
                <div class="detail-card">
                    <h2 class="mb-3">${house.title}</h2>
                    <p class="text-muted mb-4">
                        <i class="bi bi-geo-alt"></i> ${house.address}
                    </p>
                    
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-arrows-angle-expand"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${house.size}㎡</div>
                                    <small class="text-muted">面积</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-door-open"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${house.bedrooms}室</div>
                                    <small class="text-muted">卧室</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-droplet"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${house.bathrooms}卫</div>
                                    <small class="text-muted">卫生间</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="bi bi-building"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${house.floor}</div>
                                    <small class="text-muted">楼层</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty house.description}">
                        <h5 class="mb-3"><i class="bi bi-file-text"></i> 房屋描述</h5>
                        <p class="text-muted">${house.description}</p>
                    </c:if>

                    <c:if test="${not empty house.decorate}">
                        <h5 class="mb-3"><i class="bi bi-palette"></i> 装修情况</h5>
                        <p class="text-muted">${house.decorate}</p>
                    </c:if>

                    <c:if test="${not empty house.rules}">
                        <h5 class="mb-3"><i class="bi bi-list-check"></i> 租赁规则</h5>
                        <p class="text-muted">${house.rules}</p>
                    </c:if>
                </div>
            </div>

            <!-- 右侧信息区域 -->
            <div class="col-lg-4">
                <!-- 价格信息 -->
                <div class="detail-card text-center">
                    <div class="price-tag mb-3">
                        ￥${house.rent}/月
                    </div>
                    <p class="text-muted mb-0">月租金</p>
                </div>

                <!-- 房主信息 -->
                <div class="detail-card">
                    <h5 class="mb-3"><i class="bi bi-person-badge"></i> 房主信息</h5>
                    <div class="owner-card">
                        <div class="d-flex align-items-center mb-3">
                            <div class="info-icon me-3">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">${owner.name != null ? owner.name : ownerUser.username}</h6>
                                <small class="text-muted">房主</small>
                            </div>
                        </div>
                        <c:if test="${not empty owner.phone}">
                            <div class="mb-2">
                                <i class="bi bi-telephone me-2"></i> ${owner.phone}
                            </div>
                        </c:if>
                        <c:if test="${not empty ownerUser.email}">
                            <div class="mb-0">
                                <i class="bi bi-envelope me-2"></i> ${ownerUser.email}
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- 操作按钮 -->
                <div class="detail-card">
                    <c:choose>
                        <c:when test="${empty user}">
                            <div class="alert alert-info text-center">
                                <i class="bi bi-info-circle"></i> 请先登录后再进行操作
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm me-2">登录</a>
                                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary btn-sm">注册</a>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${user.type == 'TENANT'}">
                            <c:choose>
                                <c:when test="${house.status == 'AVAILABLE'}">
                                    <button class="btn btn-primary w-100 mb-3" onclick="showViewingModal()">
                                        <i class="bi bi-calendar-check"></i> 申请看房
                                    </button>
                                    <a href="${pageContext.request.contextPath}/house/search" class="btn btn-outline-secondary w-100">
                                        <i class="bi bi-arrow-left"></i> 返回搜索
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning text-center">
                                        <i class="bi bi-exclamation-triangle"></i> 该房屋当前不可预约
                                    </div>
                                    <a href="${pageContext.request.contextPath}/house/search" class="btn btn-outline-secondary w-100">
                                        <i class="bi bi-arrow-left"></i> 返回搜索
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:when test="${user.type == 'OWNER' && user.referenceId == house.ownerId}">
                            <a href="${pageContext.request.contextPath}/owner/edit-house?id=${house.houseId}" class="btn btn-primary w-100 mb-2">
                                <i class="bi bi-pencil"></i> 编辑房屋
                            </a>
                            <button class="btn btn-danger w-100 mb-2" onclick="deleteHouse()">
                                <i class="bi bi-trash"></i> 删除房屋
                            </button>
                            <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-arrow-left"></i> 返回仪表板
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/house/search" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-arrow-left"></i> 返回搜索
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- 申请看房模态框 -->
    <div class="modal fade" id="viewingModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-check"></i> 申请看房
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="viewingForm">
                        <input type="hidden" name="houseId" value="${house.houseId}">
                        <input type="hidden" name="houseTitle" value="${house.title}">
                        
                        <div class="mb-3">
                            <label for="viewingDate" class="form-label">看房日期 <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="viewingDate" name="viewingDate" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="viewingTime" class="form-label">看房时间 <span class="text-danger">*</span></label>
                            <select class="form-select" id="viewingTime" name="viewingTime" required>
                                <option value="">请选择时间</option>
                                <option value="09:00">09:00</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="14:00">14:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                                <option value="17:00">17:00</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="message" class="form-label">留言（选填）</label>
                            <textarea class="form-control" id="message" name="message" rows="3" 
                                      placeholder="请简要说明您的看房需求或特殊要求..."></textarea>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> 
                            <strong>看房须知：</strong>
                            <ul class="mb-0 mt-2">
                                <li>请提前15分钟到达约定地点</li>
                                <li>请携带有效身份证件</li>
                                <li>房主会在24小时内回复您的申请</li>
                            </ul>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" onclick="submitViewing()">
                        <i class="bi bi-send"></i> 提交申请
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 切换主图片
        function changeMainImage(src, element) {
            document.getElementById('mainImage').src = src;
            // 更新缩略图状态
            document.querySelectorAll('.thumbnail').forEach(thumb => thumb.classList.remove('active'));
            element.classList.add('active');
        }

        // 显示申请看房模态框
        function showViewingModal() {
            // 设置默认日期为明天
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('viewingDate').value = tomorrow.toISOString().split('T')[0];
            
            const modal = new bootstrap.Modal(document.getElementById('viewingModal'));
            modal.show();
        }

        // 提交看房申请
        function submitViewing() {
            const form = document.getElementById('viewingForm');
            
            // 调试信息：打印表单数据
            console.log('表单数据：');
            const formData = new FormData(form);
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            // 验证表单
            if (!form.checkValidity()) {
                console.log('表单验证失败');
                form.reportValidity();
                return;
            }

            // 检查必填字段
            const houseId = formData.get('houseId');
            const viewingDate = formData.get('viewingDate');
            const viewingTime = formData.get('viewingTime');
            
            console.log('必填字段检查：');
            console.log('houseId:', houseId);
            console.log('viewingDate:', viewingDate);
            console.log('viewingTime:', viewingTime);
            
            if (!houseId || !viewingDate || !viewingTime) {
                alert('请填写完整的看房信息（房屋ID、日期、时间）');
                return;
            }

            // 构建URLSearchParams
            const params = new URLSearchParams();
            params.append('houseId', houseId);
            params.append('viewingDate', viewingDate);
            params.append('viewingTime', viewingTime);
            params.append('message', formData.get('message') || '');

            // 发送请求
            fetch('${pageContext.request.contextPath}/tenant/request-viewing', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => {
                console.log('响应状态:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('响应数据:', data);
                if (data.success) {
                    alert('看房申请提交成功！房主会在24小时内回复您。');
                    const modal = bootstrap.Modal.getInstance(document.getElementById('viewingModal'));
                    modal.hide();
                    // 可选：刷新页面或显示成功消息
                    location.reload();
                } else {
                    alert('申请失败：' + (data.message || '未知错误'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('提交申请时发生错误，请稍后重试');
            });
        }

        // 删除房屋（仅房主可见）
        function deleteHouse() {
            if (confirm('确定要删除这个房屋吗？此操作不可恢复！')) {
                fetch('${pageContext.request.contextPath}/owner/delete-house', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'houseId=${house.houseId}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('删除成功！');
                        window.location.href = '${pageContext.request.contextPath}/owner/dashboard';
                    } else {
                        alert('删除失败：' + (data.message || '未知错误'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('删除时发生错误');
                });
            }
        }

        // 页面加载时设置最小日期为今天
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('viewingDate').min = today;
        });
    </script>
</body>
</html> 