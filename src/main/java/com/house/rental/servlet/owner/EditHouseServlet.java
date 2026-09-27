package com.house.rental.servlet.owner;

import com.house.rental.bean.House;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.util.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/edit-house")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 10 * 1024 * 1024,  // 10 MB
    maxRequestSize = 20 * 1024 * 1024 // 20 MB
)
public class EditHouseServlet extends HttpServlet {
    private final HouseService houseService;
    private static final String UPLOAD_DIRECTORY = "uploads/houses";

    public EditHouseServlet() {
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
            // 获取房屋ID
            int houseId = Integer.parseInt(request.getParameter("id"));
            
            // 获取房屋信息
            House house = houseService.getHouseById(houseId);
            if (house == null || house.getOwnerId() != user.getReferenceId()) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
                return;
            }

            // 将房屋信息设置到请求属性中
            request.setAttribute("house", house);
            
            // 转发到编辑房屋页面
            request.getRequestDispatcher("/owner/edit-house.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/owner/houses");
        }
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
            // 获取表单数据
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            String title = request.getParameter("title");
            String address = request.getParameter("address");
            int size = Integer.parseInt(request.getParameter("size"));
            BigDecimal rentAmount = new BigDecimal(request.getParameter("rentAmount"));
            int bedrooms = Integer.parseInt(request.getParameter("bedrooms"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String decorate = request.getParameter("decorate");
            String floor = request.getParameter("floor");
            int bathrooms = Integer.parseInt(request.getParameter("bathrooms"));
            String rules = request.getParameter("rules");

            // 获取原有房屋信息
            House existingHouse = houseService.getHouseById(houseId);
            if (existingHouse == null || existingHouse.getOwnerId() != user.getReferenceId()) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
                return;
            }

            // 处理图片上传
            List<String> newImages = FileUploadUtil.uploadFiles(request, UPLOAD_DIRECTORY);
            List<String> existingImages = existingHouse.getImages();
            if (existingImages == null) {
                existingImages = new ArrayList<>();
            }
            // If new images are uploaded, add them to the existing list
            if (newImages != null && !newImages.isEmpty()) {
                existingImages.addAll(newImages);
            }
            
            // Optionally, handle removal of old images if checkbox/list of current images is provided in form
            // For simplicity, we are just adding new images here.

            // 更新房屋信息
            existingHouse.setTitle(title);
            existingHouse.setAddress(address);
            existingHouse.setSize(size);
            existingHouse.setRent(rentAmount);
            existingHouse.setBedrooms(bedrooms);
            existingHouse.setDescription(description);
            existingHouse.setStatus(status);
            existingHouse.setDecorate(decorate);
            existingHouse.setFloor(floor);
            existingHouse.setBathrooms(bathrooms);
            existingHouse.setRules(rules);
            existingHouse.setImages(existingImages);

            // 更新房屋
            boolean success = houseService.updateHouse(existingHouse);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
            } else {
                request.setAttribute("error", "更新房屋失败：请检查输入信息");
                request.setAttribute("house", existingHouse);
                request.getRequestDispatcher("/owner/edit-house.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新房屋失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/edit-house.jsp").forward(request, response);
        }
    }
} 