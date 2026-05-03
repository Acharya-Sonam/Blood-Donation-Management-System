<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory - Admin Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="admin-sidebar.jsp" />

        <main class="main-content">
            <header class="page-header">
                <h1>Blood Inventory</h1>
                <p>Current stock levels across all blood groups.</p>
            </header>

            <div class="stats-grid">
                <!-- Mocked inventory data for demonstration -->
                <div class="stat-card">
                    <h3>A+ Positive</h3>
                    <div class="value">24 <span style="font-size: 1rem; color: var(--clr-text-muted);">Units</span></div>
                </div>
                <div class="stat-card">
                    <h3>O- Negative</h3>
                    <div class="value" style="color: var(--clr-primary);">08 <span style="font-size: 1rem; color: var(--clr-text-muted);">Units</span></div>
                </div>
                <div class="stat-card">
                    <h3>B+ Positive</h3>
                    <div class="value">15 <span style="font-size: 1rem; color: var(--clr-text-muted);">Units</span></div>
                </div>
                <div class="stat-card">
                    <h3>AB+ Positive</h3>
                    <div class="value">12 <span style="font-size: 1rem; color: var(--clr-text-muted);">Units</span></div>
                </div>
            </div>

            <div class="table-container" style="margin-top: 2rem;">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>Blood Group</th>
                            <th>Available Units</th>
                            <th>Status</th>
                            <th>Last Updated</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>A+</strong></td>
                            <td>24 Units</td>
                            <td><span class="badge badge-approved">Stable</span></td>
                            <td>Today, 10:00 AM</td>
                        </tr>
                        <tr>
                            <td><strong>A-</strong></td>
                            <td>10 Units</td>
                            <td><span class="badge badge-pending">Low</span></td>
                            <td>Yesterday</td>
                        </tr>
                        <tr>
                            <td><strong>O-</strong></td>
                            <td>8 Units</td>
                            <td><span class="badge badge-rejected">Critical</span></td>
                            <td>Today, 08:30 AM</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
