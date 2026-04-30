<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null || !"Patient".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
        return;
    }
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Request Blood - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .card {
            background: white;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 460px;
        }
        h2 {
            color: #c0392b;
            text-align: center;
            margin-bottom: 20px;
            font-size: 22px;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #555;
            font-size: 14px;
        }
        select, input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            margin-top: 25px;
            background: #c0392b;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn-submit:hover { background: #a93226; }
        .msg-error   { color: red;   text-align: center; margin-bottom: 12px; font-size: 14px; }
        .msg-success { color: green; text-align: center; margin-bottom: 12px; font-size: 14px; }
        .bottom-link { text-align: center; margin-top: 15px; font-size: 13px; }
        .bottom-link a { color: #c0392b; text-decoration: none; }
        .bottom-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="card">
    <h2>🩸 Request Blood</h2>

    <% if ("error".equals(msg)) { %>
        <p class="msg-error">❌ Something went wrong. Please try again.</p>
    <% } %>
    <% if ("success".equals(msg)) { %>
        <p class="msg-success">✅ Request submitted successfully!</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/PatientController" method="post">
        <input type="hidden" name="action" value="submitRequest" />

        <label>Blood Group Required</label>
        <select name="bloodGroup" required>
            <option value="">-- Select Blood Group --</option>
            <option value="A+">A+</option>
            <option value="A-">A-</option>
            <option value="B+">B+</option>
            <option value="B-">B-</option>
            <option value="AB+">AB+</option>
            <option value="AB-">AB-</option>
            <option value="O+">O+</option>
            <option value="O-">O-</option>
        </select>

        <label>Quantity (units)</label>
        <input type="number" name="quantity" min="1" max="10" placeholder="e.g. 2" required />

        <label>Urgency Level</label>
        <select name="urgency" required>
            <option value="">-- Select Urgency --</option>
            <option value="Normal">Normal</option>
            <option value="Urgent">Urgent</option>
            <option value="Critical">Critical</option>
        </select>

        <button class="btn-submit" type="submit">Submit Request</button>
    </form>

    <div class="bottom-link">
        <a href="<%= request.getContextPath() %>/PatientController?action=trackRequest">
            📋 Track My Requests
        </a>
        &nbsp;|&nbsp;
        <a href="<%= request.getContextPath() %>/views/patient/dashboard.jsp">
            🏠 Dashboard
        </a>
    </div>
</div>
</body>
</html>