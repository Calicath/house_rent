package com.house.rental.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;

@WebServlet("/admin/house/delete")
public class DeleteHouseServlet extends HttpServlet {
    private HouseService houseService;

    @Override
    public void init() throws ServletException {
        houseService = new HouseServiceImpl();
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
            // 获取房屋ID
            int houseId = Integer.parseInt(request.getParameter("id"));

            // 删除房屋
            houseService.deleteHouse(houseId);

            // 返回成功响应
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
} 