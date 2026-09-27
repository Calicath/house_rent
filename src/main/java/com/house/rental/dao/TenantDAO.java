package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.Tenant;

public interface TenantDAO {
    // 添加租户
    void addTenant(Tenant tenant) throws Exception;
    
    // 更新租户信息
    void updateTenant(Tenant tenant) throws Exception;
    
    // 删除租户
    void deleteTenant(int tenantId) throws Exception;
    
    // 根据ID获取租户
    Tenant getTenantById(int tenantId) throws Exception;
    
    // 根据用户ID获取租户
    Tenant getTenantByUserId(int userId) throws Exception;
    
    // 获取所有租户
    List<Tenant> getAllTenants() throws Exception;
    
    // 根据状态获取租户列表
    List<Tenant> getTenantsByStatus(String status) throws Exception;
    
    // 更新租户状态
    void updateTenantStatus(int tenantId, String status) throws Exception;
    
    // 更新租户入住日期
    void updateMoveInDate(int tenantId, java.util.Date moveInDate) throws Exception;
    
    // 更新租户搬出日期
    void updateMoveOutDate(int tenantId, java.util.Date moveOutDate) throws Exception;
    
    // 搜索租户
    List<Tenant> searchTenants(String keyword) throws Exception;

    // 根据身份证号获取租户信息
    Tenant getTenantByIdCard(String idCard) throws Exception;
} 