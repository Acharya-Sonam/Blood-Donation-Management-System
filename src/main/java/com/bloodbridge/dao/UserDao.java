package com.bloodbridge.dao;

import com.bloodbridge.model.Donor;
import com.bloodbridge.util.DBConnection;
import java.util.LinkedHashMap;
import java.util.Map;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    // Search donors by blood type and/or location
    public List<Donor> searchDonors(String bloodType, String location, String urgency) throws SQLException {

        List<Donor> donors = new ArrayList<>();

        StringBuilder query = new StringBuilder(
                "SELECT * FROM donors WHERE is_approved = 1"
        );

        if (bloodType != null && !bloodType.isEmpty()) {
            query.append(" AND blood_type = ?");
        }
        if (location != null && !location.isEmpty()) {
            query.append(" AND location LIKE ?");
        }
        if (urgency != null && !urgency.isEmpty()) {
            query.append(" AND urgency = ?");
        }

        // Urgent donors always appear first
        query.append(" ORDER BY CASE WHEN urgency = 'urgent' THEN 0 ELSE 1 END, name ASC");

        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query.toString());

        int index = 1;
        if (bloodType != null && !bloodType.isEmpty()) {
            stmt.setString(index++, bloodType);
        }
        if (location != null && !location.isEmpty()) {
            stmt.setString(index++, "%" + location + "%");
        }
        if (urgency != null && !urgency.isEmpty()) {
            stmt.setString(index++, urgency);
        }

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Donor donor = new Donor();
            donor.setId(rs.getInt("id"));
            donor.setName(rs.getString("name"));
            donor.setBloodType(rs.getString("blood_type"));
            donor.setLocation(rs.getString("location"));
            donor.setPhone(rs.getString("phone"));
            donor.setApproved(rs.getBoolean("is_approved"));
            donor.setUrgency(rs.getString("urgency"));

            Date date = rs.getDate("last_donation_date");
            if (date != null) {
                donor.setLastDonationDate(date.toLocalDate());
            }

            donors.add(donor);
        }

        rs.close();
        stmt.close();
        conn.close();

        return donors;
    }

    // Keep old method working by calling new one
    public List<Donor> getAllDonors() throws SQLException {
        return searchDonors("", "", "");
    }
    // Get donor count and eligible count grouped by blood type
    public Map<String, int[]> getBloodTypeStats() throws SQLException {
        Map<String, int[]> stats = new LinkedHashMap<>();

        String[] types = {"A+","A-","B+","B-","O+","O-","AB+","AB-"};
        for (String t : types) {
            stats.put(t, new int[]{0, 0}); // [total, eligible]
        }

        String query = "SELECT blood_type, last_donation_date FROM donors WHERE is_approved = 1";
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String bloodType = rs.getString("blood_type");
            Date date = rs.getDate("last_donation_date");

            if (stats.containsKey(bloodType)) {
                stats.get(bloodType)[0]++; // total++

                // Check eligibility
                if (date == null) {
                    stats.get(bloodType)[1]++; // eligible++
                } else {
                    long days = java.time.temporal.ChronoUnit.DAYS.between(
                            date.toLocalDate(), java.time.LocalDate.now()
                    );
                    if (days >= 56) {
                        stats.get(bloodType)[1]++; // eligible++
                    }
                }
            }
        }

        rs.close();
        stmt.close();
        conn.close();

        return stats;
    }
}