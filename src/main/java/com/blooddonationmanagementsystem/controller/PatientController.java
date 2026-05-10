package com.blooddonationmanagementsystem.controller;

import java.io.IOException;
import java.util.List;

import com.blooddonationmanagementsystem.dao.BloodRequestDAO;
import com.blooddonationmanagementsystem.model.BloodRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.service.PatientService;


@WebServlet("/PatientController")
public class PatientController extends HttpServlet{

    BloodRequestDAO bloodRequestDAO = new BloodRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        // --- DIYA'S PART ---
        if (action.equals("requestForm")) {
            // Show the blood request form
            request.getRequestDispatcher("/views/patient/requestBlood.jsp")
                   .forward(request, response);

        } else if (action.equals("myRequests")) {
            // Show patient's own request history
            int patientId = (int) session.getAttribute("userId");
            List<BloodRequest> requests = bloodRequestDAO.getRequestsByPatient(patientId);
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/views/patient/trackRequest.jsp")
                   .forward(request, response);

        } else if (action.equals("viewAllRequests")) {
            // Donor views all pending requests
            List<BloodRequest> requests = bloodRequestDAO.getAllPendingRequests();
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/views/donor/dashboard.jsp")
                   .forward(request, response);


        // --- DIKSHYA'S PART (search donors) goes below this ---
        } else if (action.equals("searchDonors")) {
            String bloodGroup = request.getParameter("bloodGroup");
            String location   = request.getParameter("location");

            PatientService patientService = new PatientService();
            List<Donor> donors = patientService.searchDonors(bloodGroup, location);

            request.setAttribute("donors", donors);
            request.setAttribute("bloodGroup", bloodGroup);
            request.setAttribute("location", location);
            request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                    .forward(request, response);
        }
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        // --- DIYA'S PART ---
        if (action.equals("submitRequest")) {
            // Patient submits blood request
            int patientId = (int) session.getAttribute("userId");
            String bloodGroup = request.getParameter("bloodGroup");
            int quantity     = Integer.parseInt(request.getParameter("quantity"));
            String urgency   = request.getParameter("urgency");

            BloodRequest br = new BloodRequest();
            br.setPatientId(patientId);
            br.setBloodGroup(bloodGroup);
            br.setQuantity(quantity);
            br.setUrgency(urgency);

            // Check if patient already has a pending request for this blood group
            if (bloodRequestDAO.hasPendingRequest(patientId, bloodGroup)) {
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=requestForm&msg=duplicate");
                return;
            }

            boolean success = bloodRequestDAO.submitRequest(br);

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=myRequests&msg=success");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=requestForm&msg=error");
            }

        } else if (action.equals("updateStatus")) {
            // Donor accepts or rejects a request
            int requestId  = Integer.parseInt(request.getParameter("requestId"));
            String status  = request.getParameter("status");

            bloodRequestDAO.updateStatus(requestId, status);
            response.sendRedirect(request.getContextPath()
                    + "/PatientController?action=viewAllRequests");
        } else if (action.equals("cancelRequest")) {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            boolean success = bloodRequestDAO.deleteRequest(requestId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/PatientController?action=myRequests&msg=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/PatientController?action=myRequests&msg=cancel_error");
            }
        }
    }
}