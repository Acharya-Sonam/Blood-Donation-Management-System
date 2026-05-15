package com.blooddonationmanagementsystem.dao;

import com.blooddonationmanagementsystem.model.Patient;
import com.blooddonationmanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public List<Patient> getAllPatients() throws SQLException {
        String sql = "SELECT * FROM patients ORDER BY patient_id DESC";
        List<Patient> patients = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                patients.add(mapPatient(rs));
            }
        }
        return patients;
    }

    private Patient mapPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setPatientId(rs.getInt("patient_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setFullName(rs.getString("full_name"));
        p.setPhone(rs.getString("phone"));
        p.setDateOfBirth(rs.getString("date_of_birth"));
        p.setBloodGroup(rs.getString("blood_group"));
        p.setAddress(rs.getString("address"));
        p.setHospitalName(rs.getString("hospital_name"));
        p.setCreatedAt(rs.getString("created_at"));
        return p;
    }
    // Get patient by patient ID
    public Patient getPatientById(int patientId) throws SQLException {
        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapPatient(rs);
            }
        }
        return null;
    }

    // Update patient profile
    public void updatePatient(int patientId, String fullName, String phone,
                              String bloodGroup, String address,
                              String hospitalName) throws SQLException {
        String sql = "UPDATE patients SET full_name=?, phone=?, blood_group=?, " +
                "address=?, hospital_name=? WHERE patient_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, bloodGroup);
            stmt.setString(4, address);
            stmt.setString(5, hospitalName);
            stmt.setInt(6, patientId);
            stmt.executeUpdate();
        }
    }

    // Delete patient profile
    public void deletePatient(int patientId) throws SQLException {
        String sql = "DELETE FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.executeUpdate();
        }
    }
}
