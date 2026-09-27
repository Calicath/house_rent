package com.house.rental.dao;

import java.util.List;

import com.house.rental.bean.ViewingRecord;

public interface ViewingRecordDAO {
    void addViewingRecord(ViewingRecord record);
    void updateViewingRecord(ViewingRecord record);
    void deleteViewingRecord(int recordId);
    ViewingRecord getViewingRecordById(int recordId);
    List<ViewingRecord> getViewingRecordsByTenantId(int tenantId);
    List<ViewingRecord> getViewingRecordsByHouseId(int houseId);
    List<ViewingRecord> getViewingRecordsByHouseIds(List<Integer> houseIds);
    List<ViewingRecord> getAllViewingRecords();
    
    // 优化的查询方法：一次性获取房主的所有看房申请及相关信息
    List<ViewingRecord> getViewingRecordsWithDetailsByOwnerId(int ownerId);
} 