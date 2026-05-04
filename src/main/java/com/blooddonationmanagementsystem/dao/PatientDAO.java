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
        String sql = "SELECT * FROM patients";
        List<Patient> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Patient p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setFullName(rs.getString("full_name"));
                p.setPhone(rs.getString("phone"));
                p.setBloodGroup(rs.getString("blood_group"));
                list.add(p);
            }
        }
        return list;
    }
}
