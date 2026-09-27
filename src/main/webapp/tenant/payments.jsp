<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>支付记录 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">支付记录</h2>
    <a href="${pageContext.request.contextPath}/tenant/dashboard" class="btn btn-secondary mb-3">返回主页</a>
    <div class="table-responsive">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>支付编号</th>
                    <th>交易编号</th>
                    <th>金额</th>
                    <th>支付日期</th>
                    <th>类型</th>
                    <th>状态</th>
                    <th>备注</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${payments}" var="payment">
                    <tr>
                        <td>${payment.paymentId}</td>
                        <td>${payment.transactionId}</td>
                        <td>￥${payment.amount}</td>
                        <td>${payment.paymentDate}</td>
                        <td>${payment.type == 'RENT' ? '租金' : '手续费'}</td>
                        <td>
                            <span class="badge bg-${payment.status == 'SUCCESS' ? 'success' : payment.status == 'PENDING' ? 'warning' : 'danger'}">
                                ${payment.status}
                            </span>
                        </td>
                        <td>${payment.notes}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <c:if test="${empty payments}">
        <div class="alert alert-info mt-4">暂无支付记录。</div>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 