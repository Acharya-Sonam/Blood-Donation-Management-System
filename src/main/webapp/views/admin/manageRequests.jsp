<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Blood Requests - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>🩸 Manage Blood Requests</h1>
            <div class="topbar-right">
                <span class="admin-badge">Administrator</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <div class="card">
                <div class="card-header">Pending & Active Requests</div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Blood Group</th>
                                <th>Quantity</th>
                                <th>Urgency</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${requests}">
                                <tr>
                                    <td>#${r.id}</td>
                                    <td>${r.patientName}</td>
                                    <td><strong>${r.bloodGroup}</strong></td>
                                    <td>${r.quantity} Units</td>
                                    <td><span class="badge ${r.urgency == 'Urgent' ? 'badge-rejected' : 'badge-accepted'}">${r.urgency}</span></td>
                                    <td><span class="badge badge-pending">${r.status}</span></td>
                                    <td>${r.requestDate}</td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                                            <form action="${pageContext.request.contextPath}/admin/requests" method="POST">
                                                <input type="hidden" name="requestId" value="${r.id}">
                                                <input type="hidden" name="status" value="Approved">
                                                <button type="submit" class="admin-badge" style="color: #1e8449; background: #eafaf1; cursor: pointer; border: 1px solid #82e0aa;">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/requests" method="POST">
                                                <input type="hidden" name="requestId" value="${r.id}">
                                                <input type="hidden" name="status" value="Rejected">
                                                <button type="submit" class="admin-badge" style="color: #cb4335; background: #fdedec; cursor: pointer; border: 1px solid #f1948a;">Reject</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty requests}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                        No pending blood requests found.
                                    </td>
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
