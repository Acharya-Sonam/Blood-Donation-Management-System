<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String patientName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <jsp:include page="patient-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>👤 My Profile</h1>
            <div class="topbar-right">
                <span class="admin-badge">Patient</span>
                <div class="user-info">
                    <strong><%= patientName != null ? patientName : "User" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="card" style="padding: 40px;">
                <div class="section-title">Profile Information</div>
                <div style="margin-bottom: 40px;">
                    <p>Welcome back, <strong><%= patientName %></strong>! Your account is verified and active.</p>
                    <div style="margin-top: 20px; display: flex; flex-direction: column; gap: 10px;">
                        <div><strong>Role:</strong> Patient</div>
                        <div><strong>Account Status:</strong> <span class="badge badge-accepted">Verified</span></div>
                    </div>
                </div>
                
                <div class="section-title" style="color: var(--red-primary);">Danger Zone</div>
                <div style="background: #fdedec; padding: 20px; border-radius: 8px; border: 1px solid #f5b7b1;">
                    <h3 style="color: #cb4335; margin-bottom: 10px;"><i class="fas fa-exclamation-triangle"></i> Delete Account</h3>
                    <p style="color: #666; font-size: 14px; margin-bottom: 20px;">Once you delete your account, there is no going back. Please be certain.</p>
                    <form action="<%= request.getContextPath() %>/profile/delete" method="POST" onsubmit="return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone.');">
                        <button type="submit" class="logout-btn" style="border: none; cursor: pointer; font-weight: 700;">
                            <i class="fas fa-trash-alt"></i> Confirm Deletion
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>

</body>
</html>
