<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.blooddonationmanagementsystem.model.User" %>
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
    <title>Patient Dashboard – Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        .welcome-card {
            background: linear-gradient(135deg, #c0392b 0%, #96281b 100%);
            border-radius: var(--radius);
            padding: 40px;
            color: white;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(192,57,43,0.2);
        }
        .welcome-card h2 { font-size: 2rem; font-weight: 800; margin-bottom: 10px; }
        .welcome-card p { opacity: 0.9; font-size: 1.1rem; }

        .action-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }
        .action-card {
            background: white;
            border-radius: var(--radius);
            padding: 30px 20px;
            text-align: center;
            text-decoration: none;
            color: var(--text-dark);
            box-shadow: var(--shadow);
            transition: transform 0.2s, box-shadow 0.2s;
            border-top: 4px solid var(--red-primary);
        }
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .action-card .icon { font-size: 2.5rem; margin-bottom: 15px; }
        .action-card h3 { font-size: 1.1rem; font-weight: 700; }
        .action-card p { font-size: 0.85rem; color: var(--text-muted); margin-top: 8px; }
    </style>
</head>
<body>

    <jsp:include page="patient-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>Patient Dashboard</h1>
            <div class="topbar-right">
                <span class="admin-badge">Verified Patient</span>
                <div class="user-info">
                    <strong><%= patientName != null ? patientName : "Patient" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="welcome-card">
                <h2>Welcome back, <%= patientName %>! 👋</h2>
                <p>How can we assist you today?</p>
            </div>

            <div class="section-title">🚀 Quick Actions</div>
            <div class="action-cards">
                <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors" class="action-card">
                    <div class="icon">🔍</div>
                    <h3>Search Donors</h3>
                    <p>Find available blood donors near you.</p>
                </a>

                <a href="<%= request.getContextPath() %>/PatientController?action=requestForm" class="action-card">
                    <div class="icon">💉</div>
                    <h3>Request Blood</h3>
                    <p>Post a new blood request for a patient.</p>
                </a>

                <a href="<%= request.getContextPath() %>/PatientController?action=myRequests" class="action-card">
                    <div class="icon">📜</div>
                    <h3>Track Requests</h3>
                    <p>Check the status of your active requests.</p>
                </a>

                <a href="<%= request.getContextPath() %>/views/patient/profile.jsp" class="action-card">
                    <div class="icon">👤</div>
                    <h3>My Profile</h3>
                    <p>Update your personal information.</p>
                </a>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>

</body>
</html>
