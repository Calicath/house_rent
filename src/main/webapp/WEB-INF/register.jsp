<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .register-container {
            max-width: 600px;
            margin: 50px auto;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #fff;
            border-bottom: none;
            text-align: center;
            padding: 20px;
        }
        .card-header h3 {
            margin: 0;
            color: #333;
        }
        .form-control {
            border-radius: 5px;
            padding: 10px 15px;
        }
        .btn-primary {
            border-radius: 5px;
            padding: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <div class="card">
                <div class="card-header">
                    <h3>注册账号</h3>
                </div>
                <div class="card-body">
                    <!-- 错误消息显示 -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                        <!-- 用户类型选择 -->
                        <div class="mb-3">
                            <label class="form-label">注册身份</label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="type" id="typeOwner" value="owner" required>
                                    <label class="form-check-label" for="typeOwner">房主</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="type" id="typeTenant" value="tenant" required>
                                    <label class="form-check-label" for="typeTenant">租户</label>
                                </div>
                                <div class="invalid-feedback">
                                    请选择您的注册身份
                                </div>
                            </div>
                        </div>
                        
                        <!-- 账号信息 -->
                        <div class="mb-3">
                            <label for="username" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                            <div class="invalid-feedback">
                                请输入用户名
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">密码</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                            <div class="invalid-feedback">
                                请输入密码
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">确认密码</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            <div class="invalid-feedback">
                                请再次输入密码
                            </div>
                        </div>

                        <!-- 个人信息 -->
                        <div class="mb-3">
                            <label for="name" class="form-label">姓名</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                            <div class="invalid-feedback">
                                请输入姓名
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">地址</label>
                            <input type="text" class="form-control" id="address" name="address" required>
                            <div class="invalid-feedback">
                                请输入地址
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">电话</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                            <div class="invalid-feedback">
                                请输入电话号码
                            </div>
                        </div>

                        <!-- 租户特有字段，初始隐藏 -->
                        <div id="tenantFields" style="display: none;">
                            <div class="mb-3">
                                <label for="idCard" class="form-label">身份证号</label>
                                <input type="text" class="form-control" id="idCard" name="idCard">
                                <div class="invalid-feedback">
                                    请输入身份证号
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="gender" class="form-label">性别</label>
                                <select class="form-select" id="gender" name="gender">
                                    <option value="">请选择</option>
                                    <option value="M">男</option>
                                    <option value="F">女</option>
                                </select>
                                <div class="invalid-feedback">
                                    请选择性别
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-person-plus"></i> 注册
                            </button>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> 返回登录
                            </a>
                        </div>
                    </form>
                </div>
            </div>
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
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }

                    // 验证密码是否匹配
                    var password = document.getElementById('password')
                    var confirmPassword = document.getElementById('confirmPassword')
                    if (password.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity('两次输入的密码不匹配')
                        event.preventDefault()
                        event.stopPropagation()
                    } else {
                        confirmPassword.setCustomValidity('')
                    }

                    form.classList.add('was-validated')
                }, false)
            })
        })()

        // 动态显示/隐藏租户特有字段
        document.addEventListener('DOMContentLoaded', function() {
            var typeOwner = document.getElementById('typeOwner');
            var typeTenant = document.getElementById('typeTenant');
            var tenantFields = document.getElementById('tenantFields');
            var idCardInput = document.getElementById('idCard');
            var genderSelect = document.getElementById('gender');

            function toggleTenantFields() {
                if (typeTenant.checked) {
                    tenantFields.style.display = 'block';
                    idCardInput.setAttribute('required', 'required');
                    genderSelect.setAttribute('required', 'required');
                } else {
                    tenantFields.style.display = 'none';
                    idCardInput.removeAttribute('required');
                    genderSelect.removeAttribute('required');
                    // 清空字段值，避免提交无效数据
                    idCardInput.value = '';
                    genderSelect.value = '';
                }
            }

            typeOwner.addEventListener('change', toggleTenantFields);
            typeTenant.addEventListener('change', toggleTenantFields);

            // 页面加载时根据初始状态设置一次
            toggleTenantFields();
        });
    </script>
</body>
</html> 