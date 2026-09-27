package com.house.rental.servlet.owner;
import java.io.IOException;

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

@WebServlet("/owner/delete-house")
public class DeleteHouseServlet extends HttpServlet {
    private final HouseService houseService;

    public DeleteHouseServlet() {
        this.houseService = new HouseServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否已登录且是房东
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取房屋ID
            int houseId = Integer.parseInt(request.getParameter("id"));
            
            // 获取房屋信息
            House house = houseService.getHouseById(houseId);
            if (house == null || house.getOwnerId() != user.getReferenceId()) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
                return;
            }

            // 删除房屋
            boolean success = houseService.deleteHouse(houseId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
            } else {
                request.setAttribute("error", "删除房屋失败");
                request.getRequestDispatcher("/owner/houses").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除房屋失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/houses").forward(request, response);
        }
    }
} 