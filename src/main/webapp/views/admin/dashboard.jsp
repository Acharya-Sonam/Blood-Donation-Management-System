<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
</head>
<body class="ambient-page">

    <jsp:include page="../common/navbar.jsp" />

    <header class="page-header">
        <h1>Admin Dashboard</h1>
        <p>Manage system approvals and user records.</p>
    </header>

    <main class="container" style="max-width: 1000px; margin: 0 auto; padding: var(--spacing-md);">
        
        <div class="glass-card" style="padding: var(--spacing-lg);">
            <h2 style="margin-bottom: var(--spacing-md); color: var(--clr-secondary);">Pending Approvals</h2>

            <% if (request.getParameter("approved") != null) { %>
                <div class="alert alert-success">User approved successfully!</div>
            <% } %>
            <% if (request.getParameter("rejected") != null) { %>
                <div class="alert alert-error">User account rejected.</div>
            <% } %>

            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; margin-top: var(--spacing-md);">
                    <thead>
                        <tr style="border-bottom: 2px solid var(--clr-border); text-align: left;">
                            <th style="padding: 1rem;">Email</th>
                            <th style="padding: 1rem;">Role</th>
                            <th style="padding: 1rem;">Created At</th>
                            <th style="padding: 1rem;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<User> pendingUsers = (List<User>) request.getAttribute("pendingUsers");
                            if (pendingUsers != null && !pendingUsers.isEmpty()) {
                                for (User user : pendingUsers) {
                        %>
                            <tr style="border-bottom: 1px solid var(--clr-border);">
                                <td style="padding: 1rem;"><%= user.getEmail() %></td>
                                <td style="padding: 1rem;"><span class="badge" style="background: rgba(29, 53, 87, 0.1);"><%= user.getRole().toUpperCase() %></span></td>
                                <td style="padding: 1rem;"><%= user.getCreatedAt() %></td>
                                <td style="padding: 1rem; display: flex; gap: 0.5rem;">
                                    <form action="${pageContext.request.contextPath}/admin/approve" method="POST">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-primary" style="padding: 0.4rem 1rem; font-size: 0.8rem;">Approve</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/reject" method="POST">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-secondary" style="padding: 0.4rem 1rem; font-size: 0.8rem;">Reject</button>
                                    </form>
                                </td>
                            </tr>
                        <% 
                                }
                            } else { 
                        %>
                            <tr>
                                <td colspan="4" style="padding: 2rem; text-align: center; color: var(--clr-text-muted);">No pending registration requests.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

</body>
</html>
