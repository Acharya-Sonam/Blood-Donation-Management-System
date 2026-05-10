package com.blooddonationmanagementsystem.service;

import com.blooddonationmanagementsystem.dao.DonorDAO;
import com.blooddonationmanagementsystem.model.Donor;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientService {

    private DonorDAO donorDAO = new DonorDAO();

    public List<Donor> searchDonors(String bloodGroup, String location) {
        try {
            boolean hasBloodGroup = bloodGroup != null && !bloodGroup.trim().isEmpty();
            boolean hasLocation   = location   != null && !location.trim().isEmpty();

            if (hasBloodGroup && hasLocation) {
                return donorDAO.searchByBloodGroupAndLocation(bloodGroup.trim(), location.trim());
            } else if (hasBloodGroup) {
                return donorDAO.searchByBloodGroup(bloodGroup.trim());
            } else if (hasLocation) {
                return donorDAO.searchByLocation(location.trim());
            } else {
                return donorDAO.getAllDonors();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
