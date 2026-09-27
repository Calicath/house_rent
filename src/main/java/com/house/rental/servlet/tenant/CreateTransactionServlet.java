package com.house.rental.servlet.tenant;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

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
import jakarta.servlet.http.HttpSession;

@WebServlet("/tenant/create-transaction")
public class CreateTransactionServlet extends HttpServlet {
    private final TransactionService transactionService;
    private HouseService houseService = new HouseServiceImpl();

    public CreateTransactionServlet() {
        this.transactionService = new TransactionServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"tenant".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
            LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
            BigDecimal rentAmount = new BigDecimal(request.getParameter("rentAmount"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));

            // 验证房源是否存在
            if (houseService.getHouseById(houseId) == null) {
                throw new IllegalArgumentException("房源不存在");
            }

            // 验证日期
            if (startDate.isAfter(endDate)) {
                throw new IllegalArgumentException("开始日期不能晚于结束日期");
            }

            Transaction transaction = new Transaction();
            transaction.setHouseId(houseId);
            transaction.setTenantId(user.getReferenceId());
            transaction.setStartDate(startDate);
            transaction.setEndDate(endDate);
            transaction.setRentAmount(rentAmount);
            transaction.setDepositAmount(depositAmount);
            transaction.setNotes(request.getParameter("notes"));

            try {
                transactionService.createTransaction(transaction);
                response.sendRedirect(request.getContextPath() + "/tenant/transactions");
            } catch (Exception e) {
                request.setAttribute("error", "创建交易失败：" + e.getMessage());
                request.getRequestDispatcher("/tenant/create-transaction.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "创建交易失败：" + e.getMessage());
            request.getRequestDispatcher("/tenant/create-transaction.jsp").forward(request, response);
        }
    }
} 