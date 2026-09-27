package com.house.rental.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import com.house.rental.bean.House;
import com.house.rental.bean.Transaction;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.TransactionService;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.TransactionServiceImpl;
import com.house.rental.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private UserService userService;
    private HouseService houseService;
    private TransactionService transactionService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        houseService = new HouseServiceImpl();
        transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"ADMIN".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取用户统计
            List<User> allUsers = userService.getAllUsers();
            int totalUsers = allUsers.size();
            int ownerCount = (int) allUsers.stream()
                    .filter(u -> "OWNER".equals(u.getType()))
                    .count();
            int tenantCount = (int) allUsers.stream()
                    .filter(u -> "TENANT".equals(u.getType()))
                    .count();

            // 获取房屋统计
            List<House> allHouses = houseService.getAllHouses();
            int totalHouses = allHouses.size();

            // 获取交易统计
            List<Transaction> allTransactions = transactionService.getAllTransactions();
            int activeTransactions = transactionService.getTransactionsByStatus("ACTIVE").size();
            int activeTransactionCount = transactionService.getTransactionsByStatus("ACTIVE").size();
            int pendingTransactionCount = transactionService.getTransactionsByStatus("PENDING").size();
            int completedTransactionCount = transactionService.getTransactionsByStatus("COMPLETED").size();

            // 计算本月收入（活跃交易的租金总和）
            BigDecimal monthlyIncome = transactionService.getTransactionsByStatus("ACTIVE").stream()
                    .map(Transaction::getRentAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // 获取最近的交易记录（按交易ID倒序，取前5条）
            List<Transaction> recentTransactions = allTransactions.stream()
                    .sorted((t1, t2) -> Integer.compare(t2.getTransactionId(), t1.getTransactionId()))
                    .limit(5)
                    .collect(Collectors.toList());

            // 设置属性
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("ownerCount", ownerCount);
            request.setAttribute("tenantCount", tenantCount);
            request.setAttribute("totalHouses", totalHouses);
            request.setAttribute("activeTransactions", activeTransactions);
            request.setAttribute("monthlyIncome", monthlyIncome);
            request.setAttribute("activeTransactionCount", activeTransactionCount);
            request.setAttribute("pendingTransactionCount", pendingTransactionCount);
            request.setAttribute("completedTransactionCount", completedTransactionCount);
            request.setAttribute("recentTransactions", recentTransactions);

            // 转发到JSP页面
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取数据失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 