package com.house.rental.servlet.owner;

import java.io.IOException;

import com.house.rental.bean.Transaction;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.TransactionService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.TransactionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/owner/process-transaction")
public class ProcessTransactionServlet extends HttpServlet {
    private TransactionService transactionService = new TransactionServiceImpl();
    private HouseService houseService = new HouseServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录且是房主
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            String action = request.getParameter("action"); // "approve" 或 "reject"
            String responseMessage = request.getParameter("responseMessage");

            // 获取交易记录
            Transaction transaction = transactionService.getTransactionById(transactionId);
            if (transaction == null) {
                throw new IllegalArgumentException("交易记录不存在");
            }

            // 验证房源所有权
            if (houseService.getHouseById(transaction.getHouseId()).getOwnerId() != user.getReferenceId()) {
                throw new IllegalArgumentException("您没有权限处理此租赁申请");
            }

            // 更新交易记录状态
            if ("approve".equals(action)) {
                transaction.setStatus("APPROVED");
            } else if ("reject".equals(action)) {
                transaction.setStatus("REJECTED");
            } else {
                throw new IllegalArgumentException("无效的操作");
            }

            // 设置房主回复
            transaction.setNotes(responseMessage);

            // 更新交易记录
            transactionService.updateTransaction(transaction);

            // 重定向到房主仪表板
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "处理租赁申请失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/dashboard").forward(request, response);
        }
    }
} 