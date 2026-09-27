package com.house.rental.servlet.tenant;

import com.house.rental.bean.User;
import com.house.rental.bean.Transaction;
import com.house.rental.bean.Payment;
import com.house.rental.service.TransactionService;
import com.house.rental.service.PaymentService;
import com.house.rental.service.impl.TransactionServiceImpl;
import com.house.rental.service.impl.PaymentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet("/tenant/create-payment")
public class CreatePaymentServlet extends HttpServlet {
    private TransactionService transactionService = new TransactionServiceImpl();
    private PaymentService paymentService = new PaymentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"TENANT".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String houseIdStr = request.getParameter("houseId");
        if (houseIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/tenant/dashboard");
            return;
        }
        int houseId = Integer.parseInt(houseIdStr);
        // 查找该租户与该房屋的活跃交易
        Transaction transaction = transactionService.getActiveTransactionByTenantAndHouse(user.getReferenceId(), houseId);
        if (transaction == null) {
            request.setAttribute("error", "未找到可支付的交易");
            request.getRequestDispatcher("/tenant/dashboard").forward(request, response);
            return;
        }
        request.setAttribute("transaction", transaction);
        request.getRequestDispatcher("/tenant/create-payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"TENANT".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int transactionId = Integer.parseInt(request.getParameter("transactionId"));
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        Payment payment = new Payment();
        payment.setTransactionId(transactionId);
        payment.setUserId(user.getReferenceId());
        payment.setAmount(amount);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus("SUCCESS");
        payment.setNotes("租金支付");
        payment.setType("RENT");
        paymentService.createPayment(payment);
        response.sendRedirect(request.getContextPath() + "/tenant/payments");
    }
} 