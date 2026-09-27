package com.house.rental.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.house.rental.bean.User;
import com.house.rental.bean.House;
import com.house.rental.bean.Owner;
import com.house.rental.service.HouseService;
import com.house.rental.service.OwnerService;
import com.house.rental.service.UserService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.OwnerServiceImpl;
import com.house.rental.service.impl.UserServiceImpl;

@WebServlet("/house/detail")
public class HouseDetailServlet extends HttpServlet {
    private HouseService houseService;
    private OwnerService ownerService;
    private UserService userService;

    public HouseDetailServlet() {
        this.houseService = new HouseServiceImpl();
        this.ownerService = new OwnerServiceImpl();
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // 获取房屋ID
            String houseIdStr = request.getParameter("id");
            if (houseIdStr == null || houseIdStr.trim().isEmpty()) {
                request.setAttribute("error", "房屋ID不能为空");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int houseId;
            try {
                houseId = Integer.parseInt(houseIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "无效的房屋ID");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 获取房屋信息
            House house = houseService.getHouseById(houseId);
            if (house == null) {
                request.setAttribute("error", "房屋不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 获取房主信息
            Owner owner = ownerService.getOwnerById(house.getOwnerId());
            if (owner == null) {
                request.setAttribute("error", "房主信息不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 获取房主的用户信息
            User ownerUser = userService.getUserById(owner.getUserId());
            if (ownerUser == null) {
                request.setAttribute("error", "房主用户信息不存在");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // 设置属性
            request.setAttribute("house", house);
            request.setAttribute("owner", owner);
            request.setAttribute("ownerUser", ownerUser);

            // 转发到JSP页面
            request.getRequestDispatcher("/house/detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取房屋详情失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST请求重定向到GET
        doGet(request, response);
    }
} 