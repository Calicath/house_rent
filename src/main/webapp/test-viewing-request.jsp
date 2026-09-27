<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>看房申请测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .test-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
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
        <div class="test-card">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4">
                        <i class="bi bi-bug"></i> 看房申请功能测试
                    </h2>
                </div>
            </div>

            <!-- 用户状态检查 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-person-check"></i> 用户状态检查</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty user}">
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle"></i> 您尚未登录，请先登录后再测试看房申请功能
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">登录</a>
                                            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary btn-sm">注册</a>
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${user.type != 'TENANT'}">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle"></i> 当前用户类型：${user.type}，只有租客可以申请看房
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">注册租客账户</a>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-success">
                                        <i class="bi bi-check-circle"></i> 用户状态正常：${user.username} (租客)
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 测试表单 -->
            <c:if test="${not empty user && user.type == 'TENANT'}">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="bi bi-calendar-check"></i> 看房申请测试表单</h5>
                            </div>
                            <div class="card-body">
                                <form id="testViewingForm">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="testHouseId" class="form-label">房屋ID <span class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="testHouseId" name="houseId" 
                                                       value="1" required placeholder="请输入房屋ID">
                                                <small class="text-muted">请输入一个存在的房屋ID进行测试</small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="testViewingDate" class="form-label">看房日期 <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="testViewingDate" name="viewingDate" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="testViewingTime" class="form-label">看房时间 <span class="text-danger">*</span></label>
                                                <select class="form-select" id="testViewingTime" name="viewingTime" required>
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
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="testMessage" class="form-label">留言（选填）</label>
                                                <textarea class="form-control" id="testMessage" name="message" rows="3" 
                                                          placeholder="测试留言内容..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-send"></i> 提交测试申请
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary ms-2" onclick="resetForm()">
                                            <i class="bi bi-arrow-clockwise"></i> 重置表单
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 测试结果 -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="bi bi-list-check"></i> 测试结果</h5>
                            </div>
                            <div class="card-body">
                                <div id="testResult" class="alert" style="display: none;">
                                    <span id="resultMessage"></span>
                                </div>
                                <div id="debugInfo" class="mt-3" style="display: none;">
                                    <h6>调试信息：</h6>
                                    <pre id="debugContent" class="bg-light p-3 rounded"></pre>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 使用说明 -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="bi bi-info-circle"></i> 使用说明</h5>
                        </div>
                        <div class="card-body">
                            <ol>
                                <li><strong>登录租客账户</strong>：确保使用租客身份登录系统</li>
                                <li><strong>获取房屋ID</strong>：从房屋搜索页面或房屋详情页面获取有效的房屋ID</li>
                                <li><strong>填写表单</strong>：选择看房日期和时间，可选择性添加留言</li>
                                <li><strong>提交测试</strong>：点击"提交测试申请"按钮</li>
                                <li><strong>查看结果</strong>：在测试结果区域查看响应信息</li>
                                <li><strong>检查控制台</strong>：打开浏览器开发者工具查看详细的调试信息</li>
                            </ol>
                            <div class="alert alert-info">
                                <strong>注意：</strong>此测试页面仅用于功能验证，实际使用请通过房屋详情页面申请看房。
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 设置默认日期为明天
        document.addEventListener('DOMContentLoaded', function() {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('testViewingDate').value = tomorrow.toISOString().split('T')[0];
            
            // 设置最小日期为今天
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('testViewingDate').min = today;
        });

        // 表单提交处理
        document.getElementById('testViewingForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const form = this;
            const formData = new FormData(form);
            
            // 显示调试信息
            console.log('测试表单数据：');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            // 验证表单
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            // 显示加载状态
            const submitBtn = form.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> 提交中...';
            submitBtn.disabled = true;
            
            // 构建URLSearchParams
            const params = new URLSearchParams();
            params.append('houseId', formData.get('houseId'));
            params.append('viewingDate', formData.get('viewingDate'));
            params.append('viewingTime', formData.get('viewingTime'));
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
                
                // 显示结果
                const resultDiv = document.getElementById('testResult');
                const resultMessage = document.getElementById('resultMessage');
                const debugInfo = document.getElementById('debugInfo');
                const debugContent = document.getElementById('debugContent');
                
                if (data.success) {
                    resultDiv.className = 'alert alert-success';
                    resultMessage.innerHTML = '<i class="bi bi-check-circle"></i> ' + data.message;
                } else {
                    resultDiv.className = 'alert alert-danger';
                    resultMessage.innerHTML = '<i class="bi bi-exclamation-triangle"></i> ' + data.message;
                }
                
                resultDiv.style.display = 'block';
                
                // 显示调试信息
                debugContent.textContent = JSON.stringify(data, null, 2);
                debugInfo.style.display = 'block';
            })
            .catch(error => {
                console.error('Error:', error);
                
                const resultDiv = document.getElementById('testResult');
                const resultMessage = document.getElementById('resultMessage');
                
                resultDiv.className = 'alert alert-danger';
                resultMessage.innerHTML = '<i class="bi bi-exclamation-triangle"></i> 请求失败：' + error.message;
                resultDiv.style.display = 'block';
            })
            .finally(() => {
                // 恢复按钮状态
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });

        // 重置表单
        function resetForm() {
            document.getElementById('testViewingForm').reset();
            document.getElementById('testResult').style.display = 'none';
            document.getElementById('debugInfo').style.display = 'none';
            
            // 重新设置默认日期
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('testViewingDate').value = tomorrow.toISOString().split('T')[0];
        }
    </script>
</body>
</html> 