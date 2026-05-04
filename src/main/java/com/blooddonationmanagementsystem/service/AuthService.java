package com.blooddonationmanagementsystem.service;


import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.model.Patient;
import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.util.PasswordUtil;
import com.blooddonationmanagementsystem.util.ValidationUtil;

import java.sql.SQLException;

public class AuthService {

    // One DAO instance used by all methods
    private UserDAO userDAO = new UserDAO();

    //  LOGIN
    public User login(String email, String password) throws SQLException, AuthException {

        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
            throw new AuthException("Email and password are required.");
        }
        User user = userDAO.getUserByEmail(email.trim());
        if (user == null) {
            throw new AuthException("No account found with that email address.");
        }

        if (!PasswordUtil.verify(password, user.getPassword())) {
            throw new AuthException("Incorrect password. Please try again.");
        }

        if ("pending".equals(user.getStatus())) {
            throw new AuthException("Your account is pending admin approval. Please wait.");
        }
        if ("rejected".equals(user.getStatus())) {
            throw new AuthException("Your account has been rejected. Please contact support.");
        }
        return user;
    }

    //  DONOR REGISTRATION

    public void registerDonor(String fullName, String email, String password,String confirm, String phone, String dob,String bloodGroup, String address)
            throws SQLException, AuthException {

        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new AuthException("Full name is required.");
        }
        if (!ValidationUtil.isValidName(fullName)) {
            throw new AuthException("Full name must contain letters only. Numbers are not allowed.");
        }
        if (!ValidationUtil.isNotEmpty(email)) {
            throw new AuthException("Email address is required.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new AuthException("Please enter a valid email address (e.g. name@email.com).");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new AuthException("Password must be at least 6 characters long.");
        }
        if (!ValidationUtil.passwordsMatch(password, confirm)) {
            throw new AuthException("Passwords do not match. Please re-enter.");
        }
        if (!ValidationUtil.isNotEmpty(phone)) {
            throw new AuthException("Phone number is required.");
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            throw new AuthException("Phone number must be exactly 10 digits (numbers only).");
        }
        if (!ValidationUtil.isValidDOB(dob)) {
            throw new AuthException("Please enter a valid date of birth (must be in the past).");
        }
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new AuthException("Please select a valid blood group.");
        }


        if (userDAO.emailExists(email.trim())) {
            throw new AuthException("An account with this email already exists.");
        }
        if (userDAO.donorPhoneExists(phone.trim())) {
            throw new AuthException("A donor account with this phone number already exists.");
        }

        String hashedPassword = PasswordUtil.hash(password);

        // Insert into users table and get the new user_id
        int userId = userDAO.insertUser(email.trim(), hashedPassword, "donor");

        if (userId == -1) {
            throw new AuthException("Registration failed. Please try again.");
        }

        // Build Donor object and insert into donors table
        Donor donor = new Donor(userId, fullName.trim(), phone.trim(),dob, bloodGroup.trim(), address);
        userDAO.insertDonor(donor);
    }

    //  PATIENT REGISTRATION
   
    public void registerPatient(String fullName, String email, String password,String confirm, String phone, String dob,String bloodGroup, String address, String hospitalName)
            throws SQLException, AuthException {

        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new AuthException("Full name is required.");
        }
        if (!ValidationUtil.isValidName(fullName)) {
            throw new AuthException("Full name must contain letters only. Numbers are not allowed.");
        }
        if (!ValidationUtil.isNotEmpty(email)) {
            throw new AuthException("Email address is required.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new AuthException("Please enter a valid email address (e.g. name@email.com).");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new AuthException("Password must be at least 6 characters long.");
        }
        if (!ValidationUtil.passwordsMatch(password, confirm)) {
            throw new AuthException("Passwords do not match. Please re-enter.");
        }
        if (!ValidationUtil.isNotEmpty(phone)) {
            throw new AuthException("Phone number is required.");
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            throw new AuthException("Phone number must be exactly 10 digits (numbers only).");
        }
        if (!ValidationUtil.isValidDOB(dob)) {
            throw new AuthException("Please enter a valid date of birth (must be in the past).");
        }
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            throw new AuthException("Please select a valid blood group.");
        }

        if (userDAO.emailExists(email.trim())) {
            throw new AuthException("An account with this email already exists.");
        }
        if (userDAO.patientPhoneExists(phone.trim())) {
            throw new AuthException("A patient account with this phone number already exists.");
        }


        String hashedPassword = PasswordUtil.hash(password);
        int userId = userDAO.insertUser(email.trim(), hashedPassword, "patient");

        if (userId == -1) {
            throw new AuthException("Registration failed. Please try again.");
        }

        Patient patient = new Patient(userId, fullName.trim(), phone.trim(),dob, bloodGroup.trim(), address, hospitalName);
        userDAO.insertPatient(patient);
    }

    //  INNER EXCEPTION CLASS
 
    public static class AuthException extends Exception {
        public AuthException(String message) {
            super(message);
        }
    }
}
