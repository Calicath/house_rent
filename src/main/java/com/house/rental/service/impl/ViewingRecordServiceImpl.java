package com.house.rental.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.house.rental.bean.ViewingRecord;
import com.house.rental.dao.ViewingRecordDAO;
import com.house.rental.dao.impl.ViewingRecordDAOImpl;
import com.house.rental.service.ViewingRecordService;
import com.house.rental.util.DBUtil;

public class ViewingRecordServiceImpl implements ViewingRecordService {
    
    private final ViewingRecordDAO viewingRecordDAO;
    
    public ViewingRecordServiceImpl() {
        this.viewingRecordDAO = new ViewingRecordDAOImpl();
    }
    
    @Override
    public boolean addViewingRecord(ViewingRecord record) {
        try {
            viewingRecordDAO.addViewingRecord(record);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateViewingRecord(ViewingRecord record) {
        try {
            viewingRecordDAO.updateViewingRecord(record);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteViewingRecord(int recordId) {
        try {
            viewingRecordDAO.deleteViewingRecord(recordId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public ViewingRecord getViewingRecordById(int recordId) {
        try {
            return viewingRecordDAO.getViewingRecordById(recordId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByTenantId(int tenantId) {
        try {
            return viewingRecordDAO.getViewingRecordsByTenantId(tenantId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByHouseId(int houseId) {
        try {
            return viewingRecordDAO.getViewingRecordsByHouseId(houseId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ViewingRecord> getViewingRecordsByHouseIds(List<Integer> houseIds) {
        try {
            return viewingRecordDAO.getViewingRecordsByHouseIds(houseIds);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ViewingRecord> getViewingRecordsWithDetailsByOwnerId(int ownerId) {
        try {
            return viewingRecordDAO.getViewingRecordsWithDetailsByOwnerId(ownerId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ViewingRecord> getAllViewingRecords() {
        try {
            return viewingRecordDAO.getAllViewingRecords();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
} 