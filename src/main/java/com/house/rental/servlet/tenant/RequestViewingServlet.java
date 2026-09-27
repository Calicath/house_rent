package com.house.rental.servlet.tenant;

import com.house.rental.bean.User;
import com.house.rental.bean.ViewingRecord;
import com.house.rental.bean.Tenant;
import com.house.rental.service.HouseService;
import com.house.rental.service.ViewingRecordService;
import com.house.rental.service.TenantService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.ViewingRecordServiceImpl;
import com.house.rental.service.impl.TenantServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/tenant/request-viewing")
public class RequestViewingServlet extends HttpServlet {
    private ViewingRecordService viewingRecordService = new ViewingRecordServiceImpl();
    private HouseService houseService = new HouseServiceImpl();
    private TenantService tenantService = new TenantServiceImpl();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET请求重定向到房屋详情页面
        String houseId = request.getParameter("houseId");
        if (houseId != null) {
            response.sendRedirect(request.getContextPath() + "/house/detail?id=" + houseId);
        } else {
            response.sendRedirect(request.getContextPath() + "/house/search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查用户是否登录且是租户
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            if (!"TENANT".equals(user.getType())) {
                result.put("success", false);
                result.put("message", "只有租客可以申请看房");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 获取表单数据
            String houseIdStr = request.getParameter("houseId");
            String viewingDateStr = request.getParameter("viewingDate");
            String viewingTimeStr = request.getParameter("viewingTime");
            String message = request.getParameter("message");

            // 调试信息：打印接收到的参数
            System.out.println("接收到的参数：");
            System.out.println("houseId: " + houseIdStr);
            System.out.println("viewingDate: " + viewingDateStr);
            System.out.println("viewingTime: " + viewingTimeStr);
            System.out.println("message: " + message);

            // 验证必填字段
            if (houseIdStr == null || houseIdStr.trim().isEmpty() ||
                viewingDateStr == null || viewingDateStr.trim().isEmpty() ||
                viewingTimeStr == null || viewingTimeStr.trim().isEmpty()) {
                System.out.println("参数验证失败：必填字段为空");
                result.put("success", false);
                result.put("message", "请填写完整的看房信息");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int houseId;
            try {
                houseId = Integer.parseInt(houseIdStr);
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "无效的房屋ID");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 验证房屋是否存在且可租
            com.house.rental.bean.House house = houseService.getHouseById(houseId);
            if (house == null) {
                result.put("success", false);
                result.put("message", "房屋不存在");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (!"AVAILABLE".equals(house.getStatus())) {
                result.put("success", false);
                result.put("message", "该房屋当前不可预约看房");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 验证看房日期（不能是过去的日期）
            LocalDate viewingDate = LocalDate.parse(viewingDateStr);
            LocalDate today = LocalDate.now();
            if (viewingDate.isBefore(today)) {
                result.put("success", false);
                result.put("message", "看房日期不能是过去的日期");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 解析看房时间
            LocalTime viewingTime = LocalTime.parse(viewingTimeStr);
            LocalDateTime viewingDateTime = LocalDateTime.of(viewingDate, viewingTime);

            // 获取租客信息
            Tenant tenant = tenantService.getTenantByUserId(user.getUserId());
            if (tenant == null) {
                result.put("success", false);
                result.put("message", "租客信息不存在");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 检查是否已经申请过看房
            // 这里可以添加检查逻辑，避免重复申请

            // 创建看房记录
            ViewingRecord record = new ViewingRecord();
            record.setHouseId(houseId);
            record.setTenantId(tenant.getTenantId());
            record.setViewingTime(viewingDateTime);
            record.setMessage(message != null ? message : "");
            record.setStatus("PENDING"); // 初始状态为待处理

            // 保存看房记录
            viewingRecordService.addViewingRecord(record);

            // 返回成功响应
            result.put("success", true);
            result.put("message", "看房申请提交成功！房主会在24小时内回复您。");
            result.put("recordId", record.getRecordId());
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "申请看房失败：" + e.getMessage());
            response.getWriter().write(gson.toJson(result));
        }
    }
} 