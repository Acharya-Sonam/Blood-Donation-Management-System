package com.blooddonationmanagementsystem.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.blooddonationmanagementsystem.model.BloodRequest;
import com.blooddonationmanagementsystem.model.Donor;
import com.blooddonationmanagementsystem.service.BloodRequestService;
import com.blooddonationmanagementsystem.service.PatientService;

/**
 * PatientController.java
 * -----------------------
 * Handles all patient-related HTTP requests.
 * Maps to: /PatientController and /patient/dashboard
 *
 * GET actions:
 *   - (none / dashboard) → patient dashboard
 *   - searchDonors       → search by blood group + location (Dikshya)
 *   - addToWishlist      → add donor to wishlist (Diya)
 *   - requestDonation    → redirect to request form for a donor (Diya)
 *   - requestForm        → show blood request form (Diya)
 *   - myRequests         → patient's own requests (Diya)
 *   - viewAllRequests    → all pending requests for donors (Diya)
 *
 * POST actions:
 *   - submitRequest  → submit a new blood request (Diya)
 *   - updateStatus   → update request status (Diya)
 *   - cancelRequest  → cancel a pending request (Diya)
 */
@WebServlet({"/PatientController", "/patient/dashboard"})
public class PatientController extends HttpServlet {

    // ── Services ──────────────────────────────────────────────────
    private BloodRequestService bloodRequestService = new BloodRequestService();
    private PatientService      patientService      = new PatientService();

    // ════════════════════════════════════════════════════════════
    //  GET — Show pages
    // ════════════════════════════════════════════════════════════

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ── Session check ─────────────────────────────────────
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(
                        request.getContextPath() + "/views/auth/login.jsp");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) action = "";

            // ── Route: /patient/dashboard URL with no action param ─
            if (action.isEmpty()
                    && "/patient/dashboard".equals(request.getServletPath())) {
                request.getRequestDispatcher("/views/patient/dashboard.jsp")
                        .forward(request, response);
                return;
            }

            // ── Route by action parameter ─────────────────────────

            if (action.isEmpty()) {
                // Default fallback — go to dashboard
                request.getRequestDispatcher("/views/patient/dashboard.jsp")
                        .forward(request, response);

                // ── DIYA: wishlist ────────────────────────────────────
            } else if (action.equals("addToWishlist")) {
                int donorId   = Integer.parseInt(request.getParameter("donorId"));
                int patientId = (int) session.getAttribute("userId");
                // TODO: Implement WishlistService to persist wishlist
                // For now: redirect with success flag
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=searchDonors&msg=wishlist_success");

                // ── DIYA: request donation from specific donor ─────────
            } else if (action.equals("requestDonation")) {
                int donorId = Integer.parseInt(request.getParameter("donorId"));
                // Redirect to request form with donor pre-selected
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=requestForm&donorId=" + donorId);

                // ── DIYA: show blood request form ──────────────────────
            } else if (action.equals("requestForm")) {
                request.getRequestDispatcher("/views/patient/requestBlood.jsp")
                        .forward(request, response);

                // ── DIYA: patient's own request history ────────────────
            } else if (action.equals("myRequests")) {
                int patientId = (int) session.getAttribute("userId");
                List<BloodRequest> requests =
                        bloodRequestService.getPatientRequests(patientId);
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/views/patient/trackRequest.jsp")
                        .forward(request, response);

                // ── DIYA: all pending requests (donor view) ────────────
            } else if (action.equals("viewAllRequests")) {
                List<BloodRequest> requests =
                        bloodRequestService.getAllPendingRequests();
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/views/donor/viewrequests.jsp")
                        .forward(request, response);

                // ── DIKSHYA: search donors by blood group + location ───
            } else if (action.equals("searchDonors")) {
                String bloodGroup = request.getParameter("bloodGroup");
                String location   = request.getParameter("location");

                List<Donor> donors =
                        patientService.searchDonors(bloodGroup, location);

                request.setAttribute("donors",     donors);
                request.setAttribute("bloodGroup", bloodGroup);
                request.setAttribute("location",   location);
                request.getRequestDispatcher("/views/patient/searchdonors.jsp")
                        .forward(request, response);

            } else {
                // Unknown action — fallback to dashboard
                request.getRequestDispatcher("/views/patient/dashboard.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "System error in PatientController (GET): " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp")
                    .forward(request, response);
        }
    }

    // ════════════════════════════════════════════════════════════
    //  POST — Process form submissions
    // ════════════════════════════════════════════════════════════

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ── Session check ─────────────────────────────────────
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(
                        request.getContextPath() + "/views/auth/login.jsp");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) action = "";

            // ── DIYA: submit a new blood request ──────────────────
            if (action.equals("submitRequest")) {
                int    patientId  = (int) session.getAttribute("userId");
                String bloodGroup = request.getParameter("bloodGroup");
                int    quantity   = Integer.parseInt(
                        request.getParameter("quantity"));
                String urgency    = request.getParameter("urgency");

                // Check: patient must not already have a pending request
                // for the same blood group (duplicate prevention)
                List<BloodRequest> existing =
                        bloodRequestService.getPatientRequests(patientId);
                boolean hasPending = existing.stream()
                        .anyMatch(r ->
                                r.getBloodGroup().equals(bloodGroup)
                                        && "Pending".equalsIgnoreCase(r.getStatus()));

                if (hasPending) {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=requestForm&msg=duplicate");
                    return;
                }

                // Build and submit the request
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
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=requestForm&msg=error");
                }

                // ── DIYA: update request status (donor/admin action) ──
            } else if (action.equals("updateStatus")) {
                int    requestId = Integer.parseInt(
                        request.getParameter("requestId"));
                String status    = request.getParameter("status");

                bloodRequestService.updateRequestStatus(requestId, status);
                response.sendRedirect(request.getContextPath()
                        + "/PatientController?action=viewAllRequests");

                // ── DIYA: patient cancels their own request ────────────
            } else if (action.equals("cancelRequest")) {
                int requestId = Integer.parseInt(
                        request.getParameter("requestId"));
                boolean success = bloodRequestService.cancelRequest(requestId);

                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=myRequests&msg=cancelled");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/PatientController?action=myRequests&msg=cancel_error");
                }

            } else {
                // Unknown POST action — return to dashboard
                response.sendRedirect(request.getContextPath()
                        + "/patient/dashboard");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "System error in PatientController (POST): " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp")
                    .forward(request, response);
        }
    }
}