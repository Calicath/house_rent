<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>错误 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
        }
        .error-card {
            max-width: 500px;
            width: 100%;
            padding: 2rem;
            text-align: center;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        .error-title {
            font-size: 1.5rem;
            color: #212529;
            margin-bottom: 1rem;
        }
        .error-message {
            color: #6c757d;
            margin-bottom: 2rem;
        }
        .error-details {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 2rem;
            text-align: left;
            font-family: monospace;
            font-size: 0.875rem;
            color: #495057;
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <i class="bi bi-exclamation-triangle-fill error-icon"></i>
            <h1 class="error-title">出错了！</h1>
            
            <c:choose>
                <c:when test="${not empty error}">
                    <p class="error-message">${error}</p>
                </c:when>
                <c:when test="${not empty pageContext.exception}">
                    <p class="error-message">${pageContext.exception.message}</p>
                    <div class="error-details">
                        <c:forEach items="${pageContext.exception.stackTrace}" var="trace">
                            ${trace}<br>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="error-message">发生了一个未知错误，请稍后重试。</p>
                </c:otherwise>
            </c:choose>

            <div class="d-grid gap-2">
                <a href="javascript:history.back()" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left"></i> 返回上一页
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="bi bi-house"></i> 返回首页
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 