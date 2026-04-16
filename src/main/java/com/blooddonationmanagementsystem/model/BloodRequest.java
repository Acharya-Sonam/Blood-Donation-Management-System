package com.blooddonationmanagementsystem.model;



public class BloodRequest {

    private int id;
    private int patientId;
    private String bloodGroup;
    private int quantity;
    private String urgency;
    private String status;
    private String requestDate;
    private String patientName;


    public int getId() { 
        return id; 
    }

    public int getPatientId() {
        return patientId; 
        }
        
    public String getBloodGroup() { 
        return bloodGroup; 
    }

    public void setId(int id) {
        this.id = id; 
        }
 
    public int getQuantity() { 
        return quantity; 
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId; 
        }

    public void setBloodGroup(String bloodGroup) { 
        this.bloodGroup = bloodGroup; 
    }

    public String getUrgency() { 
        return urgency; 
    }

    public String getStatus() { 
        return status; 
    }

    public String getRequestDate() { 
        return requestDate; 
    }

    public String getPatientName() { 
        return patientName; 
    }

    public void setQuantity(int quantity) { 
        this.quantity = quantity; 
    }

    public void setUrgency(String urgency) { 
        this.urgency = urgency; 
    }

    public void setStatus(String status) { 
        this.status = status; 
    }

    public void setRequestDate(String requestDate) { 
        this.requestDate = requestDate; 
    }

    public void setPatientName(String patientName) { 
        this.patientName = patientName; 
    }

}