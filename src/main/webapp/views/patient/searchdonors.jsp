<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.util.HashMap,java.util.HashSet,java.util.Set,java.util.ArrayList,com.blooddonationmanagementsystem.model.Donor" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Donor> donors = (List<Donor>) request.getAttribute("donors");
    String bloodGroup = request.getParameter("bloodGroup");
    String location   = request.getParameter("location");
    String availability = request.getParameter("availability");
    if (bloodGroup   == null) bloodGroup = "";
    if (location     == null) location = "";
    if (availability == null) availability = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Donors – Blood Bridge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; color: #333; }
        .navbar { background: #c0392b; color: white; padding: 13px 28px; display: flex; justify-content: space-between; align-items: center; }
        .navbar .brand { font-size: 1.2rem; font-weight: 600; }
        .navbar a { color: white; text-decoration: none; margin-left: 18px; font-size: 0.9rem; }
        .navbar a:hover { text-decoration: underline; }
        .container { max-width: 980px; margin: 30px auto; padding: 0 18px; }
        .search-card { background: white; border-radius: 10px; padding: 22px; margin-bottom: 20px; box-shadow: 0 1px 6px rgba(0,0,0,0.07); }
        .search-card h2 { font-size: 1.1rem; font-weight: 600; margin-bottom: 16px; color: #c0392b; }
        .form-row { display: flex; flex-wrap: wrap; gap: 12px; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 160px; }
        .form-group label { font-size: 0.8rem; font-weight: 600; color: #666; }
        .form-group select, .form-group input { padding: 9px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.9rem; outline: none; }
        .form-group select:focus, .form-group input:focus { border-color: #c0392b; }
        .btn { padding: 9px 20px; border-radius: 6px; font-size: 0.9rem; cursor: pointer; border: 1px solid #ddd; background: white; }
        .btn-primary { background: #c0392b; color: white; border-color: #c0392b; }
        .btn-primary:hover { background: #a93226; }
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 20px; }
        .stat-card { background: white; border-radius: 8px; padding: 14px 16px; box-shadow: 0 1px 5px rgba(0,0,0,0.06); }
        .stat-card .label { font-size: 0.75rem; color: #888; margin-bottom: 4px; }
        .stat-card .value { font-size: 1.6rem; font-weight: 600; color: #c0392b; }
        .results-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
        .results-bar span { font-size: 0.88rem; color: #666; }
        .btn-export { padding: 7px 16px; font-size: 0.82rem; border-radius: 6px; cursor: pointer; border: 1px solid #ddd; background: white; color: #444; }
        .btn-export:hover { background: #f5f5f5; }
        .donor-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 16px; margin-bottom: 20px; }
        .donor-card { background: white; border-radius: 10px; padding: 18px; box-shadow: 0 1px 6px rgba(0,0,0,0.07); border-left: 4px solid #c0392b; }
        .blood-badge { display: inline-block; background: #c0392b; color: white; font-size: 0.82rem; font-weight: 600; padding: 3px 10px; border-radius: 12px; }
        .avail-badge { display: inline-block; font-size: 0.75rem; padding: 3px 9px; border-radius: 12px; margin-left: 6px; }
        .avail-yes { background: #e8f5e9; color: #2e7d32; }
        .avail-no  { background: #fff3e0; color: #e65100; }
        .donor-name { font-size: 0.97rem; font-weight: 600; margin: 10px 0 8px; }
        .donor-info { font-size: 0.82rem; color: #666; margin-bottom: 4px; }
        .donor-info span { color: #333; font-weight: 600; }
        .compat-tag { display: inline-block; margin-top: 10px; font-size: 0.72rem; background: #e3f2fd; color: #1565c0; padding: 3px 8px; border-radius: 10px; }
        .empty-state { text-align: center; padding: 50px 20px; background: white; border-radius: 10px; color: #888; font-size: 0.95rem; box-shadow: 0 1px 6px rgba(0,0,0,0.07); }
        .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 8px; flex-wrap: wrap; }
        .page-btn { padding: 6px 13px; font-size: 0.83rem; border: 1px solid #ddd; border-radius: 6px; cursor: pointer; background: white; }
        .page-btn.active { background: #c0392b; color: white; border-color: #c0392b; }
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

    <div class="search-card">
        <h2>Search Blood Donors</h2>
        <form action="<%= request.getContextPath() %>/PatientController" method="get">
            <input type="hidden" name="action" value="searchDonors">
            <div class="form-row">
                <div class="form-group">
                    <label>Blood Group</label>
                    <select name="bloodGroup">
                        <option value="">Any Blood Group</option>
                        <%
                            java.lang.String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                            for (java.lang.String g : groups) {
                        %>
                        <option value="<%= g %>" <%= g.equals(bloodGroup) ? "selected" : "" %>><%= g %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Location</label>
                    <input type="text" name="location" placeholder="e.g. Kathmandu, Itahari..." value="<%= location %>">
                </div>
                <div class="form-group">
                    <label>Availability</label>
                    <select name="availability">
                        <option value="">Any</option>
                        <option value="yes" <%= "yes".equals(availability) ? "selected" : "" %>>Available</option>
                        <option value="no"  <%= "no".equals(availability)  ? "selected" : "" %>>Not Available</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
                <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors" class="btn">Clear</a>
            </div>
        </form>
    </div>

    <%
        if (donors != null) {
            java.util.Map<java.lang.String, java.lang.String[]> compat = new java.util.HashMap<>();
            compat.put("A+",  new java.lang.String[]{"A+","AB+"});
            compat.put("A-",  new java.lang.String[]{"A+","A-","AB+","AB-"});
            compat.put("B+",  new java.lang.String[]{"B+","AB+"});
            compat.put("B-",  new java.lang.String[]{"B+","B-","AB+","AB-"});
            compat.put("AB+", new java.lang.String[]{"AB+"});
            compat.put("AB-", new java.lang.String[]{"AB+","AB-"});
            compat.put("O+",  new java.lang.String[]{"A+","B+","O+","AB+"});
            compat.put("O-",  new java.lang.String[]{"A+","A-","B+","B-","O+","O-","AB+","AB-"});

            java.util.List<Donor> filtered = new java.util.ArrayList<>();
            for (Donor d : donors) {
                if (availability == null || availability.isEmpty()) {
                    filtered.add(d);
                } else if ("yes".equals(availability) &&
                        (d.getLastDonation() == null || d.getLastDonation().isEmpty())) {
                    filtered.add(d);
                } else if ("no".equals(availability) &&
                        d.getLastDonation() != null && !d.getLastDonation().isEmpty()) {
                    filtered.add(d);
                }
            }

            int perPage = 6;
            int totalDonors = filtered.size();
            int pageNum = 1;
            try { pageNum = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            if (pageNum < 1) pageNum = 1;
            int totalPages = (int) Math.ceil((double) totalDonors / perPage);
            if (pageNum > totalPages && totalPages > 0) pageNum = totalPages;
            int startIdx = (pageNum - 1) * perPage;
            int endIdx   = Math.min(startIdx + perPage, totalDonors);

            long availCount = 0;
            java.util.Set<java.lang.String> uniqueGroups = new java.util.HashSet<>();
            for (Donor d : donors) {
                if (d.getLastDonation() == null || d.getLastDonation().isEmpty()) availCount++;
                uniqueGroups.add(d.getBloodGroup());
            }
    %>

    <div class="stats-row">
        <div class="stat-card"><div class="label">Total donors</div><div class="value"><%= donors.size() %></div></div>
        <div class="stat-card"><div class="label">Available now</div><div class="value"><%= availCount %></div></div>
        <div class="stat-card"><div class="label">Blood groups</div><div class="value"><%= uniqueGroups.size() %></div></div>
        <div class="stat-card"><div class="label">Showing</div><div class="value"><%= endIdx - startIdx %></div></div>
    </div>

    <div class="results-bar">
        <span>Showing <%= endIdx - startIdx %> of <%= totalDonors %> donors</span>
        <button class="btn-export" onclick="exportCSV()">Export CSV</button>
    </div>

    <% if (totalDonors == 0) { %>
    <div class="empty-state">No donors found. Try different search filters.</div>
    <% } else { %>
    <div class="donor-grid">
        <% for (int i = startIdx; i < endIdx; i++) {
            Donor d = filtered.get(i);
            boolean isAvail = d.getLastDonation() == null || d.getLastDonation().isEmpty();
            java.lang.String[] canDonateTo = compat.getOrDefault(d.getBloodGroup(), new java.lang.String[]{});
            StringBuilder compatSb = new StringBuilder();
            for (int j = 0; j < canDonateTo.length; j++) {
                compatSb.append(canDonateTo[j]);
                if (j < canDonateTo.length - 1) compatSb.append(", ");
            }
        %>
        <div class="donor-card">
            <div>
                <span class="blood-badge"><%= d.getBloodGroup() %></span>
                <span class="avail-badge <%= isAvail ? "avail-yes" : "avail-no" %>">
            <%= isAvail ? "Available" : "Not Available" %>
        </span>
            </div>
            <div class="donor-name"><%= d.getFullName() %></div>
            <div class="donor-info">&#128205; Location: <span><%= d.getAddress() %></span></div>
            <div class="donor-info">&#128222; Phone: <span><%= d.getPhone() %></span></div>
            <% if (d.getLastDonation() != null && !d.getLastDonation().isEmpty()) { %>
            <div class="donor-info">&#128197; Last donated: <span><%= d.getLastDonation() %></span></div>
            <% } %>
            <div class="compat-tag">Can donate to: <%= compatSb.toString() %></div>
        </div>
        <% } %>
    </div>

    <% if (totalPages > 1) { %>
    <div class="pagination">
        <% for (int p = 1; p <= totalPages; p++) { %>
        <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors&bloodGroup=<%= bloodGroup %>&location=<%= location %>&availability=<%= availability %>&page=<%= p %>">
            <button class="page-btn <%= p == pageNum ? "active" : "" %>"><%= p %></button>
        </a>
        <% } %>
    </div>
    <% } %>
    <% } %>
    <% } else { %>
    <div class="empty-state">Use the search above to find available donors.</div>
    <% } %>

</div>

<script id="donorData" type="application/json">
<% if (donors != null && !donors.isEmpty()) { %>
    [<% for (int i = 0; i < donors.size(); i++) {
        Donor d = donors.get(i);
        boolean av = d.getLastDonation() == null || d.getLastDonation().isEmpty();
    %>{"name":"<%= d.getFullName() %>","blood":"<%= d.getBloodGroup() %>","location":"<%= d.getAddress() %>","phone":"<%= d.getPhone() %>","available":"<%= av ? "Yes" : "No" %>"}<%if(i<donors.size()-1){%>,<%}%>
<% } %>]
    <% } else { %>[]<% } %>
</script>

<script>
    function exportCSV() {
        var data = JSON.parse(document.getElementById("donorData").textContent);
        if (data.length === 0) { alert("No donors to export."); return; }
        var csv = "Name,Blood Group,Location,Phone,Available\n";
        data.forEach(function(d) {
            csv += d.name+","+d.blood+","+d.location+","+d.phone+","+d.available+"\n";
        });
        var a = document.createElement("a");
        a.href = "data:text/csv;charset=utf-8," + encodeURIComponent(csv);
        a.download = "donors.csv";
        a.click();
    }
</script>

</body>
</html>