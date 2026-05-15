package com.blooddonationmanagementsystem.service;

import com.blooddonationmanagementsystem.dao.BloodRequestDAO;
import com.blooddonationmanagementsystem.model.BloodRequest;
import java.util.List;

public class BloodRequestService {

    private BloodRequestDAO bloodRequestDAO = new BloodRequestDAO();

    public boolean submitRequest(BloodRequest request) {
        return bloodRequestDAO.submitRequest(request);
    }

    public List<BloodRequest> getPatientRequests(int patientId) {
        return bloodRequestDAO.getRequestsByPatient(patientId);
    }

    public List<BloodRequest> getAllPendingRequests() {
        return bloodRequestDAO.getAllPendingRequests();
    }

    public boolean updateRequestStatus(int requestId, String status) {
        return bloodRequestDAO.updateStatus(requestId, status);
    }

    public boolean cancelRequest(int requestId) {
        return bloodRequestDAO.deleteRequest(requestId);
    }

    public int getPendingRequestCount() {
        return getAllPendingRequests().size();
    }
}
