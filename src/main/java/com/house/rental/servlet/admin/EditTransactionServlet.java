package com.house.rental.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.google.gson.Gson;
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

@WebServlet("/admin/transaction/edit")
public class EditTransactionServlet extends HttpServlet {
    private final TransactionService transactionService;
    private final Gson gson;

    public EditTransactionServlet() {
        this.transactionService = new TransactionServiceImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取交易ID
            int transactionId = Integer.parseInt(request.getParameter("id"));
            
            // 获取交易信息
            Transaction transaction = transactionService.getTransactionById(transactionId);
            if (transaction == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"交易不存在\"}");
                return;
            }

            // 返回JSON格式的交易信息
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(transaction));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            
            String startDateStr = request.getParameter("startDate");
            LocalDate startDate = null;
            if (startDateStr != null && !startDateStr.isEmpty()) {
                try {
                    startDate = LocalDate.parse(startDateStr);
                } catch (DateTimeParseException e) {
                    System.err.println("Invalid start date format: " + startDateStr);
                    throw new ServletException("无效的开始日期格式", e);
                }
            }
            
            String endDateStr = request.getParameter("endDate");
            LocalDate endDate = null;
            if (endDateStr != null && !endDateStr.isEmpty()) {
                try {
                    endDate = LocalDate.parse(endDateStr);
                } catch (DateTimeParseException e) {
                    System.err.println("Invalid end date format: " + endDateStr);
                    throw new ServletException("无效的结束日期格式", e);
                }
            }

            BigDecimal rentAmount = new BigDecimal(request.getParameter("rentAmount"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");
            String notes = request.getParameter("notes");

            // 获取现有交易信息
            Transaction transaction = transactionService.getTransactionById(transactionId);
            if (transaction == null) {
                throw new Exception("交易不存在");
            }

            // 更新交易信息
            transaction.setHouseId(houseId);
            transaction.setTenantId(tenantId);
            transaction.setStartDate(startDate);
            transaction.setEndDate(endDate);
            transaction.setRentAmount(rentAmount);
            transaction.setDepositAmount(depositAmount);
            transaction.setStatus(status);
            transaction.setPaymentStatus(paymentStatus);
            transaction.setNotes(notes);

            // 保存更新
            transactionService.updateTransaction(transaction);

            // 重定向到交易列表页面
            response.sendRedirect(request.getContextPath() + "/admin/transactions");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新交易失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 