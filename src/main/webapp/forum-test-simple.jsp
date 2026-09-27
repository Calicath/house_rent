<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>论坛测试页面</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>论坛测试页面</h2>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5>帖子列表测试</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty posts}">
                            <p>找到 ${fn:length(posts)} 个帖子</p>
                            <c:forEach items="${posts}" var="post" varStatus="status">
                                <div class="border-bottom pb-2 mb-2">
                                    <h6>帖子 ${status.index + 1}:</h6>
                                    <p><strong>ID:</strong> ${post.postId}</p>
                                    <p><strong>标题:</strong> ${post.title}</p>
                                    <p><strong>分类:</strong> ${post.category}</p>
                                    <p><strong>用户:</strong> ${post.user != null ? post.user.username : '未知用户'}</p>
                                    <p><strong>创建时间:</strong> ${post.createdAt}</p>
                                    <hr>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <c:if test="${empty posts}">
                            <p class="text-muted">暂无帖子数据</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5>测试链接</h5>
                    </div>
                    <div class="card-body">
                        <a href="${pageContext.request.contextPath}/forum" class="btn btn-primary">访问论坛主页</a>
                        <a href="${pageContext.request.contextPath}/forum/create-post.jsp" class="btn btn-success">发布新帖</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 