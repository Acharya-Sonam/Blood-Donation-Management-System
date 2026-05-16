<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.util.HashMap,java.util.HashSet,java.util.Set,java.util.ArrayList,com.blooddonationmanagementsystem.model.Donor" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Donor> donors = (List<Donor>) request.getAttribute("donors");
    java.lang.String bloodGroup = request.getParameter("bloodGroup");
    java.lang.String location   = request.getParameter("location");
    java.lang.String availability = request.getParameter("availability");
    if (bloodGroup   == null) bloodGroup = "";
    if (location     == null) location = "";
    if (availability == null) availability = "";

    java.lang.String role = (java.lang.String) session.getAttribute("role");
    java.lang.String donorName = (java.lang.String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Donors – Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .page-header-integrated {
            background: var(--red-primary);
            padding: 32px 28px 60px;
            color: white;
            margin: -28px -28px 0 -28px;
            margin-bottom: 30px;
        }
        .page-header-integrated h1 { font-size: 1.8rem; font-weight: 800; margin-bottom: 8px; }
        .page-header-integrated p  { opacity: 0.8; font-size: 0.9rem; }

        .search-card-refined {
            background: white; border-radius: var(--radius); padding: 24px;
            box-shadow: var(--shadow); margin-top: -50px; margin-bottom: 24px;
            position: relative; z-index: 5;
        }
        .search-card-refined h2 { font-size: 1rem; font-weight: 700; color: var(--red-primary); margin-bottom: 16px; }
        .form-row { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .form-group { flex: 1; min-width: 180px; }
        .form-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-group input, .form-group select {
            width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;
            font-family: inherit; font-size: 0.9rem; outline: none; transition: border-color 0.2s;
        }
        .form-group input:focus, .form-group select:focus { border-color: var(--red-primary); }
        .btn-search-refined {
            background: var(--sidebar-bg); color: white; border: none;
            padding: 12px 30px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s;
        }
        .btn-search-refined:hover { background: var(--red-primary); }
        .btn-clear {
            background: white; color: #555; border: 1px solid var(--border);
            padding: 12px 20px; border-radius: 8px; font-weight: 500; cursor: pointer;
            text-decoration: none; font-size: 0.9rem; display: inline-block; transition: background 0.2s;
        }
        .btn-clear:hover { background: #f5f5f5; }

        /* Statistics row */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 20px; }
        @media (max-width: 700px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        .stat-card {
            background: white; border-radius: var(--radius); padding: 18px 20px;
            box-shadow: var(--shadow); border-top: 3px solid var(--red-primary);
        }
        .stat-card .stat-label { font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px; }
        .stat-card .stat-value { font-size: 1.8rem; font-weight: 800; color: var(--red-primary); }

        /* Results bar */
        .results-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .results-bar span { font-size: 0.88rem; color: var(--text-muted); }
        .btn-export {
            padding: 8px 18px; font-size: 0.82rem; border-radius: 8px; cursor: pointer;
            border: 1px solid var(--border); background: white; color: #444;
            font-family: inherit; transition: background 0.2s;
        }
        .btn-export:hover { background: #f5f5f5; }

        /* Donor grid */
        .donor-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 20px; margin-bottom: 24px; }
        .donor-card {
            background: white; border-radius: var(--radius); padding: 20px;
            box-shadow: var(--shadow); transition: transform 0.2s, border-bottom-color 0.2s;
            border-bottom: 4px solid transparent;
        }
        .donor-card:hover { transform: translateY(-4px); border-bottom-color: var(--red-primary); }

        .card-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .avatar-circle {
            width: 44px; height: 44px; border-radius: 50%;
            background: var(--red-light); color: var(--red-primary);
            font-size: 1rem; font-weight: 800; display: flex; align-items: center; justify-content: center;
        }
        .blood-badge-large { background: var(--red-primary); color: white; font-size: 1rem; font-weight: 800; padding: 8px 14px; border-radius: 10px; }
        .avail-badge { font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 20px; text-transform: uppercase; }
        .avail-yes { background: #eafaf1; color: #1e8449; }
        .avail-no  { background: #fff3e0; color: #e65100; }

        .donor-name { font-size: 1rem; font-weight: 700; margin-bottom: 12px; }
        .donor-info { font-size: 0.83rem; color: var(--text-muted); margin-bottom: 6px; }
        .donor-info span { color: #333; font-weight: 600; }

        .compat-area { margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border); }
        .compat-label { font-size: 0.72rem; color: var(--text-muted); margin-bottom: 6px; }
        .compat-tags { display: flex; flex-wrap: wrap; gap: 5px; }
        .compat-tag { font-size: 0.72rem; background: #e3f2fd; color: #1565c0; padding: 3px 9px; border-radius: 10px; font-weight: 600; }

        /* Pagination */
        .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 8px; flex-wrap: wrap; }
        .page-btn {
            padding: 7px 14px; font-size: 0.83rem; border: 1px solid var(--border);
            border-radius: 8px; cursor: pointer; background: white; text-decoration: none;
            color: #444; transition: background 0.2s; display: inline-block;
        }
        .page-btn:hover { background: #f5f5f5; }
        .page-btn.active { background: var(--red-primary); color: white; border-color: var(--red-primary); }

        /* Empty state */
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: var(--radius); box-shadow: var(--shadow); }
        .empty-state .empty-icon { font-size: 3rem; margin-bottom: 16px; }
        .empty-state h3 { font-size: 1.1rem; margin-bottom: 8px; }
        .empty-state p  { color: var(--text-muted); font-size: 0.9rem; }
    </style>
</head>
<body>

<% if ("donor".equalsIgnoreCase(role)) { %>
<jsp:include page="../donor/donor-sidebar.jsp" />
<% } else { %>
<jsp:include page="../patient/patient-sidebar.jsp" />
<% } %>

<main class="main-content">
    <header class="topbar">
        <h1>🔍 Search Donors</h1>
        <div class="topbar-right">
            <span class="admin-badge"><%= role != null ? role.substring(0, 1).toUpperCase() + role.substring(1) : "User" %></span>
            <div class="user-info">
                <strong><%= donorName != null ? donorName : "User" %></strong>
            </div>
        </div>
    </header>

    <div class="page-body">

        <div class="page-header-integrated">
            <h1>Find a Hero</h1>
            <p>Search and connect with verified blood donors across the country.</p>
        </div>

        <%-- Search Filters --%>
        <div class="search-card-refined">
            <h2>🔎 Search Filters</h2>
            <form action="<%= request.getContextPath() %>/PatientController" method="get">
                <input type="hidden" name="action" value="searchDonors">
                <div class="form-row">
                    <div class="form-group">
                        <label>Blood Group</label>
                        <select name="bloodGroup">
                            <option value="">Any Blood Group</option>
                            <%
                                java.lang.String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                                for (java.lang.String g : groups) { %>
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
                            <option value="">Any Status</option>
                            <option value="yes" <%= "yes".equals(availability) ? "selected" : "" %>>Available Now</option>
                            <option value="no"  <%= "no".equals(availability)  ? "selected" : "" %>>On Cooling Period</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-search-refined">Search Donors</button>
                    <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors" class="btn-clear">Clear</a>
                </div>
            </form>
        </div>

        <%
            if (donors != null) {
                /* Compatibility map */
                java.util.Map<java.lang.String, java.lang.String[]> compat = new java.util.HashMap<>();
                compat.put("A+",  new java.lang.String[]{"A+","AB+"});
                compat.put("A-",  new java.lang.String[]{"A+","A-","AB+","AB-"});
                compat.put("B+",  new java.lang.String[]{"B+","AB+"});
                compat.put("B-",  new java.lang.String[]{"B+","B-","AB+","AB-"});
                compat.put("AB+", new java.lang.String[]{"AB+"});
                compat.put("AB-", new java.lang.String[]{"AB+","AB-"});
                compat.put("O+",  new java.lang.String[]{"A+","B+","O+","AB+"});
                compat.put("O-",  new java.lang.String[]{"A+","A-","B+","B-","O+","O-","AB+","AB-"});

                /* Availability filter */
                java.util.List<Donor> filtered = new java.util.ArrayList<>();
                for (Donor d : donors) {
                    if (availability == null || availability.isEmpty()) {
                        filtered.add(d);
                    } else if ("yes".equals(availability) && (d.getLastDonation() == null || d.getLastDonation().isEmpty())) {
                        filtered.add(d);
                    } else if ("no".equals(availability) && d.getLastDonation() != null && !d.getLastDonation().isEmpty()) {
                        filtered.add(d);
                    }
                }

                /* Pagination */
                int perPage = 6;
                int totalDonors = filtered.size();
                int pageNum = 1;
                try { pageNum = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
                if (pageNum < 1) pageNum = 1;
                int totalPages = (int) Math.ceil((double) totalDonors / perPage);
                if (pageNum > totalPages && totalPages > 0) pageNum = totalPages;
                int startIdx = (pageNum - 1) * perPage;
                int endIdx   = Math.min(startIdx + perPage, totalDonors);

                /* Stats */
                long availCount = 0;
                java.util.Set<java.lang.String> uniqueGroups = new java.util.HashSet<>();
                for (Donor d : donors) {
                    if (d.getLastDonation() == null || d.getLastDonation().isEmpty()) availCount++;
                    uniqueGroups.add(d.getBloodGroup());
                }
        %>

        <%-- Statistics Row --%>
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-label">Total Donors</div>
                <div class="stat-value"><%= donors.size() %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Available Now</div>
                <div class="stat-value"><%= availCount %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Blood Groups</div>
                <div class="stat-value"><%= uniqueGroups.size() %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Showing</div>
                <div class="stat-value"><%= endIdx - startIdx %></div>
            </div>
        </div>

        <%-- Results bar + CSV export --%>
        <div class="results-bar">
            <span>Showing <strong><%= endIdx - startIdx %></strong> of <strong><%= totalDonors %></strong> donors</span>
            <button class="btn-export" onclick="exportCSV()">⬇ Export CSV</button>
        </div>

        <% if (totalDonors == 0) { %>
        <div class="empty-state">
            <div class="empty-icon">🔍</div>
            <h3>No donors found</h3>
            <p>Try adjusting your filters or searching in a different location.</p>
        </div>
        <% } else { %>

        <%-- Donor Cards --%>
        <div class="donor-grid">
            <% for (int i = startIdx; i < endIdx; i++) {
                Donor d = filtered.get(i);
                boolean isAvail = d.getLastDonation() == null || d.getLastDonation().isEmpty();
                java.lang.String[] canDonateTo = compat.getOrDefault(d.getBloodGroup(), new java.lang.String[]{});

                java.lang.String fullName = d.getFullName() != null ? d.getFullName() : "?";
                java.lang.String[] nameParts = fullName.trim().split("\\s+");
                java.lang.String initials = nameParts.length >= 2
                        ? "" + nameParts[0].charAt(0) + nameParts[nameParts.length - 1].charAt(0)
                        : fullName.substring(0, Math.min(2, fullName.length()));
                initials = initials.toUpperCase();
            %>
            <div class="donor-card">
                <div class="card-top">
                    <div class="avatar-circle"><%= initials %></div>
                    <span class="blood-badge-large"><%= d.getBloodGroup() %></span>
                    <span class="avail-badge <%= isAvail ? "avail-yes" : "avail-no" %>">
                            <%= isAvail ? "Available" : "Cooling Down" %>
                        </span>
                </div>
                <div class="donor-name"><%= d.getFullName() %></div>
                <div class="donor-info">📍 Location: <span><%= d.getAddress() %></span></div>
                <div class="donor-info">📞 Phone: <span><%= d.getPhone() %></span></div>
                <% if (!isAvail && d.getLastDonation() != null && !d.getLastDonation().isEmpty()) { %>
                <div class="donor-info">🗓️ Last Donated: <span style="color:var(--red-primary)"><%= d.getLastDonation() %></span></div>
                <% } %>
                <div class="compat-area">
                    <div class="compat-label">Can donate to:</div>
                    <div class="compat-tags">
                        <% for (java.lang.String bg : canDonateTo) { %>
                        <span class="compat-tag"><%= bg %></span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <%-- Pagination --%>
        <% if (totalPages > 1) { %>
        <div class="pagination">
            <% for (int p = 1; p <= totalPages; p++) { %>
            <a class="page-btn <%= p == pageNum ? "active" : "" %>"
               href="<%= request.getContextPath() %>/PatientController?action=searchDonors&bloodGroup=<%= bloodGroup %>&location=<%= location %>&availability=<%= availability %>&page=<%= p %>">
                <%= p %>
            </a>
            <% } %>
        </div>
        <% } %>

        <% } %>
        <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">🩸</div>
            <h3>Search for Donors</h3>
            <p>Use the filters above to find available blood donors near you.</p>
        </div>
        <% } %>

    </div>
    <jsp:include page="../common/footer.jsp" />
</main>

<%-- Embedded donor JSON for CSV export --%>
<script id="donorData" type="application/json">
    <% if (donors != null && !donors.isEmpty()) { %>[<%
    for (int i = 0; i < donors.size(); i++) {
        Donor d = donors.get(i);
        boolean av = d.getLastDonation() == null || d.getLastDonation().isEmpty();
        java.lang.String sn = d.getFullName()   != null ? d.getFullName().replace("\\","\\\\").replace("\"","\\\"")   : "";
        java.lang.String sb = d.getBloodGroup() != null ? d.getBloodGroup().replace("\"","\\\"") : "";
        java.lang.String sl = d.getAddress()    != null ? d.getAddress().replace("\\","\\\\").replace("\"","\\\"")    : "";
        java.lang.String sp = d.getPhone()      != null ? d.getPhone().replace("\"","\\\"")      : "";
%>{"name":"<%= sn %>","blood":"<%= sb %>","location":"<%= sl %>","phone":"<%= sp %>","available":"<%= av ? "Yes" : "No" %>"}<%if(i<donors.size()-1){%>,<%}%>
    <% } %>]<% } else { %>[]<% } %>
    </script>

<script>
    function exportCSV() {
        var data;
        try { data = JSON.parse(document.getElementById("donorData").textContent); }
        catch(e) { alert("Could not read donor data."); return; }
        if (!data || data.length === 0) { alert("No donors to export."); return; }
        function q(v) { return '"' + (v||'').replace(/"/g,'""') + '"'; }
        var csv = "Name,Blood Group,Location,Phone,Available\n";
        data.forEach(function(d) {
            csv += q(d.name)+","+q(d.blood)+","+q(d.location)+","+q(d.phone)+","+q(d.available)+"\n";
        });
        var a = document.createElement("a");
        a.href = "data:text/csv;charset=utf-8," + encodeURIComponent(csv);
        a.download = "donors_export.csv";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }
</script>

</body>
</html>
