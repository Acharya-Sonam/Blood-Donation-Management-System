package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.BloodInventory;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    public List<BloodInventory> getAllInventory() throws SQLException {
        String sql = "SELECT * FROM blood_inventory ORDER BY blood_group ASC";
        List<BloodInventory> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new BloodInventory(
                        rs.getInt("inventory_id"),
                        rs.getString("blood_group"),
                        rs.getInt("units_available"),
                        rs.getString("last_updated")
                ));
            }
        }
        return list;
    }

    public void updateStock(String bloodGroup, int units) throws SQLException {
        String sql = "UPDATE blood_inventory SET units_available = units_available + ?, last_updated = CURRENT_TIMESTAMP WHERE blood_group = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, units);
            stmt.setString(2, bloodGroup);
            stmt.executeUpdate();
        }
    }
    public int getInventoryIdByBloodGroup(String bloodGroup) throws SQLException {
        String sql = "SELECT inventory_id FROM blood_inventory WHERE blood_group = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bloodGroup);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("inventory_id") : -1;
        }
    }

    public String getBloodGroupById(int inventoryId) throws SQLException {
        String sql = "SELECT blood_group FROM blood_inventory WHERE inventory_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("blood_group") : null;
        }
    }
}
