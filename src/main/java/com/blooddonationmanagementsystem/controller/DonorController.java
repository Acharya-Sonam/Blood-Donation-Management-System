package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/donor/dashboard")
public class DonorController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        if (action == null) action = "";

        com.blooddonationmanagementsystem.service.BloodRequestService requestService = new com.blooddonationmanagementsystem.service.BloodRequestService();
        com.blooddonationmanagementsystem.service.DonationService donationService = new com.blooddonationmanagementsystem.service.DonationService();
        com.blooddonationmanagementsystem.service.DonorService donorService = new com.blooddonationmanagementsystem.service.DonorService();

        try {
            if (action.equals("searchDonors")) {
                String bloodGroup = request.getParameter("bloodGroup");
                String location   = request.getParameter("location");

                com.blooddonationmanagementsystem.service.PatientService patientService = new com.blooddonationmanagementsystem.service.PatientService();
                List<Donor> donors = patientService.searchDonors(bloodGroup, location);

                request.setAttribute("donors", donors);
                request.setAttribute("bloodGroup", bloodGroup);
                request.setAttribute("location", location);
                request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                        .forward(request, response);

            } else {
                // Fetch stats for donor dashboard
                Donor donor = donorService.getDonorByUserId(userId);
                int donationCount = donationService.getDonationCount(userId);
                boolean eligible = donationService.isEligibleToDonate(userId);
                String nextDate = donationService.getNextEligibleDate(userId);
                List<com.blooddonationmanagementsystem.model.BloodRequest> pendingRequests = requestService.getAllPendingRequests();

                request.setAttribute("donor", donor);
                request.setAttribute("donationCount", donationCount);
                request.setAttribute("isEligible", eligible);
                request.setAttribute("nextEligibleDate", nextDate);
                request.setAttribute("requests", pendingRequests);

                request.getRequestDispatcher("/views/donor/dashboard.jsp")
                        .forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
