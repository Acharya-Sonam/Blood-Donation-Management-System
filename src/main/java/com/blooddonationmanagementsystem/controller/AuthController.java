package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.service.AuthService;
import com.blooddonationmanagementsystem.service.AuthService.AuthException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            // If already logged in, redirect to appropriate dashboard
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                redirectToDashboard(request, response, (User) session.getAttribute("user"));
                return;
            }
            // Show login page
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);

        } else if ("/register".equals(path)) {
            // Show registration page
            request.getRequestDispatcher("/views/common/register.jsp").forward(request, response);

        } else if ("/logout".equals(path)) {
            // Destroy session and go to login
            handleLogout(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);

        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Attempt login via service layer
            User user = authService.login(email, password);

            // Create session and store user
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to the correct dashboard based on role or previous target
            redirectToDashboard(request, response, user);

        } catch (AuthException e) {
            // Show the specific error message on the login page
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log the error to terminal for debugging
            e.printStackTrace();
            
            // Database error — forward to error page
            request.setAttribute("errorMessage", "A system error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role         = request.getParameter("role");
        String fullName     = request.getParameter("fullName");
        String email        = request.getParameter("email");
        String password     = request.getParameter("password");
        String confirm      = request.getParameter("confirmPassword");
        String phone        = request.getParameter("phone");
        String dob          = request.getParameter("dateOfBirth");
        String bloodGroup   = request.getParameter("bloodGroup");
        String address      = request.getParameter("address");

        try {
            if ("donor".equals(role)) {
                // Register as donor
                authService.registerDonor(fullName, email, password,
                                          confirm, phone, dob, bloodGroup, address);

            } else if ("patient".equals(role)) {
                // Patient-only field
                String hospitalName = request.getParameter("hospitalName");
                authService.registerPatient(fullName, email, password,
                                            confirm, phone, dob, bloodGroup,
                                            address, hospitalName);
            } else {
                // No role selected
                request.setAttribute("errorMessage", "Please select a registration type (Donor or Patient).");
                request.getRequestDispatcher("/views/common/register.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/login?registered=true");

        } catch (AuthException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("role",       role);
            request.setAttribute("fullName",   fullName);
            request.setAttribute("email",      email);
            request.setAttribute("phone",      phone);
            request.setAttribute("bloodGroup", bloodGroup);
            request.setAttribute("address",    address);
            request.getRequestDispatcher("/views/common/register.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A system error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/views/common/register.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // destroy the session
        }
        response.sendRedirect(request.getContextPath() + "/login?logout=true");
    }

    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        HttpSession session = request.getSession(false);
        String targetURL = (session != null) ? (String) session.getAttribute("targetURL") : null;

        if (targetURL != null && !targetURL.isEmpty()) {
            // Clear the target URL so it doesn't affect future logins
            session.removeAttribute("targetURL");
            
            // Redirect to stored target (ensure it's absolute if needed, but path from filter is relative to context)
            if (targetURL.startsWith("/")) {
                response.sendRedirect(request.getContextPath() + targetURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/" + targetURL);
            }
        } else {
            // Default role-based redirection
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.isDonor()) {
                response.sendRedirect(request.getContextPath() + "/donor/dashboard");
            } else if (user.isPatient()) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        }
    }
}