package com.blooddonationmanagementsystem.controller;

package com.blooddonationmanagementsystem.controller;
 
import com.blooddonationmanagementsystem.model.Donation;
import com.blooddonationmanagementsystem.service.DonationService;
import com.blooddonationmanagementsystem.service.DonorService;
 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
 
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/donor/donations",
    "/donor/donationHistory"
})
public class DonationController extends HttpServlet {
 
    private final DonationService donationService = new DonationService();
    private final DonorService    donorService    = new DonorService();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
 
        int    userId = (int) session.getAttribute("userId");
        String path   = request.getServletPath();
 
        try {
            if ("/donor/donationHistory".equals(path)) {
                // Show donation history page
                List<Donation> history = donationService.getDonationHistory(userId);
 
                request.setAttribute("donations",      history);
                request.setAttribute("totalDonations", donationService.getDonationCount(userId));
                request.setAttribute("lastDonation",   donationService.getLastDonationDate(userId));
                request.setAttribute("nextEligible",   donationService.getNextEligibleDate(userId));
                request.setAttribute("isEligible",     donationService.isEligibleToDonate(userId));

                 request.getRequestDispatcher("/views/donor/donationHistory.jsp")
                       .forward(request, response);
 
            } else {
                // Show donate form (/donor/donations)
                boolean eligible = donationService.isEligibleToDonate(userId);
                request.setAttribute("isEligible",   eligible);
                request.setAttribute("nextEligible", donationService.getNextEligibleDate(userId));
 
                request.getRequestDispatcher("/views/donor/donations.jsp")
                       .forward(request, response);
            }
 
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }