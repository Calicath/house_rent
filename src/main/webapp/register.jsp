<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 500px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
        .user-type-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .user-type-option {
            flex: 1;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .user-type-option:hover {
            border-color: #667eea;
            background-color: #f8f9ff;
        }
        .user-type-option.selected {
            border-color: #667eea;
            background-color: #667eea;
            color: white;
        }
        .user-type-option i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }
        .tenant-fields {
            display: none;
        }
        .tenant-fields.show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="text-center mb-4">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-house-door"></i> 房屋租赁系统
            </h2>
            <p class="text-muted">创建您的账户</p>
        </div>

        <!-- 错误消息显示 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 成功消息显示 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <!-- 用户类型选择 -->
            <div class="mb-3">
                <label class="form-label fw-bold">选择用户类型</label>
                <div class="user-type-selector">
                    <div class="user-type-option" data-type="OWNER">
                        <i class="bi bi-person-badge"></i>
                        <div>房主</div>
                        <small class="text-muted">出租房屋</small>
                    </div>
                    <div class="user-type-option" data-type="TENANT">
                        <i class="bi bi-person"></i>
                        <div>租客</div>
                        <small class="text-muted">租住房屋</small>
                    </div>
                </div>
                <input type="hidden" name="userType" id="userType" value="OWNER" required>
            </div>

            <!-- 基本信息 -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">邮箱</label>
                    <input type="email" class="form-control" id="email" name="email">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">手机号码 <span class="text-danger">*</span></label>
                    <input type="tel" class="form-control" id="phone" name="phone" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="idCard" class="form-label">身份证号 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="idCard" name="idCard" required>
                </div>
            </div>

            <!-- 租客特有字段 -->
            <div class="tenant-fields" id="tenantFields">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="gender" class="form-label">性别 <span class="text-danger">*</span></label>
                        <select class="form-select" id="gender" name="gender">
                            <option value="">请选择性别</option>
                            <option value="M">男</option>
                            <option value="F">女</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="emergencyContact" class="form-label">紧急联系人</label>
                        <input type="text" class="form-control" id="emergencyContact" name="emergencyContact">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="emergencyPhone" class="form-label">紧急联系电话</label>
                        <input type="tel" class="form-control" id="emergencyPhone" name="emergencyPhone">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="occupation" class="form-label">职业</label>
                        <input type="text" class="form-control" id="occupation" name="occupation">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="employer" class="form-label">工作单位</label>
                        <input type="text" class="form-control" id="employer" name="employer">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="income" class="form-label">月收入</label>
                        <input type="text" class="form-control" id="income" name="income" placeholder="例如：8000">
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-person-plus"></i> 注册账户
                </button>
            </div>
        </form>

        <div class="text-center mt-3">
            <p class="text-muted">已有账户？ <a href="${pageContext.request.contextPath}/login" class="text-primary">立即登录</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 用户类型选择
        document.querySelectorAll('.user-type-option').forEach(option => {
            option.addEventListener('click', function() {
                // 移除所有选中状态
                document.querySelectorAll('.user-type-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                
                // 添加选中状态
                this.classList.add('selected');
                
                // 更新隐藏字段
                const userType = this.dataset.type;
                document.getElementById('userType').value = userType;
                
                // 显示/隐藏租客字段
                const tenantFields = document.getElementById('tenantFields');
                if (userType === 'TENANT') {
                    tenantFields.classList.add('show');
                    // 设置租客字段为必填
                    document.getElementById('gender').required = true;
                } else {
                    tenantFields.classList.remove('show');
                    // 移除租客字段的必填属性
                    document.getElementById('gender').required = false;
                }
            });
        });

        // 表单验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const userType = document.getElementById('userType').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('密码和确认密码不匹配！');
                return;
            }
            
            if (userType === 'TENANT') {
                const gender = document.getElementById('gender').value;
                if (!gender) {
                    e.preventDefault();
                    alert('请选择性别！');
                    return;
                }
            }
        });

        // 身份证号验证
        document.getElementById('idCard').addEventListener('blur', function() {
            const idCard = this.value;
            const idCardPattern = /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
            
            if (idCard && !idCardPattern.test(idCard)) {
                this.setCustomValidity('请输入正确的身份证号');
            } else {
                this.setCustomValidity('');
            }
        });

        // 默认选中房主
        document.querySelector('[data-type="OWNER"]').click();
    </script>
</body>
</html> 