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
}
