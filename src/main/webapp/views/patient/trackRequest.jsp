<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.BloodRequest" %>
<%
    if (session.getAttribute("userId") == null || !"Patient".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
        return;
    }
    List<BloodRequest> requests = (List<BloodRequest>) request.getAttribute("requests");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Track Requests - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 30px; }
        .container {
            max-width: 870px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h2 { color: #c0392b; font-size: 22px; }
        .btn {
            padding: 9px 18px;
            background: #c0392b;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn:hover { background: #a93226; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th {
            background: #c0392b;
            color: white;
            padding: 11px;
            text-align: left;
            font-size: 14px;
        }
        td { padding: 11px; border-bottom: 1px solid #eee; font-size: 14px; }
        tr:hover td { background: #fdf2f2; }

        /* Status badges */
        .badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        .Pending   { background: #fef9c3; color: #92400e; }
        .Approved  { background: #d1fae5; color: #065f46; }
        .Fulfilled { background: #dbeafe; color: #1e40af; }
        .Rejected  { background: #fee2e2; color: #991b1b; }

        .msg-success { color: green; margin-bottom: 15px; font-size: 14px; }
        .empty { text-align: center; color: #888; padding: 40px; font-size: 15px; }
    </style>
</head>
<body>
<div class="container">
    <div class="top-bar">
        <h2>📋 My Blood Requests</h2>
        <a class="btn" href="<%= request.getContextPath() %>/PatientController?action=requestForm">
            + New Request
        </a>
    </div>

    <% if ("success".equals(msg)) { %>
        <p class="msg-success">✅ Your request was submitted successfully!</p>
    <% } %>

    <% if (requests == null || requests.isEmpty()) { %>
        <p class="empty">You have not submitted any blood requests yet.</p>
    <% } else { %>
        <table>
            <tr>
                <th>#</th>
                <th>Blood Group</th>
                <th>Quantity</th>
                <th>Urgency</th>
                <th>Status</th>
                <th>Request Date</th>
            </tr>
            <%
                int i = 1;
                for (BloodRequest r : requests) {
            %>
            <tr>
                <td><%= i++ %></td>
                <td><b><%= r.getBloodGroup() %></b></td>
                <td><%= r.getQuantity() %> unit(s)</td>
                <td><%= r.getUrgency() %></td>
                <td>
                    <span class="badge <%= r.getStatus() %>">
                        <%= r.getStatus() %>
                    </span>
                </td>
                <td><%= r.getRequestDate() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>
</div>
</body>
</html>