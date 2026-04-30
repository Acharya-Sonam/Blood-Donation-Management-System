<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.BloodRequest" %>
<%
    if (session.getAttribute("userId") == null || !"Donor".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
        return;
    }
    List<BloodRequest> requests = (List<BloodRequest>) request.getAttribute("requests");
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Dashboard - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/donor.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }

        /* Top navbar */
        .navbar {
            background: #c0392b;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 { font-size: 20px; }
        .navbar a  { color: white; text-decoration: none; font-size: 14px; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }

        /* Welcome banner */
        .welcome {
            background: white;
            margin: 25px 30px 0 30px;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.08);
        }
        .welcome h2 { color: #c0392b; font-size: 20px; }
        .welcome p  { color: #666; margin-top: 5px; font-size: 14px; }

        /* Main content */
        .container {
            margin: 20px 30px;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.08);
        }
        .section-title {
            color: #c0392b;
            font-size: 18px;
            margin-bottom: 15px;
            border-bottom: 2px solid #f5f5f5;
            padding-bottom: 10px;
        }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #c0392b;
            color: white;
            padding: 11px;
            text-align: left;
            font-size: 14px;
        }
        td { padding: 11px; border-bottom: 1px solid #eee; font-size: 14px; }
        tr:hover td { background: #fdf2f2; }

        .btn-accept {
            padding: 6px 13px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
        }
        .btn-reject {
            padding: 6px 13px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 5px;
        }
        .btn-accept:hover { background: #1e8449; }
        .btn-reject:hover { background: #c0392b; }

        .urgent   { color: #e67e22; font-weight: bold; }
        .critical { color: #c0392b; font-weight: bold; }
        .normal   { color: #27ae60; }

        .empty { text-align: center; color: #888; padding: 30px; font-size: 15px; }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h1>🩸 Blood Bridge</h1>
    <div>
        <a href="<%= request.getContextPath() %>/views/donor/profile.jsp">My Profile</a>
        <a href="<%= request.getContextPath() %>/views/donor/donationHistory.jsp">Donation History</a>
        <a href="<%= request.getContextPath() %>/views/donor/wishlist.jsp">Wishlist</a>
        <a href="<%= request.getContextPath() %>/AuthController?action=logout">Logout</a>
    </div>
</div>

<!-- Welcome -->
<div class="welcome">
    <h2>Welcome, <%= donorName != null ? donorName : "Donor" %> 👋</h2>
    <p>Here are the active blood requests that need your help.</p>
</div>

<!-- Pending Requests Table -->
<div class="container">
    <div class="section-title">🩸 Pending Blood Requests</div>

    <% if (requests == null || requests.isEmpty()) { %>
        <p class="empty">No pending blood requests at the moment. Check back later!</p>
    <% } else { %>
        <table>
            <tr>
                <th>#</th>
                <th>Patient Name</th>
                <th>Blood Group</th>
                <th>Quantity</th>
                <th>Urgency</th>
                <th>Request Date</th>
                <th>Action</th>
            </tr>
            <%
                int i = 1;
                for (BloodRequest r : requests) {
                    String urgencyClass = "Critical".equals(r.getUrgency()) ? "critical"
                                       : "Urgent".equals(r.getUrgency())   ? "urgent"
                                       : "normal";
            %>
            <tr>
                <td><%= i++ %></td>
                <td><%= r.getPatientName() %></td>
                <td><b><%= r.getBloodGroup() %></b></td>
                <td><%= r.getQuantity() %> unit(s)</td>
                <td>
                    <span class="<%= urgencyClass %>">
                        <%= r.getUrgency() %>
                    </span>
                </td>
                <td><%= r.getRequestDate() %></td>
                <td>
                    <!-- Accept -->
                    <form action="<%= request.getContextPath() %>/PatientController"
                          method="post" style="display:inline;">
                        <input type="hidden" name="action"    value="updateStatus" />
                        <input type="hidden" name="requestId" value="<%= r.getId() %>" />
                        <input type="hidden" name="status"    value="Approved" />
                        <button class="btn-accept" type="submit">✔ Accept</button>
                    </form>
                    <!-- Reject -->
                    <form action="<%= request.getContextPath() %>/PatientController"
                          method="post" style="display:inline;">
                        <input type="hidden" name="action"    value="updateStatus" />
                        <input type="hidden" name="requestId" value="<%= r.getId() %>" />
                        <input type="hidden" name="status"    value="Rejected" />
                        <button class="btn-reject" type="submit">✘ Reject</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    <% } %>
</div>

</body>
</html>