package com.house.rental.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

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

@WebServlet("/admin/transaction/add")
public class AddTransactionServlet extends HttpServlet {
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
            // 获取表单数据
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
            LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
            BigDecimal rentAmount = new BigDecimal(request.getParameter("rentAmount"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");
            String notes = request.getParameter("notes");

            // 创建交易对象
            Transaction transaction = new Transaction();
            transaction.setHouseId(houseId);
            transaction.setTenantId(tenantId);
            transaction.setStartDate(startDate);
            transaction.setEndDate(endDate);
            transaction.setRentAmount(rentAmount);
            transaction.setDepositAmount(depositAmount);
            transaction.setStatus(status);
            transaction.setPaymentStatus(paymentStatus);
            transaction.setNotes(notes);

            // 保存交易
            transactionService.createTransaction(transaction);

            // 重定向到交易列表页面
            response.sendRedirect(request.getContextPath() + "/admin/transactions");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加交易失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 