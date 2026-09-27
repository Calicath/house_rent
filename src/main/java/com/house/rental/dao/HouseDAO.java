package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.House;

public interface HouseDAO {
    /**
     * 添加房屋
     * @param house 房屋信息
     */
    void addHouse(House house);

    /**
     * 更新房屋信息
     * @param house 房屋信息
     */
    void updateHouse(House house);

    /**
     * 删除房屋
     * @param houseId 房屋ID
     */
    void deleteHouse(int houseId);

    /**
     * 根据ID获取房屋信息
     * @param houseId 房屋ID
     * @return 房屋对象
     */
    House getHouseById(int houseId);

    /**
     * 获取所有房屋列表
     * @return 房屋列表
     */
    List<House> getAllHouses();

    /**
     * 根据房东ID获取房屋列表
     * @param ownerId 房东ID
     * @return 房屋列表
     */
    List<House> getHousesByOwnerId(int ownerId);

    /**
     * 根据状态获取房屋列表
     * @param status 房屋状态
     * @return 房屋列表
     */
    List<House> getHousesByStatus(String status);

    /**
     * 搜索房屋
     * @param keyword 关键词（标题或地址）
     * @return 房屋列表
     */
    List<House> searchHouses(String keyword);

    /**
     * 搜索房屋（带筛选和分页）
     * @param keyword 关键词（标题、地址或描述）
     * @param status 房屋状态
     * @param rooms 卧室数量
     * @param minPrice 最低价格
     * @param maxPrice 最高价格
     * @param page 页码
     * @param pageSize 每页数量
     * @return 符合条件的房屋列表
     */
    List<House> searchHouses(String keyword, String status, String rooms, String minPrice, String maxPrice, int page, int pageSize);

    /**
     * 获取符合搜索条件的房屋总数
     * @param keyword 关键词
     * @param status 房屋状态
     * @param rooms 卧室数量
     * @param minPrice 最低价格
     * @param maxPrice 最高价格
     * @return 符合条件的房屋总数
     */
    int getTotalHouses(String keyword, String status, String rooms, String minPrice, String maxPrice);

    /**
     * 更新房屋状态
     * @param houseId 房屋ID
     * @param status 新状态
     */
    void updateHouseStatus(int houseId, String status);
} 