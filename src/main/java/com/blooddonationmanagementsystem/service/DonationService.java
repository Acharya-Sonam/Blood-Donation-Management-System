package com.blooddonationmanagementsystem.service;

import com.blooddonationmanagementsystem.dao.DonationDAO;
import com.blooddonationmanagementsystem.dao.InventoryDAO;
import com.blooddonationmanagementsystem.dao.DonorDAO;
import com.blooddonationmanagementsystem.model.Donation;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class DonationService {

    private final DonationDAO donationDAO = new DonationDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final DonorDAO donorDAO = new DonorDAO();

    public List<Donation> getDonationHistory(int userId) throws SQLException {
        return donationDAO.getDonationHistory(userId);
    }

    public int getDonationCount(int userId) throws SQLException {
        return donationDAO.getDonationCount(userId);
    }

    public String getLastDonationDate(int userId) throws SQLException {
        return donationDAO.getLastDonationDate(userId);
    }

    public String getNextEligibleDate(int userId) throws SQLException {
        String lastDateStr = getLastDonationDate(userId);
        if (lastDateStr == null || lastDateStr.length() < 10) return LocalDate.now().toString();

        LocalDate lastDate = LocalDate.parse(lastDateStr.substring(0, 10));
        return lastDate.plusMonths(3).toString();
    }

    public boolean isEligibleToDonate(int userId) throws SQLException {
        String lastDateStr = getLastDonationDate(userId);
        if (lastDateStr == null || lastDateStr.length() < 10) return true;

        LocalDate lastDate = LocalDate.parse(lastDateStr.substring(0, 10));
        return ChronoUnit.MONTHS.between(lastDate, LocalDate.now()) >= 3;
    }

    public boolean recordDonation(int userId, int requestId, int units, String date, int inventoryId) throws SQLException {
        // If inventoryId is not provided (or <= 0), look it up based on donor's blood group
        if (inventoryId <= 0) {
            com.blooddonationmanagementsystem.model.Donor donor = donorDAO.getDonorByUserId(userId);
            if (donor != null) {
                inventoryId = inventoryDAO.getInventoryIdByBloodGroup(donor.getBloodGroup());
            }
        }

        Donation donation = new Donation(userId, requestId, units, date, inventoryId);
        donation.setStatus("completed");
        boolean recorded = donationDAO.recordDonation(donation);
        
        if (recorded) {
            // Update the blood request status to fulfilled if linked
            if (requestId > 0) {
                com.blooddonationmanagementsystem.dao.BloodRequestDAO brDAO = new com.blooddonationmanagementsystem.dao.BloodRequestDAO();
                brDAO.updateStatus(requestId, "fulfilled");
            }

            if (inventoryId > 0) {
                // Get blood group to update stock
                String bloodGroup = inventoryDAO.getBloodGroupById(inventoryId);
                if (bloodGroup != null) {
                    inventoryDAO.updateStock(bloodGroup, units);
                }
            }
        }
        return recorded;
    }

    public boolean recordWalkInDonation(int userId, int units, String date, int inventoryId) throws SQLException {
        return recordDonation(userId, 0, units, date, inventoryId);
    }
}
