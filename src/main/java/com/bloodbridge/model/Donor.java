package com.bloodbridge.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Donor {

    private int id;
    private String name;
    private String bloodType;
    private String location;
    private String phone;
    private LocalDate lastDonationDate;
    private boolean isApproved;
    private String urgency;

    public Donor() {}

    public Donor(int id, String name, String bloodType, String location, String phone, LocalDate lastDonationDate, boolean isApproved) {
        this.id = id;
        this.name = name;
        this.bloodType = bloodType;
        this.location = location;
        this.phone = phone;
        this.lastDonationDate = lastDonationDate;
        this.isApproved = isApproved;
    }

    public boolean isEligible() {
        if (lastDonationDate == null) return true;
        long daysSince = ChronoUnit.DAYS.between(lastDonationDate, LocalDate.now());
        return daysSince >= 56;
    }

    public long getDaysSinceLastDonation() {
        if (lastDonationDate == null) return -1;
        return ChronoUnit.DAYS.between(lastDonationDate, LocalDate.now());
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBloodType() { return bloodType; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public LocalDate getLastDonationDate() { return lastDonationDate; }
    public void setLastDonationDate(LocalDate lastDonationDate) { this.lastDonationDate = lastDonationDate; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }

    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }

    public boolean isUrgent() { return "urgent".equals(urgency); }
}