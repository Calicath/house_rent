package com.house.rental.servlet.tenant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import java.math.BigDecimal;
import com.house.rental.bean.User;
import com.house.rental.bean.Transaction;
import com.house.rental.bean.Payment;
import com.house.rental.service.TransactionService;
import com.house.rental.service.PaymentService;
import com.house.rental.service.impl.TransactionServiceImpl;
import com.house.rental.service.impl.PaymentServiceImpl;

@WebServlet("/tenant/dashboard")
public class DashboardServlet extends HttpServlet {
    private final TransactionService transactionService;
    private final PaymentService paymentService;

    public DashboardServlet() {
        this.transactionService = new TransactionServiceImpl();
        this.paymentService = new PaymentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是租户
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (!"TENANT".equals(user.getType())) {
            // 用户类型不匹配，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_user_type");
            return;
        }

        try {
            // 获取租户的租赁记录
            List<Transaction> activeRentals = transactionService.getTransactionsByTenantId(user.getUserId())
                    .stream()
                    .filter(t -> "ACTIVE".equals(t.getStatus()))
                    .collect(Collectors.toList());
            
            // 获取统计数据
            int activeRentalsCount = activeRentals.size();
            int pendingPayments = paymentService.getPaymentsByStatus("PENDING").size();
            BigDecimal monthlyExpenses = paymentService.getPaymentsByStatus("COMPLETED").stream()
                    .map(Payment::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            int pendingApplications = transactionService.getTransactionsByStatus("PENDING").size();

            // 获取最近的支付记录
            List<Payment> recentPayments = paymentService.getPaymentsByTenantId(user.getUserId())
                    .stream()
                    .limit(5)
                    .collect(Collectors.toList());

            // 设置属性
            request.setAttribute("activeRentals", activeRentals);
            request.setAttribute("activeRentalsCount", activeRentalsCount);
            request.setAttribute("pendingPayments", pendingPayments);
            request.setAttribute("monthlyExpenses", monthlyExpenses);
            request.setAttribute("pendingApplications", pendingApplications);
            request.setAttribute("recentPayments", recentPayments);

            // 转发到JSP页面
            request.getRequestDispatcher("/tenant/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取数据失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 