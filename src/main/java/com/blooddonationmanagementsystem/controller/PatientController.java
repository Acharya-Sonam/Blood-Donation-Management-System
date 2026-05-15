package com.blooddonationmanagementsystem.controller;

import java.io.IOException;
import java.util.List;

import com.blooddonationmanagementsystem.model.BloodRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.service.PatientService;
import com.blooddonationmanagementsystem.service.BloodRequestService;

@WebServlet({"/PatientController", "/patient/dashboard"})
public class PatientController extends HttpServlet {

    BloodRequestService bloodRequestService = new BloodRequestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Session check
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) action = "";

            // Handle /patient/dashboard URL directly (no action parameter)
            if (action.isEmpty() && request.getServletPath().equals("/patient/dashboard")) {
                request.getRequestDispatcher("/views/patient/dashboard.jsp")
                        .forward(request, response);
                return;
            }

            // --- DIYA'S PART ---
            if (action.equals("requestForm")) {
                request.getRequestDispatcher("/views/patient/requestBlood.jsp")
                        .forward(request, response);

            } else if (action.equals("myRequests")) {
                int patientId = (int) session.getAttribute("userId");
                List<BloodRequest> requests = bloodRequestService.getPatientRequests(patientId);
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/views/patient/trackRequest.jsp")
                        .forward(request, response);

            } else if (action.equals("viewAllRequests")) {
                List<BloodRequest> requests = bloodRequestService.getAllPendingRequests();
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/views/donor/viewrequests.jsp")
                        .forward(request, response);

                // --- DIKSHYA'S PART (search donors) ---
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

            } else {
                // Fallback — unknown action, go to patient dashboard
                request.getRequestDispatcher("/views/patient/dashboard.jsp")
                        .forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Interrupted in PatientController: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
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
                int patientId = (int) session.getAttribute("userId");
                String bloodGroup = request.getParameter("bloodGroup");
                int quantity      = Integer.parseInt(request.getParameter("quantity"));
                String urgency    = request.getParameter("urgency");

                BloodRequest br = new BloodRequest();
                br.setPatientId(patientId);
                br.setBloodGroup(bloodGroup);
                br.setQuantity(quantity);
                br.setUrgency(urgency);

                boolean success = bloodRequestService.submitRequest(br);

                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=myRequests&msg=success");
                } else {
                    // Fallback to form with error details
                    request.setAttribute("errorMessage", "Failed to submit blood request. This could be due to an existing pending request or a database error.");
                    request.getRequestDispatcher("/views/patient/requestBlood.jsp").forward(request, response);
                }

            } else if (action.equals("updateStatus")) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                String status = request.getParameter("status");

                bloodRequestService.updateRequestStatus(requestId, status);
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=viewAllRequests");

            } else if (action.equals("cancelRequest")) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                boolean success = bloodRequestService.cancelRequest(requestId);
                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=myRequests&msg=cancelled");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=myRequests&msg=cancel_error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Interrupted in PatientController POST: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}
