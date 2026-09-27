package com.house.rental.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.house.rental.bean.User;
import com.house.rental.service.TransactionService;
import com.house.rental.service.impl.TransactionServiceImpl;

@WebServlet("/admin/transaction/delete")
public class DeleteTransactionServlet extends HttpServlet {
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"ADMIN".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取交易ID
            int transactionId = Integer.parseInt(request.getParameter("id"));

            // 删除交易
            transactionService.deleteTransaction(transactionId);

            // 返回成功响应
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
} 