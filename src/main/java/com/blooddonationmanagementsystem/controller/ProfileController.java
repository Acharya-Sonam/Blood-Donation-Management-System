package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile/delete")
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            // Delete user. Cascading should take care of donors/patients table if configured
            // Otherwise, just delete the user, and the login will be prevented.
            userDAO.deleteUser(userId);
            
            // Invalidate session
            session.invalidate();
            
            // Redirect to home with a message
            response.sendRedirect(request.getContextPath() + "/login?logout=true");
            
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Failed to delete account: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}
