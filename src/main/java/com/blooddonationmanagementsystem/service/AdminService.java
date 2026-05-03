package com.blooddonationmanagementsystem.service;

import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.model.User;

import java.sql.SQLException;
import java.util.List;

public class AdminService {

    private final UserDAO userDAO = new UserDAO();
    private final com.blooddonationmanagementsystem.dao.BloodRequestDAO bloodRequestDAO = new com.blooddonationmanagementsystem.dao.BloodRequestDAO();
    private final com.blooddonationmanagementsystem.dao.DonorDAO donorDAO = new com.blooddonationmanagementsystem.dao.DonorDAO();

    // ── GET ALL USERS ─────────────────────────────────────────────
    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }

    // ── GET USER BY ID ────────────────────────────────────────────
    public User getUserById(int userId) throws SQLException {
        return userDAO.getUserById(userId);
    }

    // ── APPROVE USER ──────────────────────────────────────────────
    public void approveUser(int userId) throws SQLException {
        userDAO.updateUserStatus(userId, "approved");
    }

    // ── REJECT USER ───────────────────────────────────────────────
    public void rejectUser(int userId) throws SQLException {
        userDAO.updateUserStatus(userId, "rejected");
    }

    // ── DELETE USER ───────────────────────────────────────────────
    public void deleteUser(int userId) throws SQLException {
        userDAO.deleteUser(userId);
    }

    // ── UPDATE USER ROLE ──────────────────────────────────────────
    public void updateUserRole(int userId, String role) throws SQLException {
        userDAO.updateUserRole(userId, role);
    }

    // ── GET PENDING USERS ─────────────────────────────────────────
    public List<User> getPendingUsers() throws SQLException {
        return userDAO.getUsersByStatus("pending");
    }

    // ── GET APPROVED USERS ────────────────────────────────────────
    public List<User> getApprovedUsers() throws SQLException {
        return userDAO.getUsersByStatus("approved");
    }

    // ── GET REJECTED USERS ────────────────────────────────────────
    public List<User> getRejectedUsers() throws SQLException {
        return userDAO.getUsersByStatus("rejected");
    }

    // ── DASHBOARD STATS ──────────────────────────────────────────
    public int getTotalDonors() throws SQLException {
        return donorDAO.getAllDonors().size();
    }

    public int getPendingApprovals() throws SQLException {
        return getPendingUsers().size();
    }

    public int getTotalBloodRequests() throws SQLException {
        return bloodRequestDAO.getAllPendingRequests().size(); // Or get all if we want history
    }

    // ── BLOOD REQUESTS ───────────────────────────────────────────
    public List<com.blooddonationmanagementsystem.model.BloodRequest> getAllBloodRequests() {
        return bloodRequestDAO.getAllPendingRequests();
    }

    public void updateRequestStatus(int requestId, String status) {
        bloodRequestDAO.updateStatus(requestId, status);
    }
}