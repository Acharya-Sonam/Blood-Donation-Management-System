package com.bloodbridge.service;

import com.bloodbridge.dao.UserDao;
import com.bloodbridge.model.Donor;
import com.bloodbridge.util.BloodCompatibilityUtil;
import java.util.Map;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class PatientService {

    private final UserDao userDao = new UserDao();

    // ---------------------------------------------------
    // Blood compatibility map
    // Key = requested blood type
    // Value = donor types that are compatible
    // ---------------------------------------------------
    private static final Map<String, List<String>> COMPATIBILITY = Map.of(
            "A+",  Arrays.asList("A+", "A-", "O+", "O-"),
            "A-",  Arrays.asList("A-", "O-"),
            "B+",  Arrays.asList("B+", "B-", "O+", "O-"),
            "B-",  Arrays.asList("B-", "O-"),
            "O+",  Arrays.asList("O+", "O-"),
            "O-",  Arrays.asList("O-"),
            "AB+", Arrays.asList("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"),
            "AB-", Arrays.asList("A-", "B-", "O-", "AB-")
    );

    // ---------------------------------------------------
    // Search donors by exact blood type and location
    // ---------------------------------------------------
    public List<Donor> searchDonors(String bloodType, String location, String urgency) throws SQLException {
        return userDao.searchDonors(bloodType, location, urgency);
    }

    // ---------------------------------------------------
    // Search compatible donors based on patient's blood type
    // e.g. patient is AB+ so show all 8 compatible donor types
    // ---------------------------------------------------
    public List<Donor> searchCompatibleDonors(String patientBloodType, String location, String urgency) throws SQLException {
        List<String> compatibleTypes = BloodCompatibilityUtil.getCompatibleDonorTypes(patientBloodType);

        List<Donor> allDonors = userDao.searchDonors("", location, urgency);
        List<Donor> compatibleDonors = new ArrayList<>();

        for (Donor donor : allDonors) {
            if (compatibleTypes.contains(donor.getBloodType())) {
                compatibleDonors.add(donor);
            }
        }

        // Sort urgent donors to top
        compatibleDonors.sort((a, b) -> {
            if (a.isUrgent() && !b.isUrgent()) return -1;
            if (!a.isUrgent() && b.isUrgent()) return 1;
            return 0;
        });

        return compatibleDonors;
    }

    // ---------------------------------------------------
    // Get all donors (for initial page load)
    // ---------------------------------------------------
    public List<Donor> getAllDonors() throws SQLException {
        return userDao.searchDonors("", "", "");
    }
    // ---------------------------------------------------
    // Count how many donors are eligible right now
    // ---------------------------------------------------
    public long countEligible(List<Donor> donors) {
        return donors.stream()
                .filter(Donor::isEligible)
                .count();
    }

    // ---------------------------------------------------
    // Get compatible blood types for a given blood type
    // Used to display compatibility info on the JSP
    // ---------------------------------------------------
    public List<String> getCompatibleTypes(String bloodType) {
        return COMPATIBILITY.getOrDefault(bloodType, new ArrayList<>());
    }
    public Map<String, int[]> getBloodTypeStats() throws SQLException {
        return userDao.getBloodTypeStats();
    }
}