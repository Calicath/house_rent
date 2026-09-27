package com.house.rental.service;

import java.util.List;

import com.house.rental.bean.House;

public interface HouseService {
    /**
     * 添加房屋
     * @param house 房屋信息
     * @return 添加成功返回true，否则返回false
     */
    boolean addHouse(House house);

    /**
     * 更新房屋信息
     * @param house 房屋信息
     * @return 更新成功返回true，否则返回false
     */
    boolean updateHouse(House house);

    /**
     * 删除房屋
     * @param houseId 房屋ID
     * @return 删除成功返回true，否则返回false
     */
    boolean deleteHouse(int houseId);

    /**
     * 根据ID获取房屋信息
     * @param houseId 房屋ID
     * @return 房屋对象，如果不存在返回null
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
     * @return 更新成功返回true，否则返回false
     */
    boolean updateHouseStatus(int houseId, String status);

    /**
     * 获取可租房屋列表
     * @return 可租房屋列表
     */
    List<House> getAvailableHouses();

    /**
     * 获取已租房屋列表
     * @return 已租房屋列表
     */
    List<House> getRentedHouses();

    /**
     * 校验房屋是否属于指定房主
     * @param ownerId 房主ID
     * @param houseId 房屋ID
     * @return 属于返回true，否则false
     */
    boolean isOwnerHouse(int ownerId, int houseId);
} 