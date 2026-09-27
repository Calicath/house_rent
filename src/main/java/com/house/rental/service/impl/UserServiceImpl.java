package com.house.rental.service.impl;

import java.util.List;

import com.house.rental.bean.User;
import com.house.rental.dao.UserDAO;
import com.house.rental.dao.impl.UserDAOImpl;
import com.house.rental.service.UserService;

public class UserServiceImpl implements UserService {
    private final UserDAO userDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public void registerUser(User user) {
        // 检查用户名是否已存在
        if (isUsernameExists(user.getUsername())) {
            throw new RuntimeException("用户名已存在");
        }

        // 验证用户类型
        /*if (!isValidUserType(user.getType())) {
            throw new RuntimeException("无效的用户类型");
        }*/

        // 添加用户
        userDAO.addUser(user);
    }

    @Override
    public void updateUser(User user) {
        // 检查用户是否存在
        User existingUser = userDAO.getUserById(user.getUserId());
        if (existingUser == null) {
            throw new RuntimeException("用户不存在");
        }

        // 如果用户名已更改，检查新用户名是否已存在
        if (!existingUser.getUsername().equals(user.getUsername()) && 
            isUsernameExists(user.getUsername())) {
            throw new RuntimeException("用户名已存在");
        }

        // 更新用户
        userDAO.updateUser(user);
    }

    @Override
    public void deleteUser(int userId) {
        // 检查用户是否存在
        User user = userDAO.getUserById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 删除用户
        userDAO.deleteUser(userId);
    }

    @Override
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    @Override
    public User getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }

    @Override
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public User getUserByReferenceId(int referenceId, String type) {
        return userDAO.getUserByReferenceId(referenceId, type);
    }

    @Override
    public User login(String username, String password) {
        User user = userDAO.getUserByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userDAO.getUserByUsername(username) != null;
    }

    @Override
    public List<User> getUsersByType(String type) {
        return userDAO.getUsersByType(type);
    }

    @Override
    public List<User> searchUsers(String keyword, String type, String status, int page, int pageSize) {
        try {
            return userDAO.searchUsers(keyword, type, status, page, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null; // Or throw a custom exception
        }
    }

    @Override
    public int getTotalUsers(String keyword, String type, String status) {
        try {
            return userDAO.getTotalUsers(keyword, type, status);
        } catch (Exception e) {
            e.printStackTrace();
            return 0; // Or throw a custom exception
        }
    }

    private boolean isValidUserType(String type) {
        return "ADMIN".equals(type) || "OWNER".equals(type) || "TENANT".equals(type);
    }
} 