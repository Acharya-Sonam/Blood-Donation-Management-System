package com.bloodbridge.controller;

import com.bloodbridge.model.Donor;
import com.bloodbridge.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/searchDonors")
public class PatientController extends HttpServlet {

    private final PatientService patientService = new PatientService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Check session — only logged in patients can search
       //HttpSession session = request.getSession(false);
       //if (session == null || session.getAttribute("loggedInUser") == null) {
            //response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            //return;
        //}

        try {
            List<Donor> donors = patientService.getAllDonors();
            long eligibleCount = patientService.countEligible(donors);

            request.setAttribute("donors", donors);
            request.setAttribute("eligibleCount", eligibleCount);
            request.setAttribute("totalCount", donors.size());
            request.setAttribute("bloodTypeStats", patientService.getBloodTypeStats());

            request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error. Please try again.");
            request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                    .forward(request, response);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        //HttpSession session = request.getSession(false);
        //if (session == null || session.getAttribute("loggedInUser") == null) {
            //response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            //return;
        //}

        String bloodType   = request.getParameter("bloodType");
        String location    = request.getParameter("location");
        String searchMode  = request.getParameter("searchMode");// "exact" or "compatible"
        String urgency = request.getParameter("urgency");

        try {
            List<Donor> donors;

            if ("compatible".equals(searchMode) && bloodType != null && !bloodType.isEmpty()) {
                donors = patientService.searchCompatibleDonors(bloodType, location, urgency);
            } else {
                donors = patientService.searchDonors(bloodType, location, urgency);
            }

            long eligibleCount = patientService.countEligible(donors);


            request.setAttribute("donors", donors);
            request.setAttribute("eligibleCount", eligibleCount);
            request.setAttribute("totalCount", donors.size());
            request.setAttribute("searchedBloodType", bloodType);
            request.setAttribute("searchedLocation", location);
            request.setAttribute("searchMode", searchMode);
            request.setAttribute("searchedUrgency", urgency);
            request.setAttribute("bloodTypeStats", patientService.getBloodTypeStats());

            request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error. Please try again.");
            request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                    .forward(request, response);
        }
    }
}