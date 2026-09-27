package com.house.rental.service.impl;

import java.util.List;

import com.house.rental.bean.Owner;
import com.house.rental.dao.OwnerDAO;
import com.house.rental.dao.impl.OwnerDAOImpl;
import com.house.rental.service.OwnerService;

public class OwnerServiceImpl implements OwnerService {
    private final OwnerDAO ownerDAO;

    public OwnerServiceImpl() {
        this.ownerDAO = new OwnerDAOImpl();
    }

    @Override
    public void addOwner(Owner owner) {
        // 检查电话号码是否已存在
        if (ownerDAO.getOwnerByPhone(owner.getPhone()) != null) {
            throw new RuntimeException("该电话号码已被注册");
        }
        ownerDAO.addOwner(owner);
    }

    @Override
    public void updateOwner(Owner owner) {
        Owner existingOwner = ownerDAO.getOwnerById(owner.getOwnerId());
        if (existingOwner == null) {
            throw new RuntimeException("房主不存在");
        }
        ownerDAO.updateOwner(owner);
    }

    @Override
    public void deleteOwner(int ownerId) {
        Owner owner = ownerDAO.getOwnerById(ownerId);
        if (owner == null) {
            throw new RuntimeException("房主不存在");
        }
        ownerDAO.deleteOwner(ownerId);
    }

    @Override
    public Owner getOwnerById(int ownerId) {
        return ownerDAO.getOwnerById(ownerId);
    }

    @Override
    public List<Owner> getAllOwners() {
        return ownerDAO.getAllOwners();
    }

    @Override
    public Owner getOwnerByPhone(String phone) {
        return ownerDAO.getOwnerByPhone(phone);
    }
} 