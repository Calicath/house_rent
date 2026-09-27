package com.house.rental.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.house.rental.bean.House;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/house/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AddHouseServlet extends HttpServlet {
    private HouseService houseService;
    private static final String UPLOAD_DIRECTORY = "uploads/houses";

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
            // 获取表单数据
            String title = request.getParameter("title");
            String address = request.getParameter("address");
            int size = Integer.parseInt(request.getParameter("size"));
            int bedrooms = Integer.parseInt(request.getParameter("bedrooms"));
            BigDecimal rentAmount = new BigDecimal(request.getParameter("rentAmount"));
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String decorate = request.getParameter("decorate");
            String floor = request.getParameter("floor");
            int bathrooms = Integer.parseInt(request.getParameter("bathrooms"));
            String rules = request.getParameter("rules");

            // 处理图片上传
            List<String> imageUrls = FileUploadUtil.uploadFiles(request, UPLOAD_DIRECTORY);

            // 创建房屋对象
            House house = new House();
            house.setTitle(title);
            house.setAddress(address);
            house.setSize(size);
            house.setBedrooms(bedrooms);
            house.setRent(rentAmount);
            house.setOwnerId(ownerId);
            house.setStatus(status);
            house.setDescription(description);
            house.setDecorate(decorate);
            house.setFloor(floor);
            house.setBathrooms(bathrooms);
            house.setRules(rules);
            house.setImages(imageUrls);

            // 保存房屋
            boolean success = houseService.addHouse(house);

            if (success) {
                // 重定向到房屋列表页面
                response.sendRedirect(request.getContextPath() + "/admin/houses");
            } else {
                request.setAttribute("error", "添加房屋失败，请检查输入");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加房屋失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 