package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.Owner;

public interface OwnerService {
    void addOwner(Owner owner);
    void updateOwner(Owner owner);
    void deleteOwner(int ownerId);
    Owner getOwnerById(int ownerId);
    List<Owner> getAllOwners();
    Owner getOwnerByPhone(String phone);
} 