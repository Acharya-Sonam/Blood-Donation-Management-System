<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <jsp:include page="admin-sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <header class="page-header">
                <h1>Welcome, Admin</h1>
                <p>Here's what's happening with Blood Bridge today.</p>
            </header>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Donors</h3>
                    <div class="value">${totalDonors}</div>
                </div>
                <div class="stat-card">
                    <h3>Pending Approvals</h3>
                    <div class="value">${pendingApprovals}</div>
                </div>
                <div class="stat-card">
                    <h3>Pending Requests</h3>
                    <div class="value">${totalRequests}</div>
                </div>
            </div>

            <!-- Quick Actions / Recent Activity Placeholder -->
            <div style="margin-top: 2rem;">
                <h2 style="margin-bottom: 1rem; color: var(--clr-secondary);">Quick Actions</h2>
                <div style="display: flex; gap: 1rem;">
                    <a href="${pageContext.request.contextPath}/admin/manageusers?filter=pending" class="btn-action" style="padding: 1rem 2rem; display: inline-block;">Review Pending Users</a>
                    <a href="${pageContext.request.contextPath}/admin/requests" class="btn-action" style="padding: 1rem 2rem; display: inline-block;">Manage Blood Requests</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
