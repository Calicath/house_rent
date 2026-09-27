<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>简单测试</title>
</head>
<body>
    <h1>简单表单测试</h1>
    
    <%
    if ("POST".equals(request.getMethod())) {
        out.println("<h2>POST 请求结果:</h2>");
        out.println("<p>Content-Type: " + request.getContentType() + "</p>");
        
        String title = request.getParameter("title");
        out.println("<p>title 参数: [" + title + "]</p>");
        out.println("<p>title 是否为 null: " + (title == null) + "</p>");
        out.println("<p>title 是否为空: " + (title != null && title.isEmpty()) + "</p>");
        
        // 打印所有参数
        out.println("<h3>所有参数:</h3>");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            out.println("<p><strong>" + paramName + ":</strong> [" + paramValue + "]</p>");
        }
    } else {
    %>
        <form method="post">
            <p>
                <label>标题: <input type="text" name="title" required></label>
            </p>
            <p>
                <label>地址: <input type="text" name="address" required></label>
            </p>
            <p>
                <input type="submit" value="提交">
            </p>
        </form>
    <%
    }
    %>
    
    <p><a href="${pageContext.request.contextPath}/">返回首页</a></p>
</body>
</html> 