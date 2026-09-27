package com.house.rental.servlet.owner;

import com.house.rental.bean.User;
import com.house.rental.bean.ViewingRecord;
import com.house.rental.service.ViewingRecordService;
import com.house.rental.service.impl.ViewingRecordServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/owner/viewing-requests")
public class ViewingRequestsServlet extends HttpServlet {
    private ViewingRecordService viewingRecordService = new ViewingRecordServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录且是房主
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"OWNER".equals(user.getType())) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        try {
            // 添加调试信息
            System.out.println("=== ViewingRequestsServlet 优化版本调试信息 ===");
            System.out.println("用户ID: " + user.getUserId());
            System.out.println("用户名: " + user.getUsername());
            System.out.println("用户类型: " + user.getType());
            System.out.println("Reference ID: " + user.getReferenceId());

            // 使用优化的查询方法：一次性获取房主的所有看房申请及相关信息
            List<ViewingRecord> viewingRecords = viewingRecordService.getViewingRecordsWithDetailsByOwnerId(user.getReferenceId());
            
            System.out.println("找到看房记录数量: " + (viewingRecords != null ? viewingRecords.size() : "null"));

            if (viewingRecords != null && !viewingRecords.isEmpty()) {
                System.out.println("看房记录详情:");
                for (ViewingRecord record : viewingRecords) {
                    System.out.println("  - 记录ID: " + record.getRecordId());
                    System.out.println("    房屋: " + (record.getHouse() != null ? record.getHouse().getTitle() : "null"));
                    System.out.println("    租客: " + (record.getTenant() != null && record.getTenant().getUser() != null ? 
                        record.getTenant().getUser().getUsername() : "null"));
                    System.out.println("    状态: " + record.getStatus());
                    System.out.println("    看房时间: " + record.getViewingTime());
                }
            } else {
                System.out.println("房主没有看房申请");
            }

            request.setAttribute("viewingRecords", viewingRecords);
            request.setAttribute("totalRequests", viewingRecords != null ? viewingRecords.size() : 0);
            
            // 统计不同状态的申请数量
            if (viewingRecords != null) {
                long pendingCount = viewingRecords.stream()
                        .filter(r -> "PENDING".equals(r.getStatus()))
                        .count();
                long approvedCount = viewingRecords.stream()
                        .filter(r -> "APPROVED".equals(r.getStatus()))
                        .count();
                long rejectedCount = viewingRecords.stream()
                        .filter(r -> "REJECTED".equals(r.getStatus()))
                        .count();

                System.out.println("状态统计 - 待处理: " + pendingCount + ", 已同意: " + approvedCount + ", 已拒绝: " + rejectedCount);

                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("approvedCount", approvedCount);
                request.setAttribute("rejectedCount", rejectedCount);
            } else {
                request.setAttribute("pendingCount", 0);
                request.setAttribute("approvedCount", 0);
                request.setAttribute("rejectedCount", 0);
            }

            System.out.println("=== 优化版本调试信息结束 ===");

            request.getRequestDispatcher("/owner/viewing-requests.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("ViewingRequestsServlet 发生异常:");
            e.printStackTrace();
            request.setAttribute("error", "获取看房申请失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 