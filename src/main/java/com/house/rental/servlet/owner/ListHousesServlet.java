package com.house.rental.servlet.owner;

import com.house.rental.bean.House;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/owner/houses")
public class ListHousesServlet extends HttpServlet {
    private final HouseService houseService;

    public ListHousesServlet() {
        this.houseService = new HouseServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否已登录且是房东
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取房东的房屋列表
            List<House> houses = houseService.getHousesByOwnerId(user.getReferenceId());
            request.setAttribute("houses", houses);
            
            // 转发到房屋列表页面
            request.getRequestDispatcher("/owner/houses.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取房屋列表失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/houses.jsp").forward(request, response);
        }
    }
} 