package com.house.rental.bean;

import java.time.LocalDateTime;

public class ViewingRecord {
    private int recordId;
    private int houseId;
    private int tenantId;
    private LocalDateTime viewingTime;
    private String status; // PENDING, APPROVED, REJECTED
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 用于关联查询的字段
    private House house;
    private Tenant tenant;

    public ViewingRecord() {
    }

    public ViewingRecord(int houseId, int tenantId, LocalDateTime viewingTime, String status, String message) {
        this.houseId = houseId;
        this.tenantId = tenantId;
        this.viewingTime = viewingTime;
        this.status = status;
        this.message = message;
    }

    // Getters and Setters
    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public int getHouseId() {
        return houseId;
    }

    public void setHouseId(int houseId) {
        this.houseId = houseId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public LocalDateTime getViewingTime() {
        return viewingTime;
    }

    public void setViewingTime(LocalDateTime viewingTime) {
        this.viewingTime = viewingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public House getHouse() {
        return house;
    }

    public void setHouse(House house) {
        this.house = house;
    }

    public Tenant getTenant() {
        return tenant;
    }

    public void setTenant(Tenant tenant) {
        this.tenant = tenant;
    }
} 