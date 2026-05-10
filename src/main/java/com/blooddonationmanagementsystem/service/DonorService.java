package com.blooddonationmanagementsystem.service;
 
import com.blooddonationmanagementsystem.dao.DonorDAO;
import com.blooddonationmanagementsystem.model.Donor;
import java.sql.SQLException;
import java.util.List;

public class DonorService {
    private final DonorDAO donorDAO = new DonorDAO();

    public Donor getDonorByUserId(int userId) throws SQLException {
        return donorDAO.getDonorByUserId(userId);
    }

    public List<Donor> getAllDonors() throws SQLException {
        return donorDAO.getAllDonors();
    }

    public List<Donor> searchDonors(String bloodGroup, String location) throws SQLException {
        if (bloodGroup != null && !bloodGroup.isEmpty() && location != null && !location.isEmpty()) {
            return donorDAO.searchByBloodGroupAndLocation(bloodGroup, location);
        } else if (bloodGroup != null && !bloodGroup.isEmpty()) {
            return donorDAO.searchByBloodGroup(bloodGroup);
        } else if (location != null && !location.isEmpty()) {
            return donorDAO.searchByLocation(location);
        }
        return donorDAO.getAllDonors();
    }
}
