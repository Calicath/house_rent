package com.house.rental.bean;

public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String type; // ADMIN, OWNER, TENANT
    private String status;
    private int referenceId; // 关联的owner_id或tenant_id
    private String idCard; // Add idCard field
    private String gender; // Add gender field
    private String address; // Add address field
    private String phone; // Add phone field

    public User() {
    }

    public User(String username, String password, String email, String type, String status, int referenceId) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.type = type;
        this.status = status;
        this.referenceId = referenceId;
    }

    public User(String username, String password, String email, String type, String status, int referenceId, String idCard, String gender) {
        this(username, password, email, type, status, referenceId);
        this.idCard = idCard;
        this.gender = gender;
    }

    public User(int userId, String username, String password, String email, String type, String status, int referenceId, String idCard, String gender, String address, String phone) {
        this(username, password, email, type, status, referenceId, idCard, gender);
        this.userId = userId;
        this.address = address;
        this.phone = phone;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }
    public String getUserType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(int referenceId) {
        this.referenceId = referenceId;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
} 