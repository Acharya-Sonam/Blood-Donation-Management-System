package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean verified = (Boolean) session.getAttribute("otp_verified");
        
        if (verified != null && verified) {
            request.getRequestDispatcher("/views/common/reset-password.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("reset_email");
        Boolean verified = (Boolean) session.getAttribute("otp_verified");

        if (email == null || verified == null || !verified) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        if (newPassword != null && !newPassword.isEmpty() && newPassword.equals(confirmPassword)) {
            String hashedPassword = PasswordUtil.hash(newPassword);
            try {
                boolean updated = userDAO.updatePassword(email, hashedPassword);

                if (updated) {
                    // Clear all reset session attributes
                    session.removeAttribute("reset_otp");
                    session.removeAttribute("reset_email");
                    session.removeAttribute("otp_expiry");
                    session.removeAttribute("otp_verified");

                    request.setAttribute("message", "Password reset successfully! You can now log in.");
                    request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to update password. Please try again.");
                    request.getRequestDispatcher("/views/common/reset-password.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred.");
                request.getRequestDispatcher("/views/common/reset-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Passwords do not match or are empty.");
            request.getRequestDispatcher("/views/common/reset-password.jsp").forward(request, response);
        }
    }
}
