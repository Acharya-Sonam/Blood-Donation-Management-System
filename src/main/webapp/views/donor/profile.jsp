<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.blooddonationmanagementsystem.model.Donor" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <jsp:include page="donor-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>My Profile</h1>
            <div class="topbar-right">
                <div class="user-info">
                    <strong><%= donorName != null ? donorName : "Donor" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="card" style="padding: 2rem;">
                <h2>Profile Details</h2>
                <p>Welcome, <%= donorName != null ? donorName : "Donor" %>! Manage your profile settings here.</p>
                <div style="margin-top: 1rem;">
                    <p><strong>Name:</strong> <%= donorName != null ? donorName : "Donor" %></p>
                    <p><strong>Role:</strong> Verified Donor</p>
                </div>
                
                <hr style="margin: 2rem 0; border: none; border-top: 1px solid #ddd;">
                
                <h3 style="color: #c0392b;">Danger Zone</h3>
                <p style="color: #666; font-size: 0.9rem; margin-bottom: 1rem;">Once you delete your account, there is no going back. Please be certain.</p>
                <form action="<%= request.getContextPath() %>/profile/delete" method="POST" onsubmit="return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone.');">
                    <button type="submit" class="btn" style="background-color: #c0392b; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">
                        Delete Account
                    </button>
                </form>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>
</body>
</html>
