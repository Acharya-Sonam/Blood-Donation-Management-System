package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.model.Patient;
import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


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
    public int getPatientIdByUserId(int userId) throws SQLException {
        String sql = "SELECT patient_id FROM patients WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("patient_id");
            }
            return -1;
        }
    }

    //  Admin / management operations ────────────────────────────────

    public List<User> getAllUsers() throws SQLException {
        String sql = "SELECT u.*, COALESCE(d.full_name, p.full_name, 'Admin') AS name "
                   + "FROM users u "
                   + "LEFT JOIN donors d ON u.user_id = d.user_id "
                   + "LEFT JOIN patients p ON u.user_id = p.user_id "
                   + "ORDER BY u.user_id DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }
        return users;
    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT u.*, COALESCE(d.full_name, p.full_name, 'Admin') AS name "
                   + "FROM users u "
                   + "LEFT JOIN donors d ON u.user_id = d.user_id "
                   + "LEFT JOIN patients p ON u.user_id = p.user_id "
                   + "WHERE u.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        }
    }

    public List<User> getUsersByStatus(String status) throws SQLException {
        String sql = "SELECT u.*, COALESCE(d.full_name, p.full_name, 'Admin') AS name "
                   + "FROM users u "
                   + "LEFT JOIN donors d ON u.user_id = d.user_id "
                   + "LEFT JOIN patients p ON u.user_id = p.user_id "
                   + "WHERE u.status = ? ORDER BY u.user_id DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        }
        return users;
    }

    public void updateUserStatus(int userId, String status) throws SQLException {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public void updateUserRole(int userId, String role) throws SQLException {
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public void deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    public List<User> searchUsers(String query) throws SQLException {
        String q = (query == null) ? "" : query.trim();
        String like = "%" + q + "%";
        String sql = "SELECT u.*, COALESCE(d.full_name, p.full_name, 'Admin') AS name "
                   + "FROM users u "
                   + "LEFT JOIN donors d ON u.user_id = d.user_id "
                   + "LEFT JOIN patients p ON u.user_id = p.user_id "
                   + "WHERE u.email LIKE ? OR u.role LIKE ? OR u.status LIKE ? "
                   + "OR d.full_name LIKE ? OR p.full_name LIKE ? "
                   + "ORDER BY u.user_id DESC";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);
            stmt.setString(4, like);
            stmt.setString(5, like);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        }
        return users;
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
        
        // Handle name mapping from COALESCE in SQL
        try {
            user.setName(rs.getString("name"));
        } catch (SQLException e) {
            // Name column might not be present in all queries
            user.setName("N/A");
        }
        
        return user;
    }
}
