package com.blooddonationmanagementsystem.model;

public class Donation {

    private int donationId;
    private int donorId;         
    private int requestId;       
    private int unitsDonated;
    private String donationDate;
    private String status;         
    private int inventoryId;   

    public Donation() {}

    public Donation(int donorId, int requestId, int unitsDonated,
                    String donationDate, int inventoryId) {
        this.donorId = donorId;
        this.requestId = requestId;
        this.unitsDonated = unitsDonated;
        this.donationDate = donationDate;
        this.inventoryId  = inventoryId;
        this.status = "scheduled"; 
    }

    public Donation(int donorId, int unitsDonated,
                    String donationDate, int inventoryId) {
        this.donorId = donorId;
        this.requestId = 0;     
        this.unitsDonated = unitsDonated;
        this.donationDate = donationDate;
        this.inventoryId = inventoryId;
        this.status = "scheduled";
    }

    public int getDonationId(){
        return donationId;   
    }
    public int getDonorId(){ 
        return donorId;      
    }
    public int getRequestId(){
        return requestId;    
    }
    public int getUnitsDonated(){
        return unitsDonated; 
    }
    public String getDonationDate(){
        return donationDate; 
    }
    public String getStatus(){ 
        return status;       
    }
    public int getInventoryId(){ 
        return inventoryId;  
    }

    public void setDonationId(int donationId){ 
        this.donationId = donationId;   
    }
    public void setDonorId(int donorId){ 
        this.donorId = donorId;      
    }
    public void setRequestId(int requestId){ 
        this.requestId = requestId;    
    }
    public void setUnitsDonated(int units){ 
        this.unitsDonated = units;  
    }
    public void setDonationDate(String date){ 
        this.donationDate = date;         
    }
    public void setStatus(String status){ 
        this.status = status;       
    }
    public void setInventoryId(int inventoryId){ 
        this.inventoryId = inventoryId;  
    }

    public boolean isCompleted() {
        return "completed".equals(this.status);
    }

    public boolean isWalkIn() {
        return this.requestId == 0;
    }
}
