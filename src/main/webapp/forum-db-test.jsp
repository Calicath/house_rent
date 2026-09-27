<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>论坛数据库测试</title>
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
        .status-success {
            color: #198754;
            font-weight: bold;
        }
        .status-error {
            color: #dc3545;
            font-weight: bold;
        }
        .status-warning {
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="text-center mb-4">
                    <h1><i class="bi bi-database-check"></i> 论坛数据库测试</h1>
                    <p class="text-muted">检查论坛数据库表是否存在和功能是否正常</p>
                </div>

                <!-- 数据库连接测试 -->
                <div class="test-card">
                    <h5><i class="bi bi-plug"></i> 数据库连接测试</h5>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary" onclick="testDatabaseConnection()">
                            <i class="bi bi-arrow-clockwise"></i> 测试数据库连接
                        </button>
                        <div id="dbConnectionResult"></div>
                    </div>
                </div>

                <!-- 表结构检查 -->
                <div class="test-card">
                    <h5><i class="bi bi-table"></i> 表结构检查</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6>forum_posts 表</h6>
                                    <div id="postsTableStatus">检查中...</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6>forum_comments 表</h6>
                                    <div id="commentsTableStatus">检查中...</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 数据统计 -->
                <div class="test-card">
                    <h5><i class="bi bi-bar-chart"></i> 数据统计</h5>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h3 id="totalPosts">-</h3>
                                    <p class="text-muted">总帖子数</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h3 id="totalComments">-</h3>
                                    <p class="text-muted">总评论数</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h3 id="totalUsers">-</h3>
                                    <p class="text-muted">发帖用户数</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 最新帖子 -->
                <div class="test-card">
                    <h5><i class="bi bi-clock-history"></i> 最新帖子</h5>
                    <div id="latestPosts">
                        <div class="text-center text-muted">
                            <i class="bi bi-hourglass-split"></i> 加载中...
                        </div>
                    </div>
                </div>

                <!-- 测试发帖功能 -->
                <div class="test-card">
                    <h5><i class="bi bi-plus-circle"></i> 测试发帖功能</h5>
                    <div class="d-grid gap-2">
                        <button class="btn btn-success" onclick="testCreatePost()">
                            <i class="bi bi-plus-circle"></i> 创建测试帖子
                        </button>
                        <div id="createPostResult"></div>
                    </div>
                </div>

                <!-- 数据库修复 -->
                <div class="test-card">
                    <h5><i class="bi bi-tools"></i> 数据库修复</h5>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> 
                        如果数据库表不存在，请执行以下SQL脚本：
                    </div>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/check-forum-database.sql" 
                           class="btn btn-warning" download>
                            <i class="bi bi-download"></i> 下载数据库检查脚本
                        </a>
                        <a href="${pageContext.request.contextPath}/forum_database_init.sql" 
                           class="btn btn-danger" download>
                            <i class="bi bi-download"></i> 下载数据库初始化脚本
                        </a>
                    </div>
                </div>

                <!-- 返回链接 -->
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/forum" class="btn btn-primary">
                        <i class="bi bi-arrow-left"></i> 返回论坛
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                        <i class="bi bi-house"></i> 返回首页
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面加载时自动检查
        document.addEventListener('DOMContentLoaded', function() {
            checkDatabaseStatus();
        });

        function testDatabaseConnection() {
            const resultDiv = document.getElementById('dbConnectionResult');
            resultDiv.innerHTML = '<div class="alert alert-info">正在测试数据库连接...</div>';
            
            fetch('${pageContext.request.contextPath}/forum', {
                method: 'GET'
            })
            .then(response => {
                if (response.ok) {
                    resultDiv.innerHTML = '<div class="alert alert-success">数据库连接正常！</div>';
                } else {
                    resultDiv.innerHTML = '<div class="alert alert-danger">数据库连接失败！</div>';
                }
            })
            .catch(error => {
                resultDiv.innerHTML = '<div class="alert alert-danger">连接错误：' + error.message + '</div>';
            });
        }

        function checkDatabaseStatus() {
            // 检查帖子表
            fetch('${pageContext.request.contextPath}/forum?test=posts')
            .then(response => response.json())
            .then(data => {
                document.getElementById('postsTableStatus').innerHTML = 
                    '<span class="status-success">✓ 表存在</span>';
                document.getElementById('totalPosts').textContent = data.totalPosts || 0;
            })
            .catch(error => {
                document.getElementById('postsTableStatus').innerHTML = 
                    '<span class="status-error">✗ 表不存在或查询失败</span>';
            });

            // 检查评论表
            fetch('${pageContext.request.contextPath}/forum?test=comments')
            .then(response => response.json())
            .then(data => {
                document.getElementById('commentsTableStatus').innerHTML = 
                    '<span class="status-success">✓ 表存在</span>';
                document.getElementById('totalComments').textContent = data.totalComments || 0;
            })
            .catch(error => {
                document.getElementById('commentsTableStatus').innerHTML = 
                    '<span class="status-error">✗ 表不存在或查询失败</span>';
            });

            // 获取最新帖子
            fetch('${pageContext.request.contextPath}/forum?test=latest')
            .then(response => response.json())
            .then(data => {
                const latestPostsDiv = document.getElementById('latestPosts');
                if (data.posts && data.posts.length > 0) {
                    let html = '<div class="list-group">';
                    data.posts.forEach(post => {
                        html += `
                            <div class="list-group-item">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">${post.title}</h6>
                                    <small class="text-muted">${post.createdAt}</small>
                                </div>
                                <p class="mb-1">${post.content.substring(0, 100)}...</p>
                                <small class="text-muted">分类: ${post.category}</small>
                            </div>
                        `;
                    });
                    html += '</div>';
                    latestPostsDiv.innerHTML = html;
                } else {
                    latestPostsDiv.innerHTML = '<div class="text-center text-muted">暂无帖子</div>';
                }
            })
            .catch(error => {
                document.getElementById('latestPosts').innerHTML = 
                    '<div class="alert alert-warning">无法获取帖子数据</div>';
            });
        }

        function testCreatePost() {
            const resultDiv = document.getElementById('createPostResult');
            resultDiv.innerHTML = '<div class="alert alert-info">正在创建测试帖子...</div>';
            
            const testData = {
                title: '测试帖子 - ' + new Date().toLocaleString(),
                content: '这是一个自动生成的测试帖子，用于验证发帖功能是否正常工作。',
                category: 'GENERAL'
            };
            
            fetch('${pageContext.request.contextPath}/forum/create-post', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(testData)
            })
            .then(response => {
                if (response.ok) {
                    resultDiv.innerHTML = '<div class="alert alert-success">测试帖子创建成功！</div>';
                    // 刷新数据统计
                    setTimeout(checkDatabaseStatus, 1000);
                } else {
                    resultDiv.innerHTML = '<div class="alert alert-danger">测试帖子创建失败！</div>';
                }
            })
            .catch(error => {
                resultDiv.innerHTML = '<div class="alert alert-danger">创建失败：' + error.message + '</div>';
            });
        }
    </script>
</body>
</html> 