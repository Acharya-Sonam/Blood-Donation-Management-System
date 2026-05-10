<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports | Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <!-- Top bar -->
        <header class="topbar">
            <h1>📈 System Reports</h1>
            <div class="topbar-right">
                <button onclick="window.print()" class="admin-badge" style="cursor: pointer; border: none;">🖨️ Print Report</button>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <div class="summary-row">
                <div class="summary-card">
                    <div class="s-num">${totalDonors}</div>
                    <div class="s-label">Registered Donors</div>
                </div>
                <div class="summary-card">
                    <div class="s-num">${totalPatients}</div>
                    <div class="s-label">Registered Patients</div>
                </div>
                <div class="summary-card">
                    <div class="s-num">${totalRequests}</div>
                    <div class="s-label">Pending Requests</div>
                </div>
            </div>

            <div class="section-title">📊 Blood Request Distribution</div>
            <div class="card">
                <div class="card-header">Requests by Blood Group</div>
                <div class="bar-chart">
                    <c:forEach var="entry" items="${requestStats}">
                        <div class="bar-row">
                            <div class="bar-label">${entry.key}</div>
                            <div class="bar-track">
                                <div class="bar-fill blue" style="width: ${entry.value * 10}%">
                                    ${entry.value} Requests
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty requestStats}">
                        <p style="text-align: center; padding: 20px; color: var(--text-muted);">No request statistics available.</p>
                    </c:if>
                </div>
            </div>

            <div class="section-title">📋 Full Blood Requests History</div>
            
            <div class="card" style="margin-bottom: 10px; padding: 12px; background: #fff;">
                <form style="display: flex; gap: 15px; align-items: center;">
                    <span style="font-size: 0.85rem; font-weight: 600; color: var(--text-muted);">Filter By:</span>
                    <select class="admin-badge" style="border: 1px solid var(--border); background: #fff; padding: 4px 10px;">
                        <option>All Blood Groups</option>
                        <option>A+</option><option>A-</option>
                        <option>B+</option><option>B-</option>
                        <option>O+</option><option>O-</option>
                        <option>AB+</option><option>AB-</option>
                    </select>
                    <select class="admin-badge" style="border: 1px solid var(--border); background: #fff; padding: 4px 10px;">
                        <option>All Status</option>
                        <option>Pending</option>
                        <option>Approved</option>
                        <option>Rejected</option>
                    </select>
                    <button type="button" class="logout-btn" style="padding: 4px 15px; font-size: 0.75rem;">Apply Filter</button>
                </form>
            </div>

            <div class="card">
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
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${allRequests}">
                                <tr>
                                    <td>${req.patientName}</td>
                                    <td><strong>${req.bloodGroup}</strong></td>
                                    <td>${req.quantity} Units</td>
                                    <td>
                                        <span class="badge ${req.urgency == 'Urgent' ? 'badge-rejected' : 'badge-accepted'}">${req.urgency}</span>
                                    </td>
                                    <td>${req.requestDate}</td>
                                    <td>
                                        <span class="badge ${req.status == 'Pending' ? 'badge-pending' : (req.status == 'Approved' || req.status == 'Accepted' ? 'badge-accepted' : 'badge-rejected')}">
                                            ${req.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allRequests}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 20px; color: var(--text-muted);">No requests found in history.</td>
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
