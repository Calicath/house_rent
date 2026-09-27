package com.house.rental.servlet.owner;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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
import jakarta.servlet.http.Part;

@WebServlet("/owner/update-house")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,    // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class UpdateHouseServlet extends HttpServlet {
    private final HouseService houseService;

    public UpdateHouseServlet() {
        this.houseService = new HouseServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int houseId = Integer.parseInt(request.getParameter("houseId"));
            House existingHouse = houseService.getHouseById(houseId);
            
            if (existingHouse == null || existingHouse.getOwnerId() != user.getReferenceId()) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
                return;
            }

            // 更新房屋信息
            existingHouse.setTitle(request.getParameter("title"));
            existingHouse.setDescription(request.getParameter("description"));
            existingHouse.setAddress(request.getParameter("address"));
            existingHouse.setRent(BigDecimal.valueOf(Integer.parseInt(request.getParameter("rent"))));
            existingHouse.setType(Integer.parseInt(request.getParameter("type")));
            existingHouse.setSize(Integer.parseInt(request.getParameter("size")));
            existingHouse.setDecorate(request.getParameter("decorate"));
            existingHouse.setFloor(request.getParameter("floor"));
            existingHouse.setBedrooms(Integer.parseInt(request.getParameter("bedrooms")));
            existingHouse.setBathrooms(Integer.parseInt(request.getParameter("bathrooms")));
            existingHouse.setRules(request.getParameter("rules"));

            // 处理图片上传
            List<Part> imageParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images")) {
                    imageParts.add(part);
                }
            }

            if (!imageParts.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("/");
                List<String> imageUrls = FileUploadUtil.saveFiles(imageParts, uploadPath);
                existingHouse.setImages(imageUrls);
            }

            // 更新房屋信息
            boolean success = houseService.updateHouse(existingHouse);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/owner/houses");
            } else {
                request.setAttribute("error", "更新房屋信息失败");
                request.getRequestDispatcher("/owner/update-house.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新房屋信息失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/update-house.jsp").forward(request, response);
        }
    }
} 