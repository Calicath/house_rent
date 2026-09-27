package com.house.rental.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
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
import jakarta.servlet.http.Part;

@WebServlet("/admin/house/edit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,    // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class EditHouseServlet extends HttpServlet {
    private final HouseService houseService;
    private final Gson gson;

    public EditHouseServlet() {
        this.houseService = new HouseServiceImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取房屋ID
            int houseId = Integer.parseInt(request.getParameter("id"));
            
            // 获取房屋信息
            House house = houseService.getHouseById(houseId);
            if (house == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"房屋不存在\"}");
                return;
            }

            // 返回JSON格式的房屋信息
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(house));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是管理员
        if (user == null || !"admin".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String address = request.getParameter("address");
            BigDecimal rentAmount = new BigDecimal(request.getParameter("rent"));
            int type = Integer.parseInt(request.getParameter("type"));
            int size = Integer.parseInt(request.getParameter("size"));
            String decorate = request.getParameter("decorate");
            String floor = request.getParameter("floor");
            int bedrooms = Integer.parseInt(request.getParameter("bedrooms"));
            int bathrooms = Integer.parseInt(request.getParameter("bathrooms"));
            String rules = request.getParameter("rules");

            // 获取现有房屋信息
            House house = houseService.getHouseById(houseId);
            if (house == null) {
                throw new Exception("房屋不存在");
            }

            // 更新房屋信息
            house.setTitle(title);
            house.setDescription(description);
            house.setAddress(address);
            house.setRent(rentAmount);
            house.setType(type);
            house.setSize(size);
            house.setDecorate(decorate);
            house.setFloor(floor);
            house.setBedrooms(bedrooms);
            house.setBathrooms(bathrooms);
            house.setRules(rules);

            // 处理图片上传
            List<Part> imageParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    imageParts.add(part);
                }
            }

            if (!imageParts.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("/");
                List<String> imageUrls = FileUploadUtil.saveFiles(imageParts, uploadPath);
                house.setImages(imageUrls);
            }

            // 保存更新
            boolean success = houseService.updateHouse(house);

            if (success) {
                // 重定向到房屋列表页面
                response.sendRedirect(request.getContextPath() + "/admin/houses");
            } else {
                request.setAttribute("error", "更新房屋失败，请检查输入");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新房屋失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 