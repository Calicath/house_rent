<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑帖子 - 房屋租赁论坛</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
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
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="bi bi-pencil-square"></i> 编辑帖子
                        </h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle"></i> ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/forum/update-post" method="post">
                            <input type="hidden" name="postId" value="${post.postId}">
                            
                            <div class="mb-3">
                                <label for="title" class="form-label">
                                    <i class="bi bi-type-bold"></i> 标题
                                </label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="${post.title}" required>
                            </div>

                            <div class="mb-3">
                                <label for="category" class="form-label">
                                    <i class="bi bi-tags"></i> 分类
                                </label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="">请选择分类</option>
                                    <option value="GENERAL" ${post.category == 'GENERAL' ? 'selected' : ''}>综合讨论</option>
                                    <option value="RENTAL_TIPS" ${post.category == 'RENTAL_TIPS' ? 'selected' : ''}>租赁技巧</option>
                                    <option value="COMPLAINT" ${post.category == 'COMPLAINT' ? 'selected' : ''}>投诉建议</option>
                                    <option value="QUESTION" ${post.category == 'QUESTION' ? 'selected' : ''}>问题咨询</option>
                                    <option value="EXPERIENCE" ${post.category == 'EXPERIENCE' ? 'selected' : ''}>经验分享</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="content" class="form-label">
                                    <i class="bi bi-chat-text"></i> 内容
                                </label>
                                <textarea class="form-control" id="content" name="content" rows="10" required>${post.content}</textarea>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/forum/post/${post.postId}" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> 返回
                                </a>
                                <div>
                                    <button type="button" class="btn btn-danger me-2" 
                                            onclick="deletePost(${post.postId})">
                                        <i class="bi bi-trash"></i> 删除
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle"></i> 保存修改
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#content').summernote({
                height: 300,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ],
                placeholder: '请输入帖子内容...',
                callbacks: {
                    onImageUpload: function(files) {
                        // 这里可以添加图片上传功能
                    }
                }
            });
        });

        function deletePost(postId) {
            if (confirm('确定要删除这个帖子吗？此操作不可恢复！')) {
                window.location.href = '${pageContext.request.contextPath}/forum/delete-post?postId=' + postId;
            }
        }
    </script>
</body>
</html> 