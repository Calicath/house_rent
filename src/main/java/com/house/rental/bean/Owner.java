package com.house.rental.bean;

public class Owner {
    private int ownerId;
    private int userId;
    private String name;
    private String address;
    private String phone;

    public Owner() {}

    public Owner(String name, String address, String phone) {
        this.name = name;
        this.address = address;
        this.phone = phone;
    }

    public Owner(int ownerId, String name, String address, String phone) {
        this.ownerId = ownerId;
        this.name = name;
        this.address = address;
        this.phone = phone;
    }

    // Getters and Setters
    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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