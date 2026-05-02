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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("reset_email");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        if (newPassword != null && newPassword.equals(confirmPassword)) {
            String hashedPassword = PasswordUtil.hash(newPassword);
            try {
                boolean updated = userDAO.updatePassword(email, hashedPassword);

                if (updated) {
                    // Clear session attributes
                    session.removeAttribute("reset_otp");
                    session.removeAttribute("reset_email");
                    session.removeAttribute("otp_expiry");

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
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/views/common/reset-password.jsp").forward(request, response);
        }
    }
}
