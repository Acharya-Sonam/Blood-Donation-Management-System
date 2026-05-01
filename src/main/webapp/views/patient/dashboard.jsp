<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 4/2/2026
  Time: 1:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Donor Dashboard – Blood Bridge</title>
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
        h2 { font-size: 1.6rem; color: #c0392b; margin-bottom: 24px; }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
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
    <span class="brand">🩸 Blood Bridge</span>
    <div>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Welcome, Donor! 👋</h2>
    <div class="cards">

        <a class="card" href="<%= request.getContextPath() %>/donor/dashboard?action=searchDonors">
            <div class="icon">🔍</div>
            <h3>Search Donors</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/views/donor/donationHistory.jsp">
            <div class="icon">📋</div>
            <h3>Donation History</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/views/donor/profile.jsp">
            <div class="icon">👤</div>
            <h3>My Profile</h3>
        </a>

        <a class="card" href="<%= request.getContextPath() %>/views/donor/wishlist.jsp">
            <div class="icon">❤️</div>
            <h3>Wishlist</h3>
        </a>

    </div>
</div>

</body>
</html>
