<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>看房申请调试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .debug-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
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
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-bug"></i> 看房申请调试
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
        <div class="debug-card">
            <h2 class="mb-4"><i class="bi bi-bug"></i> 看房申请功能调试</h2>

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
                        <c:when test="${user.type != 'TENANT'}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> 当前用户类型：${user.type}，只有租客可以申请看房
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

            <!-- 调试表单 -->
            <c:if test="${not empty user && user.type == 'TENANT'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-calendar-check"></i> 看房申请调试表单</h5>
                    </div>
                    <div class="card-body">
                        <form id="debugViewingForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="debugHouseId" class="form-label">房屋ID <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="debugHouseId" name="houseId" 
                                               value="1" required placeholder="请输入房屋ID">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="debugViewingDate" class="form-label">看房日期 <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="debugViewingDate" name="viewingDate" required>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="debugViewingTime" class="form-label">看房时间 <span class="text-danger">*</span></label>
                                        <select class="form-select" id="debugViewingTime" name="viewingTime" required>
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
                                        <label for="debugMessage" class="form-label">留言（选填）</label>
                                        <textarea class="form-control" id="debugMessage" name="message" rows="3" 
                                                  placeholder="调试留言内容..."></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send"></i> 提交调试申请
                                </button>
                                <button type="button" class="btn btn-outline-secondary ms-2" onclick="resetDebugForm()">
                                    <i class="bi bi-arrow-clockwise"></i> 重置表单
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 调试结果 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-list-check"></i> 调试结果</h5>
                    </div>
                    <div class="card-body">
                        <div id="debugResult" class="alert" style="display: none;">
                            <span id="debugResultMessage"></span>
                        </div>
                        <div id="debugDetails" class="mt-3" style="display: none;">
                            <h6>详细调试信息：</h6>
                            <div class="debug-info" id="debugContent"></div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 数据库结构检查 -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5><i class="bi bi-database"></i> 数据库结构检查</h5>
                </div>
                <div class="card-body">
                    <h6>viewing_records 表结构：</h6>
                    <div class="debug-info">
CREATE TABLE `viewing_records` (
    `record_id` INT AUTO_INCREMENT PRIMARY KEY,
    `house_id` INT NOT NULL,
    `tenant_id` INT NOT NULL,
    `viewing_time` DATETIME NOT NULL,
    `status` VARCHAR(50) DEFAULT 'PENDING',
    `message` TEXT,
    FOREIGN KEY (`house_id`) REFERENCES `houses`(`house_id`),
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`tenant_id`)
);
                    </div>
                    
                    <h6 class="mt-3">ViewingRecord 实体类字段：</h6>
                    <div class="debug-info">
- recordId (int)
- houseId (int)
- tenantId (int)
- viewingTime (LocalDateTime)
- status (String)
- message (String)
- createdAt (LocalDateTime) - 数据库中没有此字段
- updatedAt (LocalDateTime) - 数据库中没有此字段
- house (House) - 关联对象
- tenant (Tenant) - 关联对象
                    </div>
                    
                    <div class="alert alert-info mt-3">
                        <strong>注意：</strong>ViewingRecord 实体类中的 createdAt 和 updatedAt 字段在数据库表中不存在，
                        已在 DAO 中设置为默认值。
                    </div>
                </div>
            </div>

            <!-- 测试步骤 -->
            <div class="card">
                <div class="card-header">
                    <h5><i class="bi bi-list-ol"></i> 调试步骤</h5>
                </div>
                <div class="card-body">
                    <ol>
                        <li><strong>检查用户状态</strong>：确保使用租客账户登录</li>
                        <li><strong>填写表单</strong>：输入房屋ID、日期、时间</li>
                        <li><strong>提交申请</strong>：点击"提交调试申请"</li>
                        <li><strong>查看结果</strong>：检查调试结果和详细信息</li>
                        <li><strong>检查控制台</strong>：打开浏览器开发者工具查看控制台输出</li>
                        <li><strong>检查服务器日志</strong>：查看服务器控制台的调试信息</li>
                    </ol>
                    <div class="alert alert-warning">
                        <strong>调试提示：</strong>如果仍然出现"请填写完整的看房信息"错误，
                        请检查服务器控制台输出的参数信息，确认哪些字段为空。
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
            document.getElementById('debugViewingDate').value = tomorrow.toISOString().split('T')[0];
            
            // 设置最小日期为今天
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('debugViewingDate').min = today;
        });

        // 表单提交处理
        document.getElementById('debugViewingForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const form = this;
            const formData = new FormData(form);
            
            // 显示调试信息
            console.log('=== 调试表单数据 ===');
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
            
            console.log('=== 必填字段检查 ===');
            console.log('houseId:', houseId, '类型:', typeof houseId);
            console.log('viewingDate:', viewingDate, '类型:', typeof viewingDate);
            console.log('viewingTime:', viewingTime, '类型:', typeof viewingTime);
            
            if (!houseId || !viewingDate || !viewingTime) {
                alert('请填写完整的看房信息（房屋ID、日期、时间）');
                return;
            }
            
            // 显示加载状态
            const submitBtn = form.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> 提交中...';
            submitBtn.disabled = true;
            
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
                console.log('=== 响应信息 ===');
                console.log('响应状态:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('=== 响应数据 ===');
                console.log('完整响应:', data);
                
                // 显示结果
                const resultDiv = document.getElementById('debugResult');
                const resultMessage = document.getElementById('debugResultMessage');
                const debugDetails = document.getElementById('debugDetails');
                const debugContent = document.getElementById('debugContent');
                
                if (data.success) {
                    resultDiv.className = 'alert alert-success';
                    resultMessage.innerHTML = '<i class="bi bi-check-circle"></i> ' + data.message;
                } else {
                    resultDiv.className = 'alert alert-danger';
                    resultMessage.innerHTML = '<i class="bi bi-exclamation-triangle"></i> ' + data.message;
                }
                
                resultDiv.style.display = 'block';
                
                // 显示详细调试信息
                debugContent.textContent = JSON.stringify(data, null, 2);
                debugDetails.style.display = 'block';
            })
            .catch(error => {
                console.error('=== 请求错误 ===');
                console.error('Error:', error);
                
                const resultDiv = document.getElementById('debugResult');
                const resultMessage = document.getElementById('debugResultMessage');
                
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
        function resetDebugForm() {
            document.getElementById('debugViewingForm').reset();
            document.getElementById('debugResult').style.display = 'none';
            document.getElementById('debugDetails').style.display = 'none';
            
            // 重新设置默认日期
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('debugViewingDate').value = tomorrow.toISOString().split('T')[0];
        }
    </script>
</body>
</html> 