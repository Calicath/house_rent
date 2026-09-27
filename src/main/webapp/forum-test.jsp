<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>论坛功能测试</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 2rem 0;
        }
        .test-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
            padding: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="text-center mb-4">
                    <h1><i class="bi bi-chat-dots"></i> 论坛功能测试</h1>
                    <p class="text-muted">测试论坛的各项功能是否正常工作</p>
                </div>

                <!-- 用户状态检查 -->
                <div class="test-card">
                    <h5><i class="bi bi-person-check"></i> 用户状态检查</h5>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="alert alert-success">
                                <strong>已登录用户：</strong> ${sessionScope.user.username}<br>
                                <strong>用户类型：</strong> ${sessionScope.user.type}<br>
                                <strong>用户ID：</strong> ${sessionScope.user.userId}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">
                                <strong>未登录</strong> - 请先登录才能使用论坛功能
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 论坛功能测试 -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="test-card">
                        <h5><i class="bi bi-gear"></i> 论坛功能测试</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/forum" class="btn btn-primary">
                                        <i class="bi bi-house"></i> 访问论坛主页
                                    </a>
                                    <a href="${pageContext.request.contextPath}/forum/create-post" class="btn btn-success">
                                        <i class="bi bi-plus-circle"></i> 发布新帖子
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/forum?category=GENERAL" class="btn btn-info">
                                        <i class="bi bi-tags"></i> 综合讨论分类
                                    </a>
                                    <a href="${pageContext.request.contextPath}/forum?category=RENTAL_TIPS" class="btn btn-warning">
                                        <i class="bi bi-lightbulb"></i> 租赁技巧分类
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- JSTL函数测试 -->
                    <div class="test-card">
                        <h5><i class="bi bi-code"></i> JSTL函数测试</h5>
                        <c:set var="testString" value="这是一个测试字符串，用来验证JSTL函数是否正常工作" />
                        <p><strong>原始字符串：</strong> ${testString}</p>
                        <p><strong>字符串长度：</strong> ${fn:length(testString)}</p>
                        <p><strong>截取前10个字符：</strong> ${fn:substring(testString, 0, 10)}</p>
                        <p><strong>转换为大写：</strong> ${fn:toUpperCase(testString)}</p>
                        <p><strong>是否包含"测试"：</strong> ${fn:contains(testString, '测试')}</p>
                    </div>
                </c:if>

                <!-- 错误信息显示 -->
                <c:if test="${not empty error}">
                    <div class="test-card">
                        <h5><i class="bi bi-exclamation-triangle"></i> 错误信息</h5>
                        <div class="alert alert-danger">
                            ${error}
                        </div>
                    </div>
                </c:if>

                <!-- 返回链接 -->
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> 返回首页
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 