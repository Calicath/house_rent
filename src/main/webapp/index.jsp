<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 0;
            text-align: center;
        }
        .feature-section {
            padding: 80px 0;
            background-color: #f8f9fa;
        }
        .feature-card {
            text-align: center;
            padding: 30px 20px;
            margin-bottom: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 48px;
            margin-bottom: 20px;
            color: #0d6efd;
        }
        .cta-section {
            padding: 80px 0;
            background-color: #0d6efd;
            color: white;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-house-heart"></i> 房屋租赁系统
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">
                            <i class="bi bi-person-plus"></i> 注册
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">
                            <i class="bi bi-box-arrow-in-right"></i> 登录
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/forum">
                            <i class="bi bi-chat-dots"></i> 论坛
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <section class="hero-section">
        <div class="container">
            <h1 class="display-3 fw-bold mb-4">智能房屋租赁管理平台</h1>
            <p class="lead mb-5">连接房主与租户，提供安全、便捷、高效的房屋租赁服务</p>
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/register?type=owner" class="btn btn-light btn-lg w-100">
                                <i class="bi bi-person-badge"></i> 我是房主
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/register?type=tenant" class="btn btn-outline-light btn-lg w-100">
                                <i class="bi bi-person"></i> 我要租房
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="feature-section">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold">为什么选择我们？</h2>
                <p class="lead text-muted">专业的房屋租赁管理解决方案</p>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-building"></i>
                        </div>
                        <h4>房源管理</h4>
                        <p class="text-muted">房主可以轻松发布、管理和维护房源信息，实时更新房屋状态</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4>智能搜索</h4>
                        <p class="text-muted">租户可以根据位置、价格、房型等条件快速找到心仪的房源</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h4>安全保障</h4>
                        <p class="text-muted">实名认证、合同管理、支付保障，确保交易安全可靠</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-currency-dollar"></i>
                        </div>
                        <h4>在线支付</h4>
                        <p class="text-muted">支持多种支付方式，租金缴纳便捷，交易记录清晰</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-chat-dots"></i>
                        </div>
                        <h4>在线沟通</h4>
                        <p class="text-muted">房主与租户可以实时沟通，预约看房，解决问题</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-graph-up"></i>
                        </div>
                        <h4>数据分析</h4>
                        <p class="text-muted">提供详细的租赁数据分析和报表，帮助优化管理</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="cta-section">
        <div class="container text-center">
            <h2 class="display-5 fw-bold mb-4">立即开始您的租赁之旅</h2>
            <p class="lead mb-5">加入我们，体验智能化的房屋租赁管理服务</p>
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/register?type=owner" class="btn btn-light btn-lg w-100">
                                <i class="bi bi-person-badge"></i> 注册为房主
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/register?type=tenant" class="btn btn-outline-light btn-lg w-100">
                                <i class="bi bi-person"></i> 注册为租户
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="bi bi-house-heart"></i> 房屋租赁系统</h5>
                    <p class="text-muted">专业的房屋租赁管理平台</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="text-muted mb-0">©fxr cxl sxw</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 