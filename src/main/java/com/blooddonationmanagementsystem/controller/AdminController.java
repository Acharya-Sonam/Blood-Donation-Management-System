package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.dao.UserDAO;
import com.blooddonationmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/approve", "/admin/reject"})
public class AdminController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        try {
            if ("/admin/dashboard".equals(path)) {
                List<User> pendingUsers = userDAO.getPendingUsers();
                request.setAttribute("pendingUsers", pendingUsers);
                request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/common/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = request.getServletPath();
        int userId = Integer.parseInt(request.getParameter("userId"));

        try {
            if ("/admin/approve".equals(path)) {
                userDAO.updateUserStatus(userId, "approved");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?approved=true");
            } else if ("/admin/reject".equals(path)) {
                userDAO.updateUserStatus(userId, "rejected");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?rejected=true");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=true");
        }
    }
}
