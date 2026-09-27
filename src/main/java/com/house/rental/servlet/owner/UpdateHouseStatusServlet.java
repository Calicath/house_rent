package com.house.rental.servlet.owner;

import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/owner/update-house-status")
public class UpdateHouseStatusServlet extends HttpServlet {
    private HouseService houseService = new HouseServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            String status = request.getParameter("status");
            // 校验房屋归属
            if (!houseService.isOwnerHouse(user.getReferenceId(), houseId)) {
                request.setAttribute("error", "无权操作该房屋");
                request.getRequestDispatcher("/owner/houses").forward(request, response);
                return;
            }
            houseService.updateHouseStatus(houseId, status);
            response.sendRedirect(request.getContextPath() + "/owner/houses");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "变更房屋状态失败: " + e.getMessage());
            request.getRequestDispatcher("/owner/houses").forward(request, response);
        }
    }
} 