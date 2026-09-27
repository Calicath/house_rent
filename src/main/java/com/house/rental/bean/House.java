package com.house.rental.bean;

import java.util.List;
import java.math.BigDecimal;

public class House {
    private int houseId;
    private int ownerId;
    private String title;
    private String description;
    private String address;
    private BigDecimal rent;
    private String status;
    private int type;
    private int size;
    private String decorate;
    private String floor;
    private int bedrooms;
    private int bathrooms;
    private List<String> images;
    private String rules;

    public House() {}

    public House(int houseId, int ownerId, String title, String description, String address, 
                BigDecimal rent, String status, int type, int size, String decorate, String floor,
                int bedrooms, int bathrooms, List<String> images, String rules) {
        this.houseId = houseId;
        this.ownerId = ownerId;
        this.title = title;
        this.description = description;
        this.address = address;
        this.rent = rent;
        this.status = status;
        this.type = type;
        this.size = size;
        this.decorate = decorate;
        this.floor = floor;
        this.bedrooms = bedrooms;
        this.bathrooms = bathrooms;
        this.images = images;
        this.rules = rules;
    }

    // Getters and Setters
    public int getHouseId() {
        return houseId;
    }

    public void setHouseId(int houseId) {
        this.houseId = houseId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigDecimal getRent() {
        return rent;
    }

    public void setRent(BigDecimal rent) {
        this.rent = rent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getDecorate() {
        return decorate;
    }

    public void setDecorate(String decorate) {
        this.decorate = decorate;
    }

    public String getFloor() {
        return floor;
    }

    public void setFloor(String floor) {
        this.floor = floor;
    }

    public int getBedrooms() {
        return bedrooms;
    }

    public void setBedrooms(int bedrooms) {
        this.bedrooms = bedrooms;
    }

    public int getBathrooms() {
        return bathrooms;
    }

    public void setBathrooms(int bathrooms) {
        this.bathrooms = bathrooms;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public String getRules() {
        return rules;
    }

    public void setRules(String rules) {
        this.rules = rules;
    }
} 