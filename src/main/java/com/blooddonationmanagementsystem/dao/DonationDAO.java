package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.Donation;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DonationDAO {

    public boolean recordDonation(Donation donation) throws SQLException {
        String sql = "INSERT INTO donations (donor_id, request_id, units_donated, donation_date, status, inventory_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, donation.getDonorId());
            if (donation.getRequestId() > 0) {
                stmt.setInt(2, donation.getRequestId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setInt(3, donation.getUnitsDonated());
            stmt.setString(4, donation.getDonationDate());
            stmt.setString(5, donation.getStatus());
            stmt.setInt(6, donation.getInventoryId());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Donation> getDonationHistory(int donorId) throws SQLException {
        String sql = "SELECT * FROM donations WHERE donor_id = ? ORDER BY donation_date DESC";
        List<Donation> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, donorId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Donation d = new Donation();
                d.setDonationId(rs.getInt("donation_id"));
                d.setDonorId(rs.getInt("donor_id"));
                d.setRequestId(rs.getInt("request_id"));
                d.setUnitsDonated(rs.getInt("units_donated"));
                d.setDonationDate(rs.getString("donation_date"));
                d.setStatus(rs.getString("status"));
                d.setInventoryId(rs.getInt("inventory_id"));
                list.add(d);
            }
        }
        return list;
    }

    public int getDonationCount(int donorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM donations WHERE donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, donorId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public String getLastDonationDate(int donorId) throws SQLException {
        String sql = "SELECT MAX(donation_date) FROM donations WHERE donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, donorId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString(1) : null;
        }
    }
}
