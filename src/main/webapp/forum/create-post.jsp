<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布帖子 - 房屋租赁论坛</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .create-post-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 15px;
        }
        
        .create-post-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px 15px 0 0;
            margin-bottom: 0;
        }
        
        .create-post-form {
            background: white;
            padding: 2rem;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-cancel {
            background: #6c757d;
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .category-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .character-count {
            font-size: 0.8rem;
            color: #6c757d;
            text-align: right;
            margin-top: 0.25rem;
        }
        
        .character-count.warning {
            color: #ffc107;
        }
        
        .character-count.danger {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="create-post-container">
        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="create-post-header">
            <h2 class="mb-0">
                <i class="bi bi-plus-circle"></i> 发布新帖子
            </h2>
            <p class="mb-0 mt-2">分享你的经验、提问或讨论</p>
        </div>

        <div class="create-post-form">
            <form method="POST" action="${pageContext.request.contextPath}/forum/create-post">
                <!-- 标题 -->
                <div class="mb-3">
                    <label for="title" class="form-label">
                        <i class="bi bi-type-bold"></i> 帖子标题
                    </label>
                    <input type="text" class="form-control" id="title" name="title" 
                           placeholder="请输入帖子标题..." 
                           value="${title}" 
                           maxlength="100" 
                           required>
                    <div class="character-count" id="titleCount">0/100</div>
                </div>

                <!-- 分类 -->
                <div class="mb-3">
                    <label for="category" class="form-label">
                        <i class="bi bi-tags"></i> 帖子分类
                    </label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="">请选择分类</option>
                        <option value="GENERAL" ${category == 'GENERAL' ? 'selected' : ''}>综合讨论</option>
                        <option value="RENTAL_TIPS" ${category == 'RENTAL_TIPS' ? 'selected' : ''}>租赁技巧</option>
                        <option value="COMPLAINT" ${category == 'COMPLAINT' ? 'selected' : ''}>投诉建议</option>
                        <option value="QUESTION" ${category == 'QUESTION' ? 'selected' : ''}>问题咨询</option>
                        <option value="EXPERIENCE" ${category == 'EXPERIENCE' ? 'selected' : ''}>经验分享</option>
                    </select>
                    <div class="category-info">
                        <strong>分类说明：</strong><br>
                        <strong>综合讨论：</strong>一般性话题讨论<br>
                        <strong>租赁技巧：</strong>租房、出租相关技巧和经验<br>
                        <strong>投诉建议：</strong>对平台或服务的投诉和建议<br>
                        <strong>问题咨询：</strong>寻求帮助和解答<br>
                        <strong>经验分享：</strong>个人租房或出租经验分享
                    </div>
                </div>

                <!-- 内容 -->
                <div class="mb-4">
                    <label for="content" class="form-label">
                        <i class="bi bi-chat-text"></i> 帖子内容
                    </label>
                    <textarea class="form-control" id="content" name="content" 
                              rows="10" 
                              placeholder="请输入帖子内容..." 
                              maxlength="5000" 
                              required>${content}</textarea>
                    <div class="character-count" id="contentCount">0/5000</div>
                </div>

                <!-- 按钮组 -->
                <div class="d-flex gap-3 justify-content-end">
                    <a href="${pageContext.request.contextPath}/forum" class="btn btn-cancel">
                        <i class="bi bi-x-circle"></i> 取消
                    </a>
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-send"></i> 发布帖子
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 字符计数功能
        function updateCharacterCount(input, counter, maxLength) {
            const count = input.value.length;
            counter.textContent = count + '/' + maxLength;
            
            // 根据字符数改变颜色
            counter.className = 'character-count';
            if (count > maxLength * 0.9) {
                counter.classList.add('warning');
            }
            if (count > maxLength * 0.95) {
                counter.classList.add('danger');
            }
        }

        // 标题字符计数
        const titleInput = document.getElementById('title');
        const titleCount = document.getElementById('titleCount');
        titleInput.addEventListener('input', function() {
            updateCharacterCount(this, titleCount, 100);
        });
        updateCharacterCount(titleInput, titleCount, 100);

        // 内容字符计数
        const contentInput = document.getElementById('content');
        const contentCount = document.getElementById('contentCount');
        contentInput.addEventListener('input', function() {
            updateCharacterCount(this, contentCount, 5000);
        });
        updateCharacterCount(contentInput, contentCount, 5000);

        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = titleInput.value.trim();
            const content = contentInput.value.trim();
            const category = document.getElementById('category').value;

            if (!title) {
                e.preventDefault();
                alert('请输入帖子标题');
                titleInput.focus();
                return;
            }

            if (!content) {
                e.preventDefault();
                alert('请输入帖子内容');
                contentInput.focus();
                return;
            }

            if (!category) {
                e.preventDefault();
                alert('请选择帖子分类');
                document.getElementById('category').focus();
                return;
            }
        });
    </script>
</body>
</html> 