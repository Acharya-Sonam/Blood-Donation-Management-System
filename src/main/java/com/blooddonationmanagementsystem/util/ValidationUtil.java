package com.blooddonationmanagementsystem.util;

public class ValidationUtil {

    //Checks that a value is not null and not empty/blank.
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidName(String name) {
        if (!isNotEmpty(name)) return false;
        return name.trim().matches("[a-zA-Z ]+");
    }

    public static boolean isValidEmail(String email) {
        if (!isNotEmpty(email)) return false;
        return email.trim().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    public static boolean isValidPhone(String phone) {
        if (!isNotEmpty(phone)) return false;
        return phone.trim().matches("\\d{10}");
    }

    public static boolean isValidPassword(String password) {
        if (!isNotEmpty(password)) return false;
        return password.length() >= 8;
    }

    public static boolean passwordsMatch(String password, String confirmPassword) {
        if (password == null || confirmPassword == null) return false;
        return password.equals(confirmPassword);
    }

    public static boolean isValidDOB(String dob) {
        if (!isNotEmpty(dob)) return false;
        try {
            java.time.LocalDate parsed = java.time.LocalDate.parse(dob);
            return parsed.isBefore(java.time.LocalDate.now());
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isPositiveInteger(String value) {
        if (!isNotEmpty(value)) return false;
        try {
            return Integer.parseInt(value.trim()) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isValidBloodGroup(String bloodGroup) {
        if (!isNotEmpty(bloodGroup)) return false;
        String[] valid = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String bg : valid) {
            if (bg.equals(bloodGroup.trim())) return true;
        }
        return false;
    }
}