package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.Owner;

public interface OwnerDAO {
    void addOwner(Owner owner);
    void updateOwner(Owner owner);
    void deleteOwner(int ownerId);
    Owner getOwnerById(int ownerId);
    Owner getOwnerByUserId(int userId);
    List<Owner> getAllOwners();
    Owner getOwnerByPhone(String phone);
} 