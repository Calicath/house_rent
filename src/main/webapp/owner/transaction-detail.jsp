<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>交易详情 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .detail-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); padding: 32px; margin-top: 40px; }
        .section-title { font-size: 1.3rem; font-weight: 600; margin-bottom: 18px; color: #333; }
        .info-row { margin-bottom: 1rem; }
        .info-label { color: #888; min-width: 100px; display: inline-block; }
        .fee-row { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <div class="detail-card mx-auto" style="max-width: 700px;">
            <h2 class="mb-4"><i class="bi bi-file-earmark-text"></i> 交易详情</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty transaction}">
                <div class="info-row"><span class="info-label">交易编号：</span>${transaction.transactionId}</div>
                <div class="info-row"><span class="info-label">合同编号：</span>${transaction.contractNumber}</div>
                <div class="info-row"><span class="info-label">房屋：</span>${transaction.house.title}（ID: ${transaction.house.houseId}）</div>
                <div class="info-row"><span class="info-label">租客：</span>${transaction.tenant.user.username}（ID: ${transaction.tenant.tenantId}）</div>
                <div class="info-row"><span class="info-label">租期：</span>${transaction.startDate} 至 ${transaction.endDate}</div>
                <div class="info-row"><span class="info-label">租金：</span>￥${transaction.rentAmount} /月</div>
                <div class="info-row"><span class="info-label">押金：</span>￥${transaction.depositAmount}</div>
                <div class="info-row"><span class="info-label">状态：</span>
                    <span class="badge bg-${transaction.status == 'ACTIVE' ? 'success' : transaction.status == 'COMPLETED' ? 'primary' : 'danger'}">
                        ${transaction.status == 'ACTIVE' ? '进行中' : transaction.status == 'COMPLETED' ? '已完成' : '已取消'}
                    </span>
                </div>
                <div class="info-row"><span class="info-label">支付状态：</span>
                    <span class="badge bg-${transaction.paymentStatus == 'PAID' ? 'success' : transaction.paymentStatus == 'PARTIAL' ? 'warning' : 'danger'}">
                        ${transaction.paymentStatus == 'PAID' ? '已支付' : transaction.paymentStatus == 'PARTIAL' ? '部分支付' : '未支付'}
                    </span>
                </div>
                <div class="info-row fee-row"><span class="info-label">手续费（3%）：</span>￥<c:out value="${transaction.rentAmount * 0.03}"/></div>
                <div class="info-row"><span class="info-label">备注：</span>${transaction.notes}</div>
            </c:if>
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary mt-4"><i class="bi bi-arrow-left"></i> 返回</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 