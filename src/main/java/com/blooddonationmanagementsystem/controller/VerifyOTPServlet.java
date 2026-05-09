package com.blooddonationmanagementsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        
        String storedOtp = (String) session.getAttribute("reset_otp");
        Long expiry = (Long) session.getAttribute("otp_expiry");

        if (storedOtp != null && expiry != null && System.currentTimeMillis() < expiry) {
            if (storedOtp.equals(enteredOtp)) {
                // Mark OTP as verified in session
                session.setAttribute("otp_verified", true);
                
                request.setAttribute("message", "OTP verified. Please set your new password.");
                request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Invalid OTP. Please try again.");
                request.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "OTP expired or not found. Please request a new one.");
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
        }
    }
}
