package com.house.rental.service.impl;

import java.math.BigDecimal;
import java.util.List;

import com.house.rental.bean.House;
import com.house.rental.dao.HouseDAO;
import com.house.rental.dao.impl.HouseDAOImpl;
import com.house.rental.service.HouseService;

public class HouseServiceImpl implements HouseService {
    private final HouseDAO houseDAO;

    public HouseServiceImpl() {
        this.houseDAO = new HouseDAOImpl();
    }

    @Override
    public boolean addHouse(House house) {
        try {
            if (house.getTitle() == null || house.getTitle().trim().isEmpty()) {
                return false;
            }
            if (house.getAddress() == null || house.getAddress().trim().isEmpty()) {
                return false;
            }
            if (house.getSize() <= 0) {
                return false;
            }
            if (house.getRent() == null || house.getRent().compareTo(BigDecimal.ZERO) <= 0) {
                return false;
            }
            if (house.getBedrooms() < 0) {
                return false;
            }
            if (house.getBathrooms() < 0) {
                return false;
            }
            // images 可为空
            if (house.getStatus() == null || house.getStatus().trim().isEmpty()) {
                house.setStatus("AVAILABLE");
            }
            houseDAO.addHouse(house);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateHouse(House house) {
        try {
            // 验证房屋是否存在
            House existingHouse = houseDAO.getHouseById(house.getHouseId());
            if (existingHouse == null) {
                return false;
            }

            // 验证房屋信息
            if (house.getTitle() == null || house.getTitle().trim().isEmpty()) {
                return false;
            }
            if (house.getAddress() == null || house.getAddress().trim().isEmpty()) {
                return false;
            }
            if (house.getSize() <= 0) {
                return false;
            }
            if (house.getRent() == null || house.getRent().compareTo(BigDecimal.ZERO) <= 0) {
                return false;
            }
            if (house.getBedrooms() < 0) {
                return false;
            }
            if (house.getBathrooms() < 0) {
                return false;
            }

            houseDAO.updateHouse(house);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteHouse(int houseId) {
        try {
            // 验证房屋是否存在
            if (houseDAO.getHouseById(houseId) == null) {
                return false;
            }

            houseDAO.deleteHouse(houseId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public House getHouseById(int houseId) {
        try {
            return houseDAO.getHouseById(houseId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> getAllHouses() {
        try {
            return houseDAO.getAllHouses();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> getHousesByOwnerId(int ownerId) {
        try {
            return houseDAO.getHousesByOwnerId(ownerId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> getHousesByStatus(String status) {
        try {
            return houseDAO.getHousesByStatus(status);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> searchHouses(String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return houseDAO.getAllHouses();
            }
            return houseDAO.searchHouses(keyword.trim());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> searchHouses(String keyword, String status, String rooms, String minPrice, String maxPrice, int page, int pageSize) {
        try {
            return houseDAO.searchHouses(keyword, status, rooms, minPrice, maxPrice, page, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public int getTotalHouses(String keyword, String status, String rooms, String minPrice, String maxPrice) {
        try {
            return houseDAO.getTotalHouses(keyword, status, rooms, minPrice, maxPrice);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public boolean updateHouseStatus(int houseId, String status) {
        try {
            // 验证房屋是否存在
            if (houseDAO.getHouseById(houseId) == null) {
                return false;
            }

            // 验证状态是否有效
            if (!isValidStatus(status)) {
                return false;
            }

            houseDAO.updateHouseStatus(houseId, status);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<House> getAvailableHouses() {
        try {
            return houseDAO.getHousesByStatus("AVAILABLE");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<House> getRentedHouses() {
        try {
            return houseDAO.getHousesByStatus("RENTED");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean isOwnerHouse(int ownerId, int houseId) {
        House house = houseDAO.getHouseById(houseId);
        return house != null && house.getOwnerId() == ownerId;
    }

    private boolean isValidStatus(String status) {
        return status != null && (status.equals("AVAILABLE") || status.equals("RENTED") || status.equals("PENDING"));
    }
} 