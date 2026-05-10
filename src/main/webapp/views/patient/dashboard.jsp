<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    java.lang.String patientName = (java.lang.String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard – Blood Bridge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f5f5f5; }
        .navbar {
            background: #c0392b; color: white;
            padding: 14px 30px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .navbar .brand { font-size: 1.4rem; font-weight: bold; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 960px; margin: 40px auto; padding: 0 20px; }
        .welcome {
            background: white; border-radius: 10px;
            padding: 20px 25px; margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .welcome h2 { color: #c0392b; font-size: 1.4rem; }
        .welcome p { color: #666; margin-top: 5px; font-size: 14px; }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        .card {
            background: white; border-radius: 10px;
            padding: 28px 20px; text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-top: 4px solid #c0392b;
            text-decoration: none; color: #333;
            transition: transform 0.15s;
        }
        .card:hover { transform: translateY(-4px); }
        .card .icon { font-size: 2.2rem; margin-bottom: 12px; }
        .card h3 { font-size: 1rem; color: #222; }
    </style>
</head>
<body>

<div class="navbar">
    <span class="brand">&#128149; Blood Bridge</span>
    <div>
        <a href="<%= request.getContextPath() %>/PatientController?action=requestForm">Request Blood</a>
        <a href="<%= request.getContextPath() %>/PatientController?action=myRequests">My Requests</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">

    <div class="welcome">
        <h2>Welcome, <%= patientName != null ? patientName : "Patient" %>! &#128075;</h2>
        <p>What would you like to do today?</p>
    </div>

    <div class="cards">

        <a class="card" href="<%= request.getContextPath() %>/PatientController?action=searchDonors">
            <div class="icon">&#128269;</div>
            <h3>Search Donors</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/PatientController?action=requestForm">
            <div class="icon">&#128137;</div>
            <h3>Request Blood</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/PatientController?action=myRequests">
            <div class="icon">&#128203;</div>
            <h3>Track Requests</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/views/patient/profile.jsp">
            <div class="icon">&#128100;</div>
            <h3>My Profile</h3>
        </a>

    </div>
</div>

</body>
</html>
