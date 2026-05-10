package com.blooddonationmanagementsystem.service;

import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.model.User;

import java.sql.SQLException;
import java.util.List;

public class AdminService {

    private final UserDAO userDAO = new UserDAO();
    private final com.blooddonationmanagementsystem.dao.BloodRequestDAO bloodRequestDAO = new com.blooddonationmanagementsystem.dao.BloodRequestDAO();
    private final com.blooddonationmanagementsystem.dao.DonorDAO donorDAO = new com.blooddonationmanagementsystem.dao.DonorDAO();
    private final com.blooddonationmanagementsystem.dao.PatientDAO patientDAO = new com.blooddonationmanagementsystem.dao.PatientDAO();
    private final com.blooddonationmanagementsystem.dao.InventoryDAO inventoryDAO = new com.blooddonationmanagementsystem.dao.InventoryDAO();

    //  GET ALL USERS
    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }

    //GET USER BY ID 
    public User getUserById(int userId) throws SQLException {
        return userDAO.getUserById(userId);
    }

    // APPROVE USER 
    public void approveUser(int userId) throws SQLException {
        userDAO.updateUserStatus(userId, "approved");
    }

    //REJECT USER 
    public void rejectUser(int userId) throws SQLException {
        userDAO.updateUserStatus(userId, "rejected");
    }

    // DELETE USER
    public void deleteUser(int userId) throws SQLException {
        userDAO.deleteUser(userId);
    }

    // UPDATE USER ROLE 
    public void updateUserRole(int userId, String role) throws SQLException {
        userDAO.updateUserRole(userId, role);
    }

    // GET PENDING USERS
    public List<User> getPendingUsers() throws SQLException {
        return userDAO.getUsersByStatus("pending");
    }

    // GET APPROVED USERS
    public List<User> getApprovedUsers() throws SQLException {
        return userDAO.getUsersByStatus("approved");
    }

    //GET REJECTED USERS 
    public List<User> getRejectedUsers() throws SQLException {
        return userDAO.getUsersByStatus("rejected");
    }

    // DASHBOARD STATS 
    public int getTotalDonors() throws SQLException {
        return donorDAO.getAllDonors().size();
    }

    public int getTotalPatients() throws SQLException {
        return patientDAO.getAllPatients().size();
    }

    public int getPendingApprovals() throws SQLException {
        return getPendingUsers().size();
    }

    public int getTotalBloodRequests() throws SQLException {
        return bloodRequestDAO.getAllPendingRequests().size(); // Or get all if we want history
    }

    //BLOOD REQUESTS 
    public List<com.blooddonationmanagementsystem.model.BloodRequest> getAllBloodRequests() {
        return bloodRequestDAO.getAllPendingRequests();
    }

    public List<User> searchUsers(String query) throws SQLException {
        return userDAO.searchUsers(query);
    }

    public List<com.blooddonationmanagementsystem.model.BloodInventory> getInventory() throws SQLException {
        return inventoryDAO.getAllInventory();
    }

    public void updateInventory(String bloodGroup, int units) throws SQLException {
        inventoryDAO.updateStock(bloodGroup, units);
    }

    public void updateRequestStatus(int requestId, String status) {
        bloodRequestDAO.updateStatus(requestId, status);
    }

    public List<com.blooddonationmanagementsystem.model.BloodRequest> getAllRequests() {
        return bloodRequestDAO.getAllRequests();
    }

    public java.util.Map<String, Integer> getRequestStats() {
        return bloodRequestDAO.getRequestStatsByBloodGroup();
    }
}
