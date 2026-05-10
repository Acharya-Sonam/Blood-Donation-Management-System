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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        if (action.equals("searchDonors")) {
            // DIKSHYA
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
            // Default — show donor dashboard
            request.getRequestDispatcher("/views/donor/dashboard.jsp")
                    .forward(request, response);
        }
    }
}
