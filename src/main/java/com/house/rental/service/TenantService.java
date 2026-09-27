package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.Tenant;

public interface TenantService {
    /**
     * 添加租户
     * @param tenant 租户信息
     * @return 添加成功返回true，否则返回false
     */
    void addTenant(Tenant tenant) throws Exception;

    /**
     * 更新租户信息
     * @param tenant 租户信息
     * @return 更新成功返回true，否则返回false
     */
    void updateTenant(Tenant tenant) throws Exception;

    /**
     * 删除租户
     *
     * @param tenantId 租户ID
     * @return 删除成功返回true，否则返回false
     */
    boolean deleteTenant(int tenantId) throws Exception;

    /**
     * 根据ID获取租户信息
     * @param tenantId 租户ID
     * @return 租户对象，如果不存在返回null
     */
    Tenant getTenantById(int tenantId) throws Exception;

    /**
     * 获取所有租户列表
     * @return 租户列表
     */
    List<Tenant> getAllTenants() throws Exception;

    /**
     * 根据电话号码获取租户信息
     * @param phone 电话号码
     * @return 租户对象，如果不存在返回null
     */
    Tenant getTenantByPhone(String phone) throws Exception;

    /**
     * 根据身份证号获取租户信息
     * @param idCard 身份证号
     * @return 租户对象，如果不存在返回null
     */
    Tenant getTenantByIdCard(String idCard) throws Exception;

    
    // 根据用户ID获取租户
    Tenant getTenantByUserId(int userId) throws Exception;
    
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
    
    // 验证租户信息
    boolean validateTenant(Tenant tenant) throws Exception;
    
    // 检查租户状态
    boolean isTenantActive(int tenantId) throws Exception;
} 