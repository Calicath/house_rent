package com.house.rental.servlet.owner;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import com.house.rental.bean.House;
import com.house.rental.bean.User;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.HouseServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/owner/add-house")
public class AddHouseServlet extends HttpServlet {
    private HouseService houseService = new HouseServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 转发到添加房屋的JSP页面
        request.getRequestDispatcher("/owner/add-house.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 获取表单参数 - 使用和用户注册相同的简单方式
            String title = request.getParameter("title");
            String address = request.getParameter("address");
            String areaStr = request.getParameter("area");
            String priceStr = request.getParameter("price");
            String bedroomsStr = request.getParameter("bedrooms");
            String bathroomsStr = request.getParameter("bathrooms");
            String description = request.getParameter("description");
            String decorate = request.getParameter("decorate");
            String floor = request.getParameter("floor");
            String typeStr = request.getParameter("type");
            String rules = request.getParameter("rules");

            // 调试信息
            System.out.println("=== 房屋添加参数 ===");
            System.out.println("title: [" + title + "]");
            System.out.println("address: [" + address + "]");
            System.out.println("area: [" + areaStr + "]");
            System.out.println("price: [" + priceStr + "]");
            System.out.println("type: [" + typeStr + "]");
            System.out.println("bedrooms: [" + bedroomsStr + "]");
            System.out.println("bathrooms: [" + bathroomsStr + "]");
            System.out.println("=====================");

            // 验证必填字段
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("房屋标题不能为空");
            }
            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("房屋地址不能为空");
            }
            if (areaStr == null || areaStr.trim().isEmpty()) {
                throw new IllegalArgumentException("房屋面积不能为空");
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("租金不能为空");
            }
            if (bedroomsStr == null || bedroomsStr.trim().isEmpty()) {
                throw new IllegalArgumentException("卧室数量不能为空");
            }
            if (bathroomsStr == null || bathroomsStr.trim().isEmpty()) {
                throw new IllegalArgumentException("卫生间数量不能为空");
            }
            if (typeStr == null || typeStr.trim().isEmpty()) {
                throw new IllegalArgumentException("房屋类型不能为空");
            }

            // 转换数值类型
            int size = Integer.parseInt(areaStr.trim());
            BigDecimal rent = new BigDecimal(priceStr.trim());
            int bedrooms = Integer.parseInt(bedroomsStr.trim());
            int bathrooms = Integer.parseInt(bathroomsStr.trim());
            int type = Integer.parseInt(typeStr.trim());

            // 验证数值范围
            if (size <= 0) {
                throw new IllegalArgumentException("房屋面积必须大于0");
            }
            if (rent.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("租金必须大于0");
            }
            if (bedrooms < 0) {
                throw new IllegalArgumentException("卧室数量不能为负数");
            }
            if (bathrooms < 0) {
                throw new IllegalArgumentException("卫生间数量不能为负数");
            }

            // 创建房屋对象
            House house = new House();
            house.setTitle(title.trim());
            house.setAddress(address.trim());
            house.setSize(size);
            house.setRent(rent);
            house.setBedrooms(bedrooms);
            house.setBathrooms(bathrooms);
            house.setDescription(description != null ? description.trim() : "");
            house.setDecorate(decorate != null ? decorate.trim() : "");
            house.setFloor(floor != null ? floor.trim() : "");
            house.setType(type);
            house.setRules(rules != null ? rules.trim() : "");
            house.setImages(new ArrayList<>()); // 空图片列表
            house.setOwnerId(user.getReferenceId());
            house.setStatus("AVAILABLE");

            // 添加房屋
            boolean success = houseService.addHouse(house);
            if (success) {
                System.out.println("房屋添加成功: " + title);
                response.sendRedirect(request.getContextPath() + "/owner/houses");
            } else {
                System.out.println("房屋添加失败");
                request.setAttribute("error", "添加房屋失败，请检查信息是否完整且有效。");
                // 失败时回显已填写内容
                request.setAttribute("title", title);
                request.setAttribute("address", address);
                request.setAttribute("area", size);
                request.setAttribute("price", rent);
                request.setAttribute("bedrooms", bedrooms);
                request.setAttribute("bathrooms", bathrooms);
                request.setAttribute("description", description);
                request.setAttribute("decorate", decorate);
                request.setAttribute("floor", floor);
                request.setAttribute("type", type);
                request.setAttribute("rules", rules);
                request.getRequestDispatcher("/owner/add-house.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "数值格式错误：" + e.getMessage());
            // 失败时回显已填写内容
            request.setAttribute("title", request.getParameter("title"));
            request.setAttribute("address", request.getParameter("address"));
            request.setAttribute("area", request.getParameter("area"));
            request.setAttribute("price", request.getParameter("price"));
            request.setAttribute("bedrooms", request.getParameter("bedrooms"));
            request.setAttribute("bathrooms", request.getParameter("bathrooms"));
            request.setAttribute("type", request.getParameter("type"));
            request.setAttribute("description", request.getParameter("description"));
            request.setAttribute("decorate", request.getParameter("decorate"));
            request.setAttribute("floor", request.getParameter("floor"));
            request.setAttribute("rules", request.getParameter("rules"));
            request.getRequestDispatcher("/owner/add-house.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("error", "输入验证失败：" + e.getMessage());
            // 失败时回显已填写内容
            request.setAttribute("title", request.getParameter("title"));
            request.setAttribute("address", request.getParameter("address"));
            request.setAttribute("area", request.getParameter("area"));
            request.setAttribute("price", request.getParameter("price"));
            request.setAttribute("bedrooms", request.getParameter("bedrooms"));
            request.setAttribute("bathrooms", request.getParameter("bathrooms"));
            request.setAttribute("type", request.getParameter("type"));
            request.setAttribute("description", request.getParameter("description"));
            request.setAttribute("decorate", request.getParameter("decorate"));
            request.setAttribute("floor", request.getParameter("floor"));
            request.setAttribute("rules", request.getParameter("rules"));
            request.getRequestDispatcher("/owner/add-house.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加房屋失败：" + e.getMessage());
            // 失败时回显已填写内容
            request.setAttribute("title", request.getParameter("title"));
            request.setAttribute("address", request.getParameter("address"));
            request.setAttribute("area", request.getParameter("area"));
            request.setAttribute("price", request.getParameter("price"));
            request.setAttribute("bedrooms", request.getParameter("bedrooms"));
            request.setAttribute("bathrooms", request.getParameter("bathrooms"));
            request.setAttribute("type", request.getParameter("type"));
            request.setAttribute("description", request.getParameter("description"));
            request.setAttribute("decorate", request.getParameter("decorate"));
            request.setAttribute("floor", request.getParameter("floor"));
            request.setAttribute("rules", request.getParameter("rules"));
            request.getRequestDispatcher("/owner/add-house.jsp").forward(request, response);
        }
    }
} 