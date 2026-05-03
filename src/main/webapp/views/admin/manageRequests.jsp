<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Blood Requests - Admin Panel</title>
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
                <h1>Blood Requests</h1>
                <p>Review and manage urgent blood requirements from patients.</p>
            </header>

            <c:if test="${not empty param.success}">
                <div style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 12px; margin-bottom: 2rem; font-weight: 600;">
                    Request status updated successfully.
                </div>
            </c:if>

            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Blood Group</th>
                            <th>Quantity (Units)</th>
                            <th>Urgency</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${requests}">
                            <tr>
                                <td>#${r.id}</td>
                                <td><strong>${r.patientName}</strong></td>
                                <td><span class="badge" style="background: var(--clr-primary); color: white;">${r.bloodGroup}</span></td>
                                <td>${r.quantity}</td>
                                <td>
                                    <span class="badge" style="background: ${r.urgency == 'Urgent' ? '#f8d7da' : '#eaf0fb'}; color: ${r.urgency == 'Urgent' ? '#721c24' : '#2c3e8c'};">
                                        ${r.urgency}
                                    </span>
                                </td>
                                <td>${r.requestDate}</td>
                                <td><span class="badge badge-pending">${r.status}</span></td>
                                <td>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <form action="${pageContext.request.contextPath}/admin/updaterequest" method="POST">
                                            <input type="hidden" name="requestId" value="${r.id}">
                                            <input type="hidden" name="status" value="Approved">
                                            <button type="submit" class="btn-action btn-approve">Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/updaterequest" method="POST">
                                            <input type="hidden" name="requestId" value="${r.id}">
                                            <input type="hidden" name="status" value="Rejected">
                                            <button type="submit" class="btn-action btn-reject">Reject</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 3rem; color: var(--clr-text-muted);">No pending requests found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
