package com.blooddonationmanagementsystem.controller;

import com.blooddonationmanagementsystem.model.User;
import com.blooddonationmanagementsystem.model.BloodRequest;
import com.blooddonationmanagementsystem.model.BloodInventory;
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
import java.util.Map;

@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/donors",
        "/admin/patients",
        "/admin/requests",
        "/admin/inventory",
        "/admin/reports"
})
public class AdminController extends HttpServlet {

    private final AdminService adminService = new AdminService();

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
            switch (path) {

                case "/admin/dashboard":
                    request.setAttribute("totalDonors", adminService.getTotalDonors());
                    request.setAttribute("totalPatients", adminService.getTotalPatients());
                    request.setAttribute("pendingApprovals", adminService.getPendingApprovals());
                    request.setAttribute("totalRequests", adminService.getTotalBloodRequests());
                    request.setAttribute("recentRequests", adminService.getAllBloodRequests());
                    request.setAttribute("inventory", adminService.getInventory());
                    request.getRequestDispatcher("/views/admin/dashboard.jsp")
                            .forward(request, response);
                    break;

                case "/admin/users":
                    String query = request.getParameter("search");
                    String filter = request.getParameter("filter");

                    if (query != null && !query.trim().isEmpty()) {
                        request.setAttribute("users", adminService.searchUsers(query));
                    } else if ("pending".equals(filter)) {
                        request.setAttribute("users", adminService.getPendingUsers());
                    } else if ("approved".equals(filter)) {
                        request.setAttribute("users", adminService.getApprovedUsers());
                    } else if ("rejected".equals(filter)) {
                        request.setAttribute("users", adminService.getRejectedUsers());
                    } else {
                        request.setAttribute("users", adminService.getAllUsers());
                    }
                    request.setAttribute("pendingUsers", adminService.getPendingUsers());
                    request.getRequestDispatcher("/views/admin/manageusers.jsp")
                            .forward(request, response);
                    break;

                case "/admin/donors":
                    request.setAttribute("donors", adminService.getAllDonors());
                    request.getRequestDispatcher("/views/admin/manageDonors.jsp")
                            .forward(request, response);
                    break;

                case "/admin/patients":
                    request.setAttribute("patients", adminService.getAllPatients());
                    request.getRequestDispatcher("/views/admin/managePatients.jsp")
                            .forward(request, response);
                    break;

                case "/admin/requests":
                    request.setAttribute("requests", adminService.getAllBloodRequests());
                    request.getRequestDispatcher("/views/admin/manageRequests.jsp")
                            .forward(request, response);
                    break;

                case "/admin/inventory":
                    request.setAttribute("inventory", adminService.getInventory());
                    request.getRequestDispatcher("/views/admin/inventory.jsp")
                            .forward(request, response);
                    break;

                case "/admin/reports":
                    request.setAttribute("inventory", adminService.getInventory());
                    request.setAttribute("totalDonors", adminService.getTotalDonors());
                    request.setAttribute("totalPatients", adminService.getTotalPatients());
                    request.setAttribute("totalRequests", adminService.getTotalBloodRequests());
                    request.setAttribute("allRequests", adminService.getAllRequests());
                    request.setAttribute("requestStats", adminService.getRequestStats());
                    request.getRequestDispatcher("/views/admin/reports.jsp")
                            .forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        try {
            if ("/admin/users".equals(path)) {
                int userId = Integer.parseInt(request.getParameter("userId"));

                if ("approve".equals(action)) {
                    adminService.approveUser(userId);
                } else if ("reject".equals(action)) {
                    adminService.rejectUser(userId);
                } else if ("delete".equals(action)) {
                    adminService.deleteUser(userId);
                } else if ("updateRole".equals(action)) {
                    String role = request.getParameter("role");
                    adminService.updateUserRole(userId, role);
                } else if ("editUser".equals(action)) {
                    String email = request.getParameter("email");
                    adminService.updateUserEmail(userId, email);
                }
                response.sendRedirect(request.getContextPath() + "/admin/users");

            } else if ("/admin/donors".equals(path)) {
                int donorId = Integer.parseInt(request.getParameter("donorId"));

                if ("delete".equals(action)) {
                    adminService.deleteDonor(donorId);
                } else if ("edit".equals(action)) {
                    String fullName   = request.getParameter("fullName");
                    String phone      = request.getParameter("phone");
                    String bloodGroup = request.getParameter("bloodGroup");
                    String address    = request.getParameter("address");
                    adminService.updateDonor(donorId, fullName, phone,
                            bloodGroup, address);
                }
                response.sendRedirect(request.getContextPath() + "/admin/donors");

            } else if ("/admin/patients".equals(path)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));

                if ("delete".equals(action)) {
                    adminService.deletePatient(patientId);
                } else if ("edit".equals(action)) {
                    String fullName     = request.getParameter("fullName");
                    String phone        = request.getParameter("phone");
                    String bloodGroup   = request.getParameter("bloodGroup");
                    String address      = request.getParameter("address");
                    String hospitalName = request.getParameter("hospitalName");
                    adminService.updatePatient(patientId, fullName, phone,
                            bloodGroup, address, hospitalName);
                }
                response.sendRedirect(request.getContextPath() + "/admin/patients");

            } else if ("/admin/requests".equals(path)) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                String status = request.getParameter("status");
                adminService.updateRequestStatus(requestId, status);
                response.sendRedirect(request.getContextPath() + "/admin/requests");

            } else if ("/admin/inventory".equals(path)) {
                String bloodGroup = request.getParameter("bloodGroup");
                int units = Integer.parseInt(request.getParameter("units"));
                adminService.updateInventory(bloodGroup, units);
                response.sendRedirect(request.getContextPath() + "/admin/inventory");

            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp")
                    .forward(request, response);
        }
    }
}