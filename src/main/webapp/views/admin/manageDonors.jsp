<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Donors - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<jsp:include page="admin-sidebar.jsp" />

<main class="main-content">
    <header class="topbar">
        <h1>🩸 Manage Donors</h1>
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
            <div class="card-header">Donor Database</div>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Donor ID</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Blood Group</th>
                        <th>Address</th>
                        <th>Last Donation</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="d" items="${donors}">
                        <tr>
                            <td><span style="font-family: monospace;">#${d.donorId}</span></td>
                            <td><strong>${d.fullName}</strong></td>
                            <td>${d.phone}</td>
                            <td>
                                        <span class="admin-badge" style="background: #fadbd8; color: #c0392b;">
                                                ${d.bloodGroup}
                                        </span>
                            </td>
                            <td>${d.address}</td>
                            <td>${not empty d.lastDonation ? d.lastDonation : 'N/A'}</td>
                            <td>
                                <div style="display: flex; gap: 8px; justify-content: flex-end;">

                                        <%-- Edit button --%>
                                    <button type="button" class="admin-badge"
                                            onclick="openEditModal(
                                                    '${d.donorId}',
                                                    '${d.fullName}',
                                                    '${d.phone}',
                                                    '${d.bloodGroup}',
                                                    '${d.address}'
                                                    )"
                                            style="background: #eaf4fb; color: #1a5276;
                                                       border: 1px solid #85c1e9; cursor: pointer;">
                                        ✏️ Edit
                                    </button>

                                        <%-- Delete button --%>
                                    <form action="${pageContext.request.contextPath}/admin/donors"
                                          method="POST"
                                          onsubmit="return confirm('Delete this donor permanently?')"
                                          style="display:inline;">
                                        <input type="hidden" name="donorId" value="${d.donorId}">
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

                    <c:if test="${empty donors}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                <strong>No donors found.</strong>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<%-- Edit Donor Modal --%>
<div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%;
         height:100%; background:rgba(0,0,0,0.5); z-index:1000;
         align-items:center; justify-content:center;">
    <div style="background:white; padding:30px; border-radius:12px; width:450px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
        <h3 style="margin-bottom:20px;">✏️ Edit Donor Profile</h3>
        <form action="${pageContext.request.contextPath}/admin/donors" method="POST">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="donorId" id="editDonorId">

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

            <div style="margin-bottom:20px;">
                <label style="display:block; margin-bottom:5px; font-weight:600;">Address</label>
                <input type="text" name="address" id="editAddress"
                       style="width:100%; padding:10px; border-radius:8px; border:1px solid #ddd;" required>
            </div>

            <div style="display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" onclick="closeEditModal()"
                        style="padding:10px 20px; border-radius:8px; border:1px solid #ddd; cursor:pointer;">
                    Cancel
                </button>
                <button type="submit"
                        style="padding:10px 20px; border-radius:8px; background:#c0392b;
                               color:white; border:none; cursor:pointer;">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(donorId, fullName, phone, bloodGroup, address) {
        document.getElementById('editDonorId').value = donorId;
        document.getElementById('editFullName').value = fullName;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editBloodGroup').value = bloodGroup;
        document.getElementById('editAddress').value = address;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    document.getElementById('editModal').addEventListener('click', function(e) {
        if (e.target === this) closeEditModal();
    });
</script>

</body>
</html>