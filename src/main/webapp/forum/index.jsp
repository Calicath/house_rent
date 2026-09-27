<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房屋租赁论坛</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .forum-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .forum-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        .post-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .post-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        
        .post-card.pinned {
            border-left: 4px solid #ffc107;
            background: linear-gradient(135deg, #fff9c4 0%, #ffffff 100%);
        }
        
        .post-card.highlighted {
            border-left: 4px solid #dc3545;
        }
        
        .post-title {
            color: #2c3e50;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .post-title:hover {
            color: #3498db;
        }
        
        .post-meta {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .post-stats {
            display: flex;
            gap: 1rem;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .category-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        
        .search-box {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .category-filter {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .btn-create-post {
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-house-heart"></i> 房屋租赁系统
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/forum">
                            <i class="bi bi-chat-dots"></i> 论坛
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/house/search">
                            <i class="bi bi-search"></i> 找房
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" 
                                   data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-person-circle"></i> ${sessionScope.user.username}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person"></i> 个人信息
                                    </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right"></i> 退出登录
                                    </a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="bi bi-box-arrow-in-right"></i> 登录
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                    <i class="bi bi-person-plus"></i> 注册
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- 左侧分类列表 -->
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">帖子分类</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/forum" class="list-group-item list-group-item-action ${empty param.category ? 'active' : ''}">
                            全部帖子
                        </a>
                        <a href="${pageContext.request.contextPath}/forum?category=问题" class="list-group-item list-group-item-action ${param.category == '问题' ? 'active' : ''}">
                            问题咨询
                        </a>
                        <a href="${pageContext.request.contextPath}/forum?category=建议" class="list-group-item list-group-item-action ${param.category == '建议' ? 'active' : ''}">
                            建议反馈
                        </a>
                        <a href="${pageContext.request.contextPath}/forum?category=经验分享" class="list-group-item list-group-item-action ${param.category == '经验分享' ? 'active' : ''}">
                            经验分享
                        </a>
                    </div>
                </div>
            </div>

            <!-- 右侧帖子列表 -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>${empty param.category ? '全部帖子' : param.category}</h2>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/forum/create-post.jsp" class="btn btn-primary">
                            <i class="fas fa-plus"></i> 发布新帖
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:forEach items="${posts}" var="post">
                    <div class="card mb-3 post-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <h5 class="card-title mb-1">
                                    <a href="${pageContext.request.contextPath}/forum/post/${post.postId}" class="text-decoration-none text-dark">
                                        ${post.title}
                                    </a>
                                </h5>
                                <span class="badge bg-primary category-badge">${post.categoryDisplayName}</span>
                            </div>
                            <p class="card-text text-muted small mb-2">
                                ${fn:substring(post.content, 0, 150)}${fn:length(post.content) > 150 ? '...' : ''}
                            </p>
                            <div class="d-flex justify-content-between align-items-center post-stats">
                                <div>
                                    <i class="bi bi-person"></i> ${post.user != null ? post.user.username : '未知用户'}
                                    <i class="bi bi-clock ms-3"></i> ${post.createdAt}
                                </div>
                                <div>
                                    <i class="bi bi-eye"></i> ${post.viewCount}
                                    <i class="bi bi-hand-thumbs-up ms-3"></i> ${post.likeCount}
                                    <i class="bi bi-chat-dots ms-3"></i> ${post.replyCount}
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty posts}">
                    <div class="text-center text-muted my-5">
                        <i class="fas fa-inbox fa-3x mb-3"></i>
                        <p>暂无帖子</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 