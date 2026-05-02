package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.model.Patient;
import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class UserDAO {
    public int insertUser(String email, String password, String role) throws SQLException {

        String sql = "INSERT INTO users (email, password, role, status) VALUES (?, ?, ?, 'pending')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.setString(3, role);
            stmt.executeUpdate();

            // Get the auto-generated user_id
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
            return -1;
        }
    }

    public User getUserByEmail(String email) throws SQLException {

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
            return null; // no user found with that email
        }
    }

    public boolean emailExists(String email) throws SQLException {

        String sql = "SELECT user_id FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if a row was found
        }
    }

    public void insertDonor(Donor donor) throws SQLException {

        String sql = "INSERT INTO donors (user_id, full_name, phone, date_of_birth, blood_group, address) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,    donor.getUserId());
            stmt.setString(2, donor.getFullName());
            stmt.setString(3, donor.getPhone());
            stmt.setString(4, donor.getDateOfBirth());
            stmt.setString(5, donor.getBloodGroup());
            stmt.setString(6, donor.getAddress());
            stmt.executeUpdate();
        }
    }

    public boolean donorPhoneExists(String phone) throws SQLException {

        String sql = "SELECT donor_id FROM donors WHERE phone = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }
    //  PATIENT TABLE OPERATIONS
    public void insertPatient(Patient patient) throws SQLException {

        String sql = "INSERT INTO patients (user_id, full_name, phone, date_of_birth, blood_group, address, hospital_name) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,    patient.getUserId());
            stmt.setString(2, patient.getFullName());
            stmt.setString(3, patient.getPhone());
            stmt.setString(4, patient.getDateOfBirth());
            stmt.setString(5, patient.getBloodGroup());
            stmt.setString(6, patient.getAddress());
            stmt.setString(7, patient.getHospitalName());
            stmt.executeUpdate();
        }
    }

    public boolean patientPhoneExists(String phone) throws SQLException {

        String sql = "SELECT patient_id FROM patients WHERE phone = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }


    public boolean updatePassword(String email, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getString("created_at"));
        return user;
    }
}
