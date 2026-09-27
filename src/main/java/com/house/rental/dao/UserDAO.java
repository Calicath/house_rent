package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.User;

public interface UserDAO {
    void addUser(User user);
    void updateUser(User user);
    void deleteUser(int userId);
    User getUserById(int userId);
    User getUserByUsername(String username);
    List<User> getAllUsers();
    User getUserByReferenceId(int referenceId, String type);
    User login(String username, String password);
    boolean isUsernameExists(String username);
    List<User> getUsersByType(String type);
    List<User> searchUsers(String keyword, String type, String status, int page, int pageSize) throws Exception;
    int getTotalUsers(String keyword, String type, String status) throws Exception;
    User getUserByPhone(String phone);
} 