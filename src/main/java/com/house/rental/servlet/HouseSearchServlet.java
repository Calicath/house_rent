package com.house.rental.servlet;

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
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;

@WebServlet("/house/search")
public class HouseSearchServlet extends HttpServlet {
    private HouseService houseService;

    public HouseSearchServlet() {
        this.houseService = new HouseServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // 获取搜索参数
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            String rooms = request.getParameter("rooms");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String pageStr = request.getParameter("page");
            
            // 设置默认值
            int page = 1;
            int pageSize = 12; // 每页显示12套房屋
            
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // 执行搜索
            List<House> houses = houseService.searchHouses(keyword, status, rooms, minPrice, maxPrice, page, pageSize);
            int totalHouses = houseService.getTotalHouses(keyword, status, rooms, minPrice, maxPrice);
            int totalPages = (int) Math.ceil((double) totalHouses / pageSize);

            // 设置属性
            request.setAttribute("houses", houses);
            request.setAttribute("totalHouses", totalHouses);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);

            // 转发到JSP页面
            request.getRequestDispatcher("/house/search.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "搜索失败：" + e.getMessage());
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