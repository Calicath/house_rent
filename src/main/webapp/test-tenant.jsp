<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>租客功能测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .test-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .feature-list {
            list-style: none;
            padding: 0;
        }
        .feature-list li {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .feature-list li:last-child {
            border-bottom: none;
        }
        .feature-list i {
            margin-right: 10px;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="test-card">
                    <div class="text-center mb-4">
                        <h2><i class="bi bi-person"></i> 租客功能测试</h2>
                        <p class="text-muted">测试租客相关的功能模块</p>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <h5><i class="bi bi-check-circle"></i> 已完成功能</h5>
                            <ul class="feature-list">
                                <li><i class="bi bi-person-plus"></i> 租客注册</li>
                                <li><i class="bi bi-person-badge"></i> 个人信息管理</li>
                                <li><i class="bi bi-house"></i> 房屋搜索浏览</li>
                                <li><i class="bi bi-eye"></i> 看房申请</li>
                                <li><i class="bi bi-building"></i> 租赁管理</li>
                                <li><i class="bi bi-currency-dollar"></i> 支付记录</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="bi bi-gear"></i> 测试链接</h5>
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                                    <i class="bi bi-person-plus"></i> 注册租客账户
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary">
                                    <i class="bi bi-box-arrow-in-right"></i> 登录系统
                                </a>
                                <a href="${pageContext.request.contextPath}/house/search" class="btn btn-outline-success">
                                    <i class="bi bi-search"></i> 浏览房屋
                                </a>
                                <c:if test="${not empty user && user.type == 'TENANT'}">
                                    <a href="${pageContext.request.contextPath}/tenant/dashboard" class="btn btn-outline-info">
                                        <i class="bi bi-speedometer2"></i> 租客仪表板
                                    </a>
                                    <a href="${pageContext.request.contextPath}/tenant/profile" class="btn btn-outline-warning">
                                        <i class="bi bi-person"></i> 个人信息
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="row">
                        <div class="col-12">
                            <h5><i class="bi bi-info-circle"></i> 测试说明</h5>
                            <div class="alert alert-info">
                                <ol>
                                    <li><strong>注册测试：</strong>点击"注册租客账户"，选择租客类型，填写必要信息</li>
                                    <li><strong>登录测试：</strong>使用注册的账户登录系统</li>
                                    <li><strong>房屋浏览：</strong>查看可用的房屋列表，测试搜索功能</li>
                                    <li><strong>个人信息：</strong>更新租客的个人资料和租赁信息</li>
                                    <li><strong>看房申请：</strong>对感兴趣的房屋申请看房</li>
                                </ol>
                            </div>
                        </div>
                    </div>

                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> 返回首页
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 