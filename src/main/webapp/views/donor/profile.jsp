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
                <p>Welcome, <%= donorName %>! Manage your profile settings here.</p>
                <!-- Add form or profile info as needed -->
                <div style="margin-top: 1rem;">
                    <p><strong>Name:</strong> <%= donorName %></p>
                    <p><strong>Role:</strong> Verified Donor</p>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
