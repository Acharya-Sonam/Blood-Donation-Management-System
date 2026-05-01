package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {

    // Search donors by blood group only
    public List<Donor> searchByBloodGroup(String bloodGroup) throws SQLException {
        String sql = "SELECT * FROM donors d "
                + "JOIN users u ON d.user_id = u.user_id "
                + "WHERE u.status = 'approved' AND d.blood_group = ?";

        List<Donor> donors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, bloodGroup);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                donors.add(mapDonor(rs));
            }
        }
        return donors;
    }

    // Search donors by location (address) only
    public List<Donor> searchByLocation(String location) throws SQLException {
        String sql = "SELECT * FROM donors d "
                + "JOIN users u ON d.user_id = u.user_id "
                + "WHERE u.status = 'approved' AND d.address LIKE ?";

        List<Donor> donors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + location + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                donors.add(mapDonor(rs));
            }
        }
        return donors;
    }

    // Search donors by both blood group AND location
    public List<Donor> searchByBloodGroupAndLocation(String bloodGroup, String location) throws SQLException {
        String sql = "SELECT * FROM donors d "
                + "JOIN users u ON d.user_id = u.user_id "
                + "WHERE u.status = 'approved' AND d.blood_group = ? AND d.address LIKE ?";

        List<Donor> donors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, bloodGroup);
            stmt.setString(2, "%" + location + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                donors.add(mapDonor(rs));
            }
        }
        return donors;
    }

    // Get all approved donors
    public List<Donor> getAllDonors() throws SQLException {
        String sql = "SELECT * FROM donors d "
                + "JOIN users u ON d.user_id = u.user_id "
                + "WHERE u.status = 'approved'";

        List<Donor> donors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                donors.add(mapDonor(rs));
            }
        }
        return donors;
    }

    // Map ResultSet row to Donor object
    private Donor mapDonor(ResultSet rs) throws SQLException {
        Donor donor = new Donor();
        donor.setDonorId(rs.getInt("donor_id"));
        donor.setUserId(rs.getInt("user_id"));
        donor.setFullName(rs.getString("full_name"));
        donor.setPhone(rs.getString("phone"));
        donor.setDateOfBirth(rs.getString("date_of_birth"));
        donor.setBloodGroup(rs.getString("blood_group"));
        donor.setAddress(rs.getString("address"));
        donor.setLastDonation(rs.getString("last_donation"));
        donor.setCreatedAt(rs.getString("created_at"));
        return donor;
    }
}