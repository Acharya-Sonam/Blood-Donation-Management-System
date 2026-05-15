package com.blooddonationmanagementsystem.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blooddonationmanagementsystem.model.BloodRequest;
import com.blooddonationmanagementsystem.util.DBConnection;

public class BloodRequestDAO {

    // Check if patient already has a pending request for the same blood group
    public boolean hasPendingRequest(int patientId, String bloodGroup) {
        String sql = "SELECT COUNT(*) FROM blood_requests WHERE patient_id = ? AND blood_group = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ps.setString(2, bloodGroup);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return false;
    }

    // Patient submits a new blood request
    public boolean submitRequest(BloodRequest request) throws SQLException {
        String sql = "INSERT INTO blood_requests (patient_id, blood_group, units, urgency, status, request_date) "
                   + "VALUES (?, ?, ?, ?, 'Pending', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, request.getPatientId());
            ps.setString(2, request.getBloodGroup());
            ps.setInt(3, request.getQuantity());
            ps.setString(4, request.getUrgency());
            return ps.executeUpdate() > 0;
        }
    }

    // Get all requests by a specific patient
    public List<BloodRequest> getRequestsByPatient(int patientId) {
        List<BloodRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM blood_requests WHERE patient_id = ? ORDER BY request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BloodRequest r = new BloodRequest();
                r.setId(rs.getInt("id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setBloodGroup(rs.getString("blood_group"));
                r.setQuantity(rs.getInt("units"));
                r.setUrgency(rs.getString("urgency"));
                r.setStatus(rs.getString("status"));
                r.setRequestDate(rs.getString("request_date"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return list;
    }

    // Get all pending requests (donors will see this)
    public List<BloodRequest> getAllPendingRequests() {
        List<BloodRequest> list = new ArrayList<>();
        String sql = "SELECT br.*, p.full_name AS patient_name "
                   + "FROM blood_requests br "
                   + "JOIN patients p ON br.patient_id = p.patient_id "
                   + "WHERE br.status = 'Pending' "
                   + "ORDER BY br.request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BloodRequest r = new BloodRequest();
                r.setId(rs.getInt("id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setBloodGroup(rs.getString("blood_group"));
                r.setQuantity(rs.getInt("units"));
                r.setUrgency(rs.getString("urgency"));
                r.setStatus(rs.getString("status"));
                r.setRequestDate(rs.getString("request_date"));
                r.setPatientName(rs.getString("patient_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return list;
    }

    // Get all requests (for admin reports)
    public List<BloodRequest> getAllRequests() {
        List<BloodRequest> list = new ArrayList<>();
        String sql = "SELECT br.*, p.full_name AS patient_name "
                   + "FROM blood_requests br "
                   + "JOIN patients p ON br.patient_id = p.patient_id "
                   + "ORDER BY br.request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BloodRequest r = new BloodRequest();
                r.setId(rs.getInt("id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setBloodGroup(rs.getString("blood_group"));
                r.setQuantity(rs.getInt("units"));
                r.setUrgency(rs.getString("urgency"));
                r.setStatus(rs.getString("status"));
                r.setRequestDate(rs.getString("request_date"));
                r.setPatientName(rs.getString("patient_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return list;
    }

    // Get count of requests grouped by blood group
    public java.util.Map<String, Integer> getRequestStatsByBloodGroup() {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT blood_group, COUNT(*) as count, SUM(units) as total_units FROM blood_requests GROUP BY blood_group";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("blood_group"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
        return stats;
    }

    // Donor accepts or rejects a request
    public boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE blood_requests SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }

    // Patient cancels their own request
    public boolean deleteRequest(int requestId) {
        String sql = "DELETE FROM blood_requests WHERE id = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }
}
