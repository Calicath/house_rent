package com.house.rental.servlet.owner;

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
import com.house.rental.bean.House;
import com.house.rental.bean.Transaction;
import com.house.rental.service.HouseService;
import com.house.rental.service.TransactionService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.TransactionServiceImpl;

@WebServlet("/owner/dashboard")
public class DashboardServlet extends HttpServlet {
    private HouseService houseService;
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        houseService = new HouseServiceImpl();
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是房主
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (!"OWNER".equals(user.getType())) {
            // 用户类型不匹配，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_user_type");
            return;
        }

        try {
            // 获取房主的房屋列表
            List<House> houses = houseService.getHousesByOwnerId(user.getReferenceId());
            
            // 获取统计数据
            int totalHouses = houses.size();
            int rentedHouses = (int) houses.stream()
                    .filter(h -> "RENTED".equals(h.getStatus()))
                    .count();
            int pendingTransactions = transactionService.getTransactionsByStatus("PENDING").size();
            BigDecimal monthlyIncome = transactionService.getTransactionsByStatus("ACTIVE").stream()
                    .map(Transaction::getRentAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // 获取最近的交易记录
            List<Transaction> recentTransactions = transactionService.getTransactionsByOwnerId(user.getReferenceId())
                    .stream()
                    .limit(5)
                    .collect(Collectors.toList());

            // 设置属性
            request.setAttribute("houses", houses);
            request.setAttribute("totalHouses", totalHouses);
            request.setAttribute("rentedHouses", rentedHouses);
            request.setAttribute("pendingTransactions", pendingTransactions);
            request.setAttribute("monthlyIncome", monthlyIncome);
            request.setAttribute("recentTransactions", recentTransactions);

            // 转发到JSP页面
            request.getRequestDispatcher("/owner/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取数据失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 