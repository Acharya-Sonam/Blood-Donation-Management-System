package com.blooddonationmanagementsystem.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class DateUtil {

    private static final DateTimeFormatter DISPLAY_FORMAT = DateTimeFormatter.ofPattern("dd MMM yyyy");

    private static final DateTimeFormatter DB_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static String formatForDisplay(String dbDate) {
        if (dbDate == null || dbDate.trim().isEmpty()) {
            return "N/A";
        }
        try {
            LocalDate date = LocalDate.parse(dbDate, DB_FORMAT);
            return date.format(DISPLAY_FORMAT);
        } catch (Exception e) {
            return dbDate; // return as-is if parsing fails
        }
    }

    public static String today() {
        return LocalDate.now().format(DB_FORMAT);
    }

    public static String nextEligibleDate(String lastDonationDate) {
        if (lastDonationDate == null || lastDonationDate.trim().isEmpty()) {
            return "Eligible Now";
        }
        try {
            LocalDate last = LocalDate.parse(lastDonationDate, DB_FORMAT);
            LocalDate next = last.plusDays(90);
            if (!next.isAfter(LocalDate.now())) {
                return "Eligible Now";
            }
            return next.format(DISPLAY_FORMAT);
        } catch (Exception e) {
            return "Eligible Now";
        }
    }

    public static long daysAgo(String dbDate) {
        if (dbDate == null || dbDate.trim().isEmpty()) return -1;
        try {
            LocalDate date = LocalDate.parse(dbDate, DB_FORMAT);
            return ChronoUnit.DAYS.between(date, LocalDate.now());
        } catch (Exception e) {
            return -1;
        }
    }

    public static boolean isEligibleToDonate(String lastDonationDate) {
        if (lastDonationDate == null || lastDonationDate.trim().isEmpty()) {
            return true; // never donated — eligible
        }
        return daysAgo(lastDonationDate) >= 90;
    }
}