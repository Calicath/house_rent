package com.house.rental.servlet.owner;

import com.house.rental.bean.User;
import com.house.rental.bean.ViewingRecord;
import com.house.rental.bean.House;
import com.house.rental.service.ViewingRecordService;
import com.house.rental.service.HouseService;
import com.house.rental.service.impl.ViewingRecordServiceImpl;
import com.house.rental.service.impl.HouseServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/owner/update-viewing-status")
public class UpdateViewingStatusServlet extends HttpServlet {
    private ViewingRecordService viewingRecordService = new ViewingRecordServiceImpl();
    private HouseService houseService = new HouseServiceImpl();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 检查用户是否登录且是房主
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            if (!"OWNER".equals(user.getType())) {
                result.put("success", false);
                result.put("message", "只有房主可以处理看房申请");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 获取参数
            String recordIdStr = request.getParameter("recordId");
            String status = request.getParameter("status");

            // 验证参数
            if (recordIdStr == null || recordIdStr.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "参数不完整");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 验证状态值
            if (!"APPROVED".equals(status) && !"REJECTED".equals(status)) {
                result.put("success", false);
                result.put("message", "无效的状态值");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int recordId;
            try {
                recordId = Integer.parseInt(recordIdStr);
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "无效的记录ID");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 获取看房记录
            ViewingRecord record = viewingRecordService.getViewingRecordById(recordId);
            if (record == null) {
                result.put("success", false);
                result.put("message", "看房记录不存在");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 验证房主权限（只能处理自己房屋的看房申请）
            House house = houseService.getHouseById(record.getHouseId());
            if (house == null || house.getOwnerId() != user.getReferenceId()) {
                result.put("success", false);
                result.put("message", "您没有权限处理这个看房申请");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 检查记录状态
            if (!"PENDING".equals(record.getStatus())) {
                result.put("success", false);
                result.put("message", "该申请已经被处理过了");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // 更新状态
            record.setStatus(status);
            viewingRecordService.updateViewingRecord(record);

            // 返回成功响应
            result.put("success", true);
            result.put("message", status.equals("APPROVED") ? "已同意看房申请" : "已拒绝看房申请");
            
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "处理看房申请失败：" + e.getMessage());
            response.getWriter().write(gson.toJson(result));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET请求重定向到看房申请页面
        response.sendRedirect(request.getContextPath() + "/owner/viewing-requests");
    }
} 