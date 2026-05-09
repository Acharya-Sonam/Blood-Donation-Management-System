<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.BloodRequest" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<BloodRequest> requests = (List<BloodRequest>) request.getAttribute("requests");
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Donor Dashboard – Blood Bridge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f5f5f5; }
        .navbar { background: #c0392b; color: white; padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .brand { font-size: 1.3rem; font-weight: bold; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; font-size: 14px; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 980px; margin: 30px auto; padding: 0 20px; }
        .welcome { background: white; border-radius: 10px; padding: 20px 25px; margin-bottom: 24px; box-shadow: 0 1px 5px rgba(0,0,0,0.08); }
        .welcome h2 { color: #c0392b; font-size: 1.3rem; }
        .welcome p { color: #666; margin-top: 5px; font-size: 14px; }
        .cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; margin-bottom: 30px; }
        .card { background: white; border-radius: 10px; padding: 24px 16px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.07); border-top: 4px solid #c0392b; text-decoration: none; color: #333; transition: transform 0.15s; }
        .card:hover { transform: translateY(-4px); }
        .card .icon { font-size: 2rem; margin-bottom: 10px; }
        .card h3 { font-size: 0.95rem; color: #222; }
        .section-title { color: #c0392b; font-size: 1.1rem; font-weight: 600; margin-bottom: 14px; padding-bottom: 8px; border-bottom: 2px solid #f5f5f5; }
        .table-card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 1px 5px rgba(0,0,0,0.08); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #c0392b; color: white; padding: 11px; text-align: left; font-size: 13px; }
        td { padding: 11px; border-bottom: 1px solid #eee; font-size: 13px; }
        tr:hover td { background: #fdf2f2; }
        .btn-accept { padding: 6px 13px; background: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .btn-reject { padding: 6px 13px; background: #e74c3c; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; margin-left: 5px; }
        .urgent { color: #e67e22; font-weight: bold; }
        .critical { color: #c0392b; font-weight: bold; }
        .normal { color: #27ae60; }
        .empty { text-align: center; color: #888; padding: 30px; font-size: 14px; }
    </style>
</head>
<body>

<div class="navbar">
    <span class="brand">&#128149; Blood Bridge</span>
    <div>
        <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors">&#128269; Search Donors</a>
        <a href="<%= request.getContextPath() %>/views/donor/profile.jsp">My Profile</a>
        <a href="<%= request.getContextPath() %>/views/donor/donationHistory.jsp">Donation History</a>
        <a href="<%= request.getContextPath() %>/views/donor/wishlist.jsp">Wishlist</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">

    <div class="welcome">
        <h2>Welcome, <%= donorName != null ? donorName : "Donor" %>! &#128075;</h2>
        <p>Here are the active blood requests that need your help.</p>
    </div>

    <%-- Quick Action Cards --%>
    <div class="cards">
        <a class="card" href="<%= request.getContextPath() %>/PatientController?action=searchDonors">
            <div class="icon">&#128269;</div>
            <h3>Search Donors</h3>
        </a>
        <a class="card" href="<%= request.getContextPath() %>/views/donor/donationHistory.jsp">
            <div class="icon">&#128203;</div>
            <h3>Donation History</h3>
        </a>
        <a class="card" href="<%= request.getContextPath() %>/views/donor/profile.jsp">
            <div class="icon">&#128100;</div>
            <h3>My Profile</h3>
        </a>
        <a class="card" href="<%= request.getContextPath() %>/views/donor/wishlist.jsp">
            <div class="icon">&#10084;</div>
            <h3>Wishlist</h3>
        </a>
    </div>

    <%-- Pending Requests Table --%>
    <div class="table-card">
        <div class="section-title">&#128137; Pending Blood Requests</div>
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
                <td><span class="<%= urgencyClass %>"><%= r.getUrgency() %></span></td>
                <td><%= r.getRequestDate() %></td>
                <td>
                    <form action="<%= request.getContextPath() %>/PatientController" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" value="<%= r.getId() %>">
                        <input type="hidden" name="status" value="Approved">
                        <button class="btn-accept" type="submit">Accept</button>
                    </form>
                    <form action="<%= request.getContextPath() %>/PatientController" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" value="<%= r.getId() %>">
                        <input type="hidden" name="status" value="Rejected">
                        <button class="btn-reject" type="submit">Reject</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
    </div>

</div>

</body>
</html>
