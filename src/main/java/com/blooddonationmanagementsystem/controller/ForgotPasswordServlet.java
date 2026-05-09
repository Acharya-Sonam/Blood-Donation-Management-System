package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        try {
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                // Generate 6-digit OTP
                String otp = String.format("%06d", new Random().nextInt(999999));
                
                // Store OTP and email in session with expiry (10 minutes)
                HttpSession session = request.getSession();
                session.setAttribute("reset_otp", otp);
                session.setAttribute("reset_email", email);
                session.setAttribute("otp_expiry", System.currentTimeMillis() + (10 * 60 * 1000));

                // Send Email
                boolean emailSent = EmailUtil.sendOTP(email, otp);
                if (emailSent) {
                    request.setAttribute("message", "OTP sent successfully to " + email);
                    request.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to send OTP. Please try again.");
                    request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "No account found with this email.");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred.");
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
        }
    }
}
