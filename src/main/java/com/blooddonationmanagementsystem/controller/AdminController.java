package com.blooddonationmanagementsystem.controller;

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
                    request.setAttribute("pendingApprovals", adminService.getPendingApprovals()
                );

                    request.setAttribute("totalRequests", adminService.getTotalBloodRequests());
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