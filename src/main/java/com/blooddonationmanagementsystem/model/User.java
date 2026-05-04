package com.blooddonationmanagementsystem.model;

public class User {

    // Fields 
    private int    userId;
    private String name; // Added for convenience in Admin views
    private String email;
    private String password;
    private String role;
    private String status;
    private String createdAt;

    // Constructors 
    public User() {}

    public User(int userId, String name, String email, String password,
                String role, String status, String createdAt) {
        this.userId    = userId;
        this.name      = name;
        this.email     = email;
        this.password  = password;
        this.role      = role;
        this.status    = status;
        this.createdAt = createdAt;
    }

    public int    getUserId() {
         return userId;  
    }
    public String getName() {
        return name;
    }
    public String getEmail() { 
        return email;   
    }
    public String getPassword() { 
        return password;
    }
    public String getRole(){ 
        return role;    
    }
    public String getStatus() { 
        return status;  
    }
    public String getCreatedAt() {
         return createdAt; 
    }

 
    public void setUserId(int userId) {
         this.userId    = userId;
         }
    public void setName(String name) {
        this.name = name;
    }
    public void setEmail(String email)  {
         this.email     = email;
        }
    public void setPassword(String password){
         this.password  = password;
          }
    public void setRole(String role)  {
         this.role      = role;
      }
    public void setStatus(String status) {
         this.status    = status;   
     }
    public void setCreatedAt(String createdAt){
         this.createdAt = createdAt;
 }
    public boolean isApproved() {
        return "approved".equals(this.status);
    }

    public boolean isAdmin() {
        return "admin".equals(this.role);
    }

    public boolean isDonor() {
        return "donor".equals(this.role);
    }

    public boolean isPatient() {
        return "patient".equals(this.role);
    }
}