<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>发起支付 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">发起支付</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty transaction}">
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">交易信息</h5>
                <p>房屋：${transaction.house.title}</p>
                <p>租金：￥${transaction.rentAmount}</p>
                <p>押金：￥${transaction.depositAmount}</p>
                <p>租期：${transaction.startDate} 至 ${transaction.endDate}</p>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/tenant/create-payment" method="post">
            <input type="hidden" name="transactionId" value="${transaction.transactionId}" />
            <div class="mb-3">
                <label for="amount" class="form-label">支付金额</label>
                <input type="number" class="form-control" id="amount" name="amount" value="${transaction.rentAmount}" required step="0.01" min="0.01">
            </div>
            <div class="mb-3">
                <label for="paymentMethod" class="form-label">支付方式</label>
                <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                    <option value="ALIPAY">支付宝</option>
                    <option value="WECHAT">微信</option>
                    <option value="BANK">银行卡</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">确认支付</button>
            <a href="${pageContext.request.contextPath}/tenant/dashboard" class="btn btn-secondary ms-2">取消</a>
        </form>
    </c:if>
    <c:if test="${empty transaction}">
        <div class="alert alert-warning mt-4">未找到可支付的交易。</div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 