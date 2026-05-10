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
 
        // Session check - only admin allowed
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
 
        String path = request.getServletPath();
 
        try {
            switch (path) {
 
                case "/admin/dashboard":
                    // Load stats for dashboard
                    request.setAttribute("totalDonors",    adminService.getTotalDonors());
                    request.setAttribute("totalPatients",  adminService.getTotalPatients());
                    request.setAttribute("pendingApprovals", adminService.getPendingApprovals());
                    request.setAttribute("totalRequests", adminService.getTotalBloodRequests());
                    request.setAttribute("recentRequests", adminService.getAllBloodRequests()); // Pending requests as recent activity
                    request.setAttribute("inventory", adminService.getInventory());
                    request.getRequestDispatcher("/views/admin/dashboard.jsp")
                           .forward(request, response);
                    break;
 
                case "/admin/users":
                    // Manage users - search or list all
                    String query = request.getParameter("search");
                    if (query != null && !query.trim().isEmpty()) {
                        request.setAttribute("users", adminService.searchUsers(query));
                    } else {
                        request.setAttribute("users", adminService.getAllUsers());
                    }
                    request.setAttribute("pendingUsers",  adminService.getPendingUsers());
                    request.getRequestDispatcher("/views/admin/manageusers.jsp")
                           .forward(request, response);
                    break;
 
                case "/admin/donors":
                    request.setAttribute("users", adminService.getAllUsers());
                    request.getRequestDispatcher("/views/admin/manageDonors.jsp")
                           .forward(request, response);
                    break;
 
                case "/admin/patients":
                    request.setAttribute("users", adminService.getAllUsers());
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
                    request.setAttribute("totalDonors",   adminService.getTotalDonors());
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
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
 
        String path   = request.getServletPath();
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
                }
                response.sendRedirect(request.getContextPath() + "/admin/users");
 
            } else if ("/admin/requests".equals(path)) {
                int    requestId = Integer.parseInt(request.getParameter("requestId"));
                String status    = request.getParameter("status");
                adminService.updateRequestStatus(requestId, status);
                response.sendRedirect(request.getContextPath() + "/admin/requests");
 
            } else if ("/admin/inventory".equals(path)) {
                String bloodGroup = request.getParameter("bloodGroup");
                int    units      = Integer.parseInt(request.getParameter("units"));
                adminService.updateInventory(bloodGroup, units);
                response.sendRedirect(request.getContextPath() + "/admin/inventory");
 
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
 
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
        }
    }
}