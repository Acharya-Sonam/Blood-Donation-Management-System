<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Patients - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<jsp:include page="admin-sidebar.jsp" />

<main class="main-content">
    <header class="topbar">
        <h1>🏥 Manage Patients</h1>
        <div class="topbar-right">
            <span class="admin-badge">Administrator</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </header>

    <div class="page-body">

        <%-- Success message --%>
        <c:if test="${not empty param.success}">
            <div style="margin-bottom: 20px; padding: 15px; background: #eafaf1;
                     color: #1e8449; border: 1px solid #82e0aa; border-radius: 8px;">
                ✅ Action completed successfully!
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">Patient Database</div>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Patient ID</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Blood Group</th>
                        <th>Hospital</th>
                        <th>Address</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${patients}">
                        <tr>
                            <td><span style="font-family: monospace;">#${p.patientId}</span></td>
                            <td><strong>${p.fullName}</strong></td>
                            <td>${p.phone}</td>
                            <td>
                                        <span class="admin-badge" style="background: #fadbd8; color: #c0392b;">
                                                ${p.bloodGroup}
                                        </span>
                            </td>
                            <td>${p.hospitalName}</td>
                            <td>${p.address}</td>
                            <td>
                                <div style="display: flex; gap: 8px; justify-content: flex-end;">

                                        <%-- Edit button --%>
                                    <button type="button" class="admin-badge"
                                            onclick="openEditModal(
                                                    '${p.patientId}',
                                                    '${p.fullName}',
                                                    '${p.phone}',
                                                    '${p.bloodGroup}',
                                                    '${p.address}',
                                                    '${p.hospitalName}'
                                                    )"
                                            style="background: #eaf4fb; color: #1a5276;
                                                       border: 1px solid #85c1e9; cursor: pointer;">
                                        ✏️ Edit
                                    </button>

                                        <%-- Delete button --%>
                                    <form action="${pageContext.request.contextPath}/admin/patients"
                                          method="POST"
                                          onsubmit="return confirm('Delete this patient permanently?')"
                                          style="display:inline;">
                                        <input type="hidden" name="patientId" value="${p.patientId}">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit" class="admin-badge"
                                                style="background: #fdedec; color: #cb4335;
                                                           border: 1px solid #f1948a; cursor: pointer;">
                                            🗑️ Delete
                                        </button>
                                    </form>

                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty patients}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                <strong>No patients found.</strong>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<%-- Edit Patient Modal --%>
<div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%;
         height:100%; background:rgba(0,0,0,0.5); z-index:1000;
         align-items:center; justify-content:center;">
    <div style="background:white; padding:30px; border-radius:12px; width:450px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
        <h3 style="margin-bottom:20px;">✏️ Edit Patient Profile</h3>
        <form action="${pageContext.request.contextPath}/admin/patients" method="POST">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="patientId" id="editPatientId">

            <div style="margin-bottom:15px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Full Name</label>
                <input type="text" name="fullName" id="editFullName"
                       style="width:100%; padding:10px; border-radius:8px; border:1px solid #ddd;" required>
            </div>

            <div style="margin-bottom:15px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Phone</label>
                <input type="text" name="phone" id="editPhone"
                       style="width:100%; padding:10px; border-radius:8px; border:1px solid #ddd;" required>
            </div>

            <div style="margin-bottom:15px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Blood Group</label>
                <select name="bloodGroup" id="editBloodGroup"
                        style="width:100%; padding:10px; border-radius:8px; border:1px solid #ddd;">
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                </select>
            </div>

            <div style="margin-bottom:15px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Hospital Name</label>
                <input type="text" name="hospitalName" id="editHospitalName"
                       style="width:100%; padding:10px; border-radius:8px; border:1px solid #ddd;" required>
            </div>

            <div style="margin-bottom:20px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Address</label>
                <input type="text" name="address" id="editAddress"
                       style="width:100%; padding:10px; border-radius:8px; border: