package com.blooddonationmanagementsystem.model;

public class BloodInventory {

    private int    inventoryId;
    private String bloodGroup;      
    private int    unitsAvailable;
    private String lastUpdated;      

    public BloodInventory() {}

    public BloodInventory(int inventoryId, String bloodGroup,int unitsAvailable, String lastUpdated) {
        this.inventoryId    = inventoryId;
        this.bloodGroup     = bloodGroup;
        this.unitsAvailable = unitsAvailable;
        this.lastUpdated    = lastUpdated;
    }

    public int    getInventoryId()    { 
        return inventoryId;    
    }
    public String getBloodGroup()     { 
        return bloodGroup;     
    }
    public int    getUnitsAvailable() { 
        return unitsAvailable; 
    }
    public String getLastUpdated()    { 
        return lastUpdated;    
    }

    public void setInventoryId(int inventoryId)        { 
        this.inventoryId    = inventoryId;    
    }
    public void setBloodGroup(String bloodGroup)       { 
        this.bloodGroup     = bloodGroup;     
    }
    public void setUnitsAvailable(int units)           { 
        this.unitsAvailable = units;          
    }
    public void setLastUpdated(String lastUpdated)     { 
        this.lastUpdated    = lastUpdated;    
    }

    public boolean isAvailable() {
        return this.unitsAvailable > 0;
    }
}
