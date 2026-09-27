package com.house.rental.servlet.owner;

import java.io.IOException;

import com.house.rental.bean.Transaction;
import com.house.rental.bean.User;
import com.house.rental.service.TransactionService;
import com.house.rental.service.impl.TransactionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/owner/transaction-detail")
public class TransactionDetailServlet extends HttpServlet {
    private TransactionService transactionService = new TransactionServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idStr = request.getParameter("id");
        if (idStr == null) {
            request.setAttribute("error", "缺少交易ID参数");
            request.getRequestDispatcher("/owner/transaction-detail.jsp").forward(request, response);
            return;
        }
        try {
            int transactionId = Integer.parseInt(idStr);
            Transaction transaction = transactionService.getTransactionById(transactionId);
            if (transaction == null) {
                request.setAttribute("error", "未找到该交易");
            } else {
                request.setAttribute("transaction", transaction);
            }
            request.getRequestDispatcher("/owner/transaction-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "查询交易详情出错: " + e.getMessage());
            request.getRequestDispatcher("/owner/transaction-detail.jsp").forward(request, response);
        }
    }
} 