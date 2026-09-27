<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>看房申请系统测试 - 房屋租赁系统</title>
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
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .debug-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 1rem;
            margin: 1rem 0;
            font-family: monospace;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-bug"></i> 看房申请系统测试
            </a>
            <div class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty user}">
                        <span class="navbar-text text-white">
                            <i class="bi bi-person"></i> ${user.username} (${user.type})
                        </span>
                    </c:when>
                    <c:otherwise>
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">登录</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="test-card">
            <h2 class="mb-4"><i class="bi bi-bug"></i> 看房申请系统完整测试</h2>

            <!-- 用户状态检查 -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5><i class="bi bi-person-check"></i> 用户状态检查</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty user}">
                            <div class="alert alert-warning">
                                <i class="bi bi-exclamation-triangle"></i> 您尚未登录
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">登录</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle"></i> 用户状态正常：${user.username} (${user.type})
                                <div class="mt-2">
                                    <strong>用户ID:</strong> ${user.userId} | 
                                    <strong>Reference ID:</strong> ${user.referenceId}
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 租客测试区域 -->
            <c:if test="${not empty user && user.type == 'TENANT'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-person"></i> 租客测试区域</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>提交看房申请</h6>
                                <form id="tenantTestForm">
                                    <div class="mb-3">
                                        <label for="testHouseId" class="form-label">房屋ID</label>
                                        <input type="number" class="form-control" id="testHouseId" name="houseId" value="1">
                                    </div>
                                    <div class="mb-3">
                                        <label for="testViewingDate" class="form-label">看房日期</label>
                                        <input type="date" class="form-control" id="testViewingDate" name="viewingDate">
                                    </div>
                                    <div class="mb-3">
                                        <label for="testViewingTime" class="form-label">看房时间</label>
                                        <select class="form-select" id="testViewingTime" name="viewingTime">
                                            <option value="14:00">14:00</option>
                                            <option value="15:00">15:00</option>
                                            <option value="16:00">16:00</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="testMessage" class="form-label">留言</label>
                                        <textarea class="form-control" id="testMessage" name="message" rows="2">测试看房申请</textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary">提交申请</button>
                                </form>
                            </div>
                            <div class="col-md-6">
                                <h6>查看我的申请</h6>
                                <a href="${pageContext.request.contextPath}/tenant/dashboard" class="btn btn-outline-primary">
                                    <i class="bi bi-list"></i> 查看申请记录
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 房主测试区域 -->
            <c:if test="${not empty user && user.type == 'OWNER'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-house"></i> 房主测试区域</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>查看看房申请</h6>
                                <a href="${pageContext.request.contextPath}/owner/viewing-requests" class="btn btn-primary">
                                    <i class="bi bi-calendar-check"></i> 查看申请列表
                                </a>
                            </div>
                            <div class="col-md-6">
                                <h6>我的房屋</h6>
                                <a href="${pageContext.request.contextPath}/owner/houses" class="btn btn-outline-primary">
                                    <i class="bi bi-building"></i> 管理房屋
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 系统状态检查 -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5><i class="bi bi-gear"></i> 系统状态检查</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/house/search" class="btn btn-outline-info w-100 mb-2">
                                <i class="bi bi-search"></i> 房屋搜索
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/house/detail?id=1" class="btn btn-outline-info w-100 mb-2">
                                <i class="bi bi-house"></i> 房屋详情
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/debug-viewing-request.jsp" class="btn btn-outline-warning w-100 mb-2">
                                <i class="bi bi-bug"></i> 调试页面
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/test-viewing-request.jsp" class="btn btn-outline-secondary w-100 mb-2">
                <i class="bi bi-test-tube"></i> 测试页面
            </a>
        </div>
    </div>
</div>
            </div>

            <!-- 测试结果 -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5><i class="bi bi-list-check"></i> 测试结果</h5>
                </div>
                <div class="card-body">
                    <div id="testResult" class="alert" style="display: none;">
                        <span id="testResultMessage"></span>
                    </div>
                    <div id="testDetails" class="mt-3" style="display: none;">
                        <h6>详细测试信息：</h6>
                        <div class="debug-info" id="testContent"></div>
                    </div>
                </div>
            </div>

            <!-- 测试步骤 -->
            <div class="card">
                <div class="card-header">
                    <h5><i class="bi bi-list-ol"></i> 完整测试步骤</h5>
                </div>
                <div class="card-body">
                    <ol>
                        <li><strong>登录租客账户</strong>：使用租客身份登录系统</li>
                        <li><strong>提交看房申请</strong>：在租客测试区域填写表单并提交</li>
                        <li><strong>验证申请提交</strong>：检查测试结果区域显示成功信息</li>
                        <li><strong>切换账户</strong>：退出登录，使用房主账户登录</li>
                        <li><strong>查看申请</strong>：在房主测试区域点击"查看申请列表"</li>
                        <li><strong>验证显示</strong>：确认房主能看到租客提交的申请</li>
                        <li><strong>处理申请</strong>：房主可以同意或拒绝申请</li>
                    </ol>
                    <div class="alert alert-info">
                        <strong>注意：</strong>确保数据库中有房屋数据，且房主和租客的关联关系正确。
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

        // 租客表单提交处理
        document.getElementById('tenantTestForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const form = this;
            const formData = new FormData(form);
            
            // 显示调试信息
            console.log('=== 租客测试表单数据 ===');
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
                console.log('=== 响应信息 ===');
                console.log('响应状态:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('=== 响应数据 ===');
                console.log('完整响应:', data);
                
                // 显示结果
                const resultDiv = document.getElementById('testResult');
                const resultMessage = document.getElementById('testResultMessage');
                const testDetails = document.getElementById('testDetails');
                const testContent = document.getElementById('testContent');
                
                if (data.success) {
                    resultDiv.className = 'alert alert-success';
                    resultMessage.innerHTML = '<i class="bi bi-check-circle"></i> 看房申请提交成功！现在请切换到房主账户查看申请。';
                } else {
                    resultDiv.className = 'alert alert-danger';
                    resultMessage.innerHTML = '<i class="bi bi-exclamation-triangle"></i> 申请失败：' + data.message;
                }
                
                resultDiv.style.display = 'block';
                
                // 显示详细测试信息
                testContent.textContent = JSON.stringify(data, null, 2);
                testDetails.style.display = 'block';
            })
            .catch(error => {
                console.error('=== 请求错误 ===');
                console.error('Error:', error);
                
                const resultDiv = document.getElementById('testResult');
                const resultMessage = document.getElementById('testResultMessage');
                
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
    </script>
</body>
</html> 