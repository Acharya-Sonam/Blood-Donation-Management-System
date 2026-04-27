package com.blooddonationmanagementsystem.model;

public class Donor {
    private int    donorId;
    private int    userId;          
    private String fullName;
    private String phone;           
    private String dateOfBirth;
    private String bloodGroup;
    private String address;
    private String lastDonation;   
    private String createdAt;

    public Donor() {}

    public Donor(int userId, String fullName, String phone,String dateOfBirth, String bloodGroup, String address) {
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.bloodGroup  = bloodGroup;
        this.address = address;
    }
    public int    getDonorId(){ 
        return donorId;     
    }
    public int    getUserId(){ 
        return userId;      
    }
    public String getFullName(){ 
        return fullName;    
    }
    public String getPhone(){ 
        return phone;       
    }
    public String getDateOfBirth(){ 
        return dateOfBirth; 
    }
    public String getBloodGroup(){ 
        return bloodGroup;  
    }
    public String getAddress(){ 
        return address;     
    }
    public String getLastDonation(){ 
        return lastDonation;
    }
    public String getCreatedAt()   { 
        return createdAt;   
    }

    public void setDonorId(int donorId){ 
        this.donorId = donorId;     
    }
    public void setUserId(int userId){
        this.userId = userId;      
    }
    public void setFullName(String fullName){
        this.fullName = fullName;
    }
    public void setPhone(String phone){
        this.phone= phone;       
    }
    public void setDateOfBirth(String dob){
        this.dateOfBirth  = dob;         
    }
    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup   = bloodGroup;  
    }
    public void setAddress(String address){
        this.address      = address;     
    }
    public void setLastDonation(String date){
        this.lastDonation = date;        
    }
    public void setCreatedAt(String createdAt){
        this.createdAt    = createdAt;   
    }
}