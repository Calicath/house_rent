package com.house.rental.servlet.owner;

import java.io.IOException;

import com.house.rental.bean.House;
import com.house.rental.bean.User;
import com.house.rental.bean.ViewingRecord;
import com.house.rental.service.HouseService;
import com.house.rental.service.ViewingRecordService;
import com.house.rental.service.impl.HouseServiceImpl;
import com.house.rental.service.impl.ViewingRecordServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/owner/process-viewing")
public class ProcessViewingRequestServlet extends HttpServlet {
    private final ViewingRecordService viewingRecordService;
    private final HouseService houseService;

    public ProcessViewingRequestServlet() {
        this.viewingRecordService = new ViewingRecordServiceImpl();
        this.houseService = new HouseServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查用户是否登录且是房主
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 获取表单数据
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            String action = request.getParameter("action"); // "approve" 或 "reject"
            String message = request.getParameter("message");

            // 获取看房记录
            ViewingRecord record = viewingRecordService.getViewingRecordById(recordId);
            if (record == null) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                return;
            }

            // 验证房主是否有权限处理该请求
            House house = houseService.getHouseById(record.getHouseId());
            if (house == null || house.getOwnerId() != user.getReferenceId()) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                return;
            }

            // 更新看房请求状态
            record.setStatus("APPROVED".equals(action) ? "APPROVED" : "REJECTED");
            record.setMessage(message);
            viewingRecordService.updateViewingRecord(record);

            // 重定向到房主仪表板
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "处理看房请求失败：" + e.getMessage());
            request.getRequestDispatcher("/owner/dashboard").forward(request, response);
        }
    }
} 