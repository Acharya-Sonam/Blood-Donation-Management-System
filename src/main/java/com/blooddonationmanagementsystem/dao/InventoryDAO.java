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
}
