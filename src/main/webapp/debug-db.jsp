<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.house.rental.util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据库连接测试 - 房屋租赁系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>数据库连接测试</h1>
        
        <div class="card">
            <div class="card-header">
                <h5>连接状态</h5>
            </div>
            <div class="card-body">
                <%
                try {
                    Connection conn = DBUtil.getConnection();
                    if (conn != null && !conn.isClosed()) {
                        out.println("<div class='alert alert-success'>");
                        out.println("<strong>✓ 数据库连接成功！</strong>");
                        out.println("<br>数据库URL: " + conn.getMetaData().getURL());
                        out.println("<br>数据库产品名称: " + conn.getMetaData().getDatabaseProductName());
                        out.println("<br>数据库版本: " + conn.getMetaData().getDatabaseProductVersion());
                        out.println("</div>");
                        
                        // 测试查询
                        try {
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM houses");
                            if (rs.next()) {
                                out.println("<div class='alert alert-info'>");
                                out.println("<strong>✓ 查询测试成功！</strong>");
                                out.println("<br>houses 表中的记录数: " + rs.getInt("count"));
                                out.println("</div>");
                            }
                            rs.close();
                            stmt.close();
                        } catch (SQLException e) {
                            out.println("<div class='alert alert-warning'>");
                            out.println("<strong>⚠ 查询测试失败</strong>");
                            out.println("<br>错误: " + e.getMessage());
                            out.println("</div>");
                        }
                        
                        conn.close();
                    } else {
                        out.println("<div class='alert alert-danger'>");
                        out.println("<strong>✗ 数据库连接失败！</strong>");
                        out.println("<br>连接对象为null或已关闭");
                        out.println("</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>");
                    out.println("<strong>✗ 数据库连接异常！</strong>");
                    out.println("<br>错误类型: " + e.getClass().getSimpleName());
                    out.println("<br>错误信息: " + e.getMessage());
                    out.println("</div>");
                    
                    // 打印详细堆栈信息
                    out.println("<div class='card mt-3'>");
                    out.println("<div class='card-header'>详细错误信息</div>");
                    out.println("<div class='card-body'>");
                    out.println("<pre>" + e.toString() + "</pre>");
                    out.println("</div>");
                    out.println("</div>");
                }
                %>
            </div>
        </div>
        
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/debug-add-house" class="btn btn-primary">返回调试页面</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">返回首页</a>
        </div>
    </div>
</body>
</html> 