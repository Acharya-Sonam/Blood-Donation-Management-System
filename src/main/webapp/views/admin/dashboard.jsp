<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <!-- Top bar -->
        <header class="topbar">
            <h1>📊 System Overview</h1>
            <div class="topbar-right">
                <span class="admin-badge">Administrator</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <div class="stats-grid">
                <div class="stat-card blue">
                    <span class="stat-icon">👥</span>
                    <span class="stat-number">${totalDonors}</span>
                    <span class="stat-label">Total Donors</span>
                </div>
                <div class="stat-card green">
                    <span class="stat-icon">🏥</span>
                    <span class="stat-number">${totalPatients}</span>
                    <span class="stat-label">Total Patients</span>
                </div>
                <div class="stat-card orange">
                    <span class="stat-icon">🔔</span>
                    <span class="stat-number">${pendingApprovals}</span>
                    <span class="stat-label">Pending Approvals</span>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">🩸</span>
                    <span class="stat-number">${totalRequests}</span>
                    <span class="stat-label">Active Requests</span>
                </div>
            </div>

            <div class="section-title">🕒 Recent Blood Requests</div>
            <div class="card">
                <div class="card-header">Latest Pending Requests</div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Blood Group</th>
                                <th>Quantity</th>
                                <th>Urgency</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${recentRequests}">
                                <tr>
                                    <td>${req.patientName}</td>
                                    <td><strong>${req.bloodGroup}</strong></td>
                                    <td>${req.quantity} Units</td>
                                    <td>
                                        <span class="badge ${req.urgency == 'Urgent' ? 'badge-rejected' : 'badge-accepted'}">${req.urgency}</span>
                                    </td>
                                    <td>${req.requestDate}</td>
                                    <td><span class="badge badge-pending">${req.status}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/requests" class="admin-badge" style="text-decoration: none;">Manage</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentRequests}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 20px; color: var(--text-muted);">No pending requests found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
