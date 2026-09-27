package com.house.rental.service.impl;

import java.util.Date;
import java.util.List;

import com.house.rental.bean.Tenant;
import com.house.rental.bean.User;
import com.house.rental.dao.TenantDAO;
import com.house.rental.dao.UserDAO;
import com.house.rental.dao.impl.TenantDAOImpl;
import com.house.rental.dao.impl.UserDAOImpl;
import com.house.rental.service.TenantService;

public class TenantServiceImpl implements TenantService {
    private TenantDAO tenantDAO;
    private UserDAO userDAO;

    public TenantServiceImpl() {
        this.tenantDAO = new TenantDAOImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public void addTenant(Tenant tenant) throws Exception {
        // 验证租户信息
        if (!validateTenant(tenant)) {
            throw new Exception("租户信息验证失败");
        }

        // 检查用户是否存在
        User user = userDAO.getUserById(tenant.getUserId());
        if (user == null) {
            throw new Exception("用户不存在");
        }

        // 检查用户类型是否为租户
        if (!"TENANT".equals(user.getType())) {
            throw new Exception("用户类型不是租户");
        }

        // 检查是否已经是租户
        Tenant existingTenant = tenantDAO.getTenantByUserId(tenant.getUserId());
        if (existingTenant != null) {
            throw new Exception("该用户已经是租户");
        }

        // 设置默认状态
        tenant.setStatus("ACTIVE");

        // 添加租户
        tenantDAO.addTenant(tenant);
    }

    @Override
    public void updateTenant(Tenant tenant) throws Exception {
        // 验证租户信息
        if (!validateTenant(tenant)) {
            throw new Exception("租户信息验证失败");
        }

        // 检查租户是否存在
        Tenant existingTenant = tenantDAO.getTenantById(tenant.getTenantId());
        if (existingTenant == null) {
            throw new Exception("租户不存在");
        }

        // 更新租户信息
        tenantDAO.updateTenant(tenant);
    }

    @Override
    public boolean deleteTenant(int tenantId) throws Exception {
        // 检查租户是否存在
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            throw new Exception("租户不存在");
        }

        // 删除租户
        tenantDAO.deleteTenant(tenantId);
        return false;
    }

    @Override
    public Tenant getTenantById(int tenantId) throws Exception {
        return tenantDAO.getTenantById(tenantId);
    }

    @Override
    public Tenant getTenantByUserId(int userId) throws Exception {
        return tenantDAO.getTenantByUserId(userId);
    }

    @Override
    public Tenant getTenantByIdCard(String idCard) throws Exception {
        return tenantDAO.getTenantByIdCard(idCard);
    }

    @Override
    public List<Tenant> getAllTenants() throws Exception {
        return tenantDAO.getAllTenants();
    }

    @Override
    public List<Tenant> getTenantsByStatus(String status) throws Exception {
        return tenantDAO.getTenantsByStatus(status);
    }

    @Override
    public Tenant getTenantByPhone(String phone) throws Exception {
        // Note: TenantDAO does not have getTenantByPhone directly. Assuming UserDAO has it.
        // If TenantDAO needs this, it should be added there first.
        // For now, let's assume we can get user by phone and then get tenant by user id.
        User user = userDAO.getUserByPhone(phone);
        if (user != null) {
            return tenantDAO.getTenantByUserId(user.getUserId());
        }
        return null;
    }

    @Override
    public void updateTenantStatus(int tenantId, String status) throws Exception {
        // 检查租户是否存在
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            throw new Exception("租户不存在");
        }

        // 验证状态值
        if (!isValidStatus(status)) {
            throw new Exception("无效的状态值");
        }

        // 更新状态
        tenantDAO.updateTenantStatus(tenantId, status);
    }

    @Override
    public void updateMoveInDate(int tenantId, Date moveInDate) throws Exception {
        // 检查租户是否存在
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            throw new Exception("租户不存在");
        }

        // 更新入住日期
        tenantDAO.updateMoveInDate(tenantId, moveInDate);
    }

    @Override
    public void updateMoveOutDate(int tenantId, Date moveOutDate) throws Exception {
        // 检查租户是否存在
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            throw new Exception("租户不存在");
        }

        // 更新搬出日期
        tenantDAO.updateMoveOutDate(tenantId, moveOutDate);
    }

    @Override
    public List<Tenant> searchTenants(String keyword) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new Exception("搜索关键词不能为空");
        }
        return tenantDAO.searchTenants(keyword);
    }

    @Override
    public boolean validateTenant(Tenant tenant) throws Exception {
        if (tenant == null) {
            return false;
        }

        // 验证必填字段
        if (tenant.getUserId() <= 0 ||
            tenant.getIdCard() == null || tenant.getIdCard().trim().isEmpty() ||
            tenant.getGender() == null || tenant.getGender().trim().isEmpty()) {
            return false;
        }

        // 验证身份证号格式（简单验证）
        if (!tenant.getIdCard().matches("^\\d{17}[0-9X]$")) {
            return false;
        }

        // 验证性别
        if (!tenant.getGender().equals("M") && !tenant.getGender().equals("F")) {
            return false;
        }

        return true;
    }

    @Override
    public boolean isTenantActive(int tenantId) throws Exception {
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        return tenant != null && "ACTIVE".equals(tenant.getStatus());
    }

    private boolean isValidStatus(String status) {
        return status != null && (
            status.equals("ACTIVE") ||
            status.equals("INACTIVE") ||
            status.equals("BLOCKED")
        );
    }
} 