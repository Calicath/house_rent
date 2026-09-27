package com.house.rental.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.house.rental.bean.User;
import com.house.rental.bean.House;
import com.house.rental.service.UserService;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.UserServiceImpl;
import com.house.rental.service.impl.HouseServiceImpl;

@WebServlet("/admin/houses")
public class HouseManagementServlet extends HttpServlet {
    private UserService userService;
    private HouseService houseService;
    private static final int PAGE_SIZE = 12;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        houseService = new HouseServiceImpl();
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
            String rooms = request.getParameter("rooms");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // 使用默认值1
            }

            // 获取房屋列表
            List<House> houses = houseService.searchHouses(keyword, status, rooms, minPrice, maxPrice, page, PAGE_SIZE);
            int totalHouses = houseService.getTotalHouses(keyword, status, rooms, minPrice, maxPrice);
            int totalPages = (int) Math.ceil((double) totalHouses / PAGE_SIZE);

            // 获取所有房主（用于添加/编辑房屋时的选择）
            List<User> owners = userService.getUsersByType("OWNER");

            // 设置属性
            request.setAttribute("houses", houses);
            request.setAttribute("owners", owners);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalHouses", totalHouses);

            // 转发到JSP页面
            request.getRequestDispatcher("/admin/houses.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取房屋列表失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 