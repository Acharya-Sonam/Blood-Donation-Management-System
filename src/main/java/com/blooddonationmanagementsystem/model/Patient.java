package com.blooddonationmanagementsystem.model;

public class Patient {

    private int    patientId;
    private int    userId;          
    private String fullName;
    private String phone;           
    private String dateOfBirth;
    private String bloodGroup;
    private String address;
    private String hospitalName;   
    private String createdAt;

    public Patient() {}

    public Patient(int userId, String fullName, String phone,String dateOfBirth, String bloodGroup,
    String address, String hospitalName) {
        this.userId       = userId;
        this.fullName     = fullName;
        this.phone        = phone;
        this.dateOfBirth  = dateOfBirth;
        this.bloodGroup   = bloodGroup;
        this.address      = address;
        this.hospitalName = hospitalName;
    }

    public int    getPatientId(){
        return patientId;    
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
    public String getHospitalName(){ 
        return hospitalName; 
    }
    public String getCreatedAt(){ 
        return createdAt;    
    }


    public void setPatientId(int patientId){
        this.patientId = patientId;    
    }
    public void setUserId(int userId){
        this.userId = userId;       
    }
    public void setFullName(String fullName){
        this.fullName = fullName;     
    }
    public void setPhone(String phone){
        this.phone = phone;        
    }
    public void setDateOfBirth(String dob){
        this.dateOfBirth = dob;          
    }
    public void setBloodGroup(String bloodGroup){
        this.bloodGroup = bloodGroup;   
    }
    public void setAddress(String address){
        this.address = address;      
    }
    public void setHospitalName(String hospital){
        this.hospitalName = hospital;     
    }
    public void setCreatedAt(String createdAt){
        this.createdAt = createdAt;    
    }
}