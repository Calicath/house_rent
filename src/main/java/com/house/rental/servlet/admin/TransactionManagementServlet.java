package com.house.rental.servlet.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

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

@WebServlet("/admin/transactions")
public class TransactionManagementServlet extends HttpServlet {
    private UserService userService;
    private HouseService houseService;
    private TransactionService transactionService;
    private static final int PAGE_SIZE = 12;

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
            // 获取查询参数
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            
            LocalDate startDate = null;
            if (startDateStr != null && !startDateStr.isEmpty()) {
                try {
                    startDate = LocalDate.parse(startDateStr);
                } catch (DateTimeParseException e) {
                    System.err.println("Invalid start date format: " + startDateStr);
                    // Optionally set an error message in request or log
                }
            }

            LocalDate endDate = null;
            if (endDateStr != null && !endDateStr.isEmpty()) {
                try {
                    endDate = LocalDate.parse(endDateStr);
                } catch (DateTimeParseException e) {
                    System.err.println("Invalid end date format: " + endDateStr);
                    // Optionally set an error message in request or log
                }
            }

            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // 使用默认值1
            }

            // 获取交易列表
            List<Transaction> transactions = transactionService.searchTransactions(
                keyword, status, paymentStatus, startDate, endDate, page, PAGE_SIZE);
            int totalTransactions = transactionService.getTotalTransactions(
                keyword, status, paymentStatus, startDate, endDate);
            int totalPages = (int) Math.ceil((double) totalTransactions / PAGE_SIZE);

            // 获取所有房屋和租客（用于添加/编辑交易时的选择）
            List<House> houses = houseService.getAllHouses();
            List<User> tenants = userService.getUsersByType("TENANT");

            // 设置属性
            request.setAttribute("transactions", transactions);
            request.setAttribute("houses", houses);
            request.setAttribute("tenants", tenants);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalTransactions", totalTransactions);

            // 转发到JSP页面
            request.getRequestDispatcher("/admin/transactions.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取交易列表失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 