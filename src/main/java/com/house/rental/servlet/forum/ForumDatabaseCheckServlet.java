package com.house.rental.servlet.forum;

import com.house.rental.bean.ForumPost;
import com.house.rental.service.ForumPostService;
import com.house.rental.service.impl.ForumPostServiceImpl;
import com.house.rental.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/forum-db-check")
public class ForumDatabaseCheckServlet extends HttpServlet {
    private ForumPostService forumPostService = new ForumPostServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        
        try {
            switch (action) {
                case "check_tables":
                    result = checkTables();
                    break;
                case "get_stats":
                    result = getStats();
                    break;
                case "get_latest_posts":
                    result = getLatestPosts();
                    break;
                default:
                    result.put("error", "未知操作");
            }
        } catch (Exception e) {
            result.put("error", e.getMessage());
            e.printStackTrace();
        }
        
        // 将结果转换为JSON并返回
        response.getWriter().write(convertToJson(result));
    }
    
    private Map<String, Object> checkTables() {
        Map<String, Object> result = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            
            // 检查forum_posts表
            ResultSet postsTable = metaData.getTables(null, null, "forum_posts", null);
            result.put("forum_posts_exists", postsTable.next());
            
            // 检查forum_comments表
            ResultSet commentsTable = metaData.getTables(null, null, "forum_comments", null);
            result.put("forum_comments_exists", commentsTable.next());
            
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    private Map<String, Object> getStats() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int totalPosts = forumPostService.getForumPostCount();
            result.put("totalPosts", totalPosts);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    private Map<String, Object> getLatestPosts() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<ForumPost> posts = forumPostService.getAllForumPosts(1, 5);
            result.put("posts", posts);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    private String convertToJson(Map<String, Object> data) {
        StringBuilder json = new StringBuilder("{");
        boolean first = true;
        
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            if (!first) {
                json.append(",");
            }
            first = false;
            
            json.append("\"").append(entry.getKey()).append("\":");
            
            if (entry.getValue() instanceof String) {
                json.append("\"").append(entry.getValue()).append("\"");
            } else if (entry.getValue() instanceof Boolean || entry.getValue() instanceof Number) {
                json.append(entry.getValue());
            } else {
                json.append("\"").append(entry.getValue()).append("\"");
            }
        }
        
        json.append("}");
        return json.toString();
    }
} 