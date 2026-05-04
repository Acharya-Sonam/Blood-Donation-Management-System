package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private final AdminService adminService = new AdminService();

    // GET REQUEST HANDLER 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!loggedInUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null) path = "/";

        try {
            switch (path) {
                case "/dashboard":
                case "/":
                    handleDashboard(request, response);
                    break;
                case "/manageusers":
                    handleManageUsers(request, response);
                    break;
                case "/requests":
                    handleRequests(request, response);
                    break;
                case "/inventory":
                    handleInventory(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    //POST REQUEST HANDLER 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!loggedInUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null) path = "/";

        try {
            switch (path) {
                case "/approve":
                    handleApprove(request, response);
                    break;
                case "/reject":
                    handleReject(request, response);
                    break;
                case "/delete":
                    handleDelete(request, response);
                    break;
                case "/updaterole":
                    handleUpdateRole(request, response);
                    break;
                case "/updateinventory":
                    handleUpdateInventory(request, response);
                    break;
                case "/updaterequest":
                    handleUpdateRequest(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/manageusers");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    //DASHBOARD 
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        request.setAttribute("totalDonors", adminService.getTotalDonors());
        request.setAttribute("totalPatients", adminService.getTotalPatients());
        request.setAttribute("pendingUsers", adminService.getPendingApprovals());
        request.setAttribute("pendingRequests", adminService.getTotalBloodRequests());
        
        request.setAttribute("inventory", adminService.getInventory());
        request.setAttribute("recentRequests", adminService.getAllBloodRequests());
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    //MANAGE USERS 
    private void handleManageUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String filter = request.getParameter("filter"); // pending, approved, rejected, all
        String search = request.getParameter("search");

        List<User> users;
        if (search != null && !search.trim().isEmpty()) {
            users = adminService.searchUsers(search.trim());
        } else if (filter == null || filter.equals("all")) {
            users = adminService.getAllUsers();
        } else {
            users = switch (filter) {
                case "pending"  -> adminService.getPendingUsers();
                case "approved" -> adminService.getApprovedUsers();
                case "rejected" -> adminService.getRejectedUsers();
                default         -> adminService.getAllUsers();
            };
        }

        request.setAttribute("users", users);
        request.setAttribute("filter", filter == null ? "all" : filter);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/views/admin/manageusers.jsp")
                .forward(request, response);
    }

    // BLOOD REQUESTS 
    private void handleRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("requests", adminService.getAllBloodRequests());
        request.getRequestDispatcher("/views/admin/manageRequests.jsp").forward(request, response);
    }

    // INVENTORY 
    private void handleInventory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("inventory", adminService.getInventory());
        request.getRequestDispatcher("/views/admin/inventory.jsp").forward(request, response);
    }

    //  APPROVE USER
    private void handleApprove(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        adminService.approveUser(userId);
        response.sendRedirect(request.getContextPath() + "/admin/manageusers?filter=pending&success=approved");
    }

    // REJECT USER 
    private void handleReject(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        adminService.rejectUser(userId);
        response.sendRedirect(request.getContextPath() + "/admin/manageusers?filter=pending&success=rejected");
    }

    //DELETE USER 
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        adminService.deleteUser(userId);
        response.sendRedirect(request.getContextPath() + "/admin/manageusers?success=deleted");
    }

    // UPDATE USER ROLE 
    private void handleUpdateRole(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String role = request.getParameter("role");
        adminService.updateUserRole(userId, role);
        response.sendRedirect(request.getContextPath() + "/admin/manageusers?success=roleupdated");
    }

    // UPDATE INVENTORY 
    private void handleUpdateInventory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String bloodGroup = request.getParameter("bloodGroup");
        int units = Integer.parseInt(request.getParameter("units"));
        String action = request.getParameter("action"); // add or remove

        if ("remove".equals(action)) {
            units = -units;
        }

        adminService.updateInventory(bloodGroup, units);
        response.sendRedirect(request.getContextPath() + "/admin/inventory?success=updated");
    }

    // UPDATE BLOOD REQUEST STATUS 
    private void handleUpdateRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String status = request.getParameter("status");
        adminService.updateRequestStatus(requestId, status);
        response.sendRedirect(request.getContextPath() + "/admin/requests?success=updated");
    }
}
