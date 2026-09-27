package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.User;

public interface UserService {
    void registerUser(User user);
    void updateUser(User user);
    void deleteUser(int userId);
    User getUserById(int userId);
    User getUserByUsername(String username);
    List<User> getAllUsers();
    User getUserByReferenceId(int referenceId, String type);
    User login(String username, String password);
    boolean isUsernameExists(String username);
    List<User> getUsersByType(String type);
    List<User> searchUsers(String keyword, String type, String status, int page, int pageSize);
    int getTotalUsers(String keyword, String type, String status);
} 