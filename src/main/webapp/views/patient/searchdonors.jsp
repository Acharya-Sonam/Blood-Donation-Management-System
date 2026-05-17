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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Donors – Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f8f0f0; min-height: 100vh; }

        .navbar {
            background: linear-gradient(135deg, #c0392b 0%, #96281b 100%);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 20px rgba(192,57,43,0.3);
        }
        .brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.5px;
            text-decoration: none;
        }
        .brand-dot {
            width: 10px;
            height: 10px;
            background: white;
            border-radius: 50%;
            opacity: 0.9;
        }
        .nav-links a {
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            margin-left: 24px;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .nav-links a:hover { color: white; }

        .page-header {
            background: linear-gradient(135deg, #c0392b 0%, #96281b 100%);
            padding: 32px 32px 60px;
            color: white;
        }
        .page-header h1 {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }
        .page-header p { font-size: 14px; opacity: 0.8; }

        .main { max-width: 1000px; margin: -36px auto 40px; padding: 0 20px; }

        .search-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: flex-end;
        }
        .form-group { flex: 1; min-width: 150px; }
        .form-group label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #eee;
            border-radius: 10px;
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            color: #333;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: white;
        }
        .form-group select:focus,
        .form-group input:focus {
            border-color: #c0392b;
            box-shadow: 0 0 0 3px rgba(192,57,43,0.08);
        }
        .btn-search {
            background: linear-gradient(135deg, #c0392b, #96281b);
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
            transition: transform 0.15s, box-shadow 0.15s;
            box-shadow: 0 4px 12px rgba(192,57,43,0.3);
            white-space: nowrap;
            text-decoration: none;
            display: inline-block;
        }
        .btn-search:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(192,57,43,0.4);
        }
        .btn-clear {
            background: white;
            color: #888;
            border: 1.5px solid #eee;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
            transition: all 0.15s;
            white-space: nowrap;
            text-decoration: none;
            display: inline-block;
        }
        .btn-clear:hover { border-color: #ccc; color: #555; }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 24px;
        }
        .stat {
            background: white;
            border-radius: 14px;
            padding: 18px 20px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            position: relative;
            overflow: hidden;
        }
        .stat::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, #c0392b, #e74c3c);
        }
        .stat .label {
            font-size: 11px;
            font-weight: 600;
            color: #aaa;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .stat .value {
            font-size: 28px;
            font-weight: 700;
            color: #c0392b;
            letter-spacing: -1px;
            line-height: 1;
        }
        .stat .sub { font-size: 11px; color: #bbb; margin-top: 4px; }

        .results-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .results-label { font-size: 13px; color: #888; font-weight: 500; }
        .btn-export {
            background: white;
            color: #c0392b;
            border: 1.5px solid #f0d0cd;
            padding: 8px 18px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Inter', sans-serif;
            transition: all 0.15s;
        }
        .btn-export:hover { background: #fff5f5; border-color: #c0392b; }

        .donor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 18px;
        }
        .donor-card {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
        }
        .donor-card::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, #c0392b, #e74c3c);
            transform: scaleX(0);
            transition: transform 0.25s;
            transform-origin: left;
        }
        .donor-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.12); }
        .donor-card:hover::after { transform: scaleX(1); }

        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
        }
        .blood-badge {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            color: white;
            font-size: 15px;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 10px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(192,57,43,0.3);
        }
        .avail-badge {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            letter-spacing: 0.3px;
        }
        .avail-yes { background: #edfaf4; color: #1a7a4a; }
        .avail-no  { background: #fff5ec; color: #c05621; }

        .avatar {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: linear-gradient(135deg, #fff0ef, #ffd5d0);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: 700;
            color: #c0392b;
        }
        .donor-name {
            font-size: 15px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 12px;
            letter-spacing: -0.3px;
        }
        .divider { height: 1px; background: #f5f5f5; margin-bottom: 12px; }
        .donor-info { display: flex; align-items: center; gap: 8px; margin-bottom: 7px; }
        .info-icon {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            flex-shrink: 0;
        }
        .info-text { font-size: 12px; color: #888; }
        .info-text strong { color: #333; font-weight: 600; }
        .compat-tag {
            display: inline-block;
            margin-top: 12px;
            font-size: 11px;
            font-weight: 500;
            background: #eff6ff;
            color: #1d5fa6;
            padding: 5px 10px;
            border-radius: 8px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }
        .empty-state p { color: #aaa; font-size: 14px; margin-top: 12px; }
    </style>
</head>
<body>

<div class="navbar">
    <a class="brand" href="<%= request.getContextPath() %>/donor/dashboard">
        <div class="brand-dot"></div>
        Blood Bridge
    </a>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/PatientController?action=requestForm">Request Blood</a>
        <a href="<%= request.getContextPath() %>/PatientController?action=myRequests">My Requests</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="page-header">
    <h1>Find Blood Donors</h1>
    <p>Search and connect with verified donors in your area</p>
</div>

<div class="main">

    <div class="search-card">
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
                        <option value="yes" <%= "yes".equals(availability) ? "selected" : "" %>>Available</option>
                        <option value="no"  <%= "no".equals(availability)  ? "selected" : "" %>>Not Available</option>
                    </select>
                </div>
                <button type="submit" class="btn-search">Search</button>
                <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors" class="btn-clear">Clear</a>
                <a href="<%= request.getContextPath() %>/donor/dashboard" class="btn-clear" style="margin-left: 10px;">&larr; Back to Dashboard</a>
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
        <div class="stat"><div class="label">Total donors</div><div class="value"><%= donors.size() %></div><div class="sub">registered</div></div>
        <div class="stat"><div class="label">Available now</div><div class="value"><%= availCount %></div><div class="sub">ready to donate</div></div>
        <div class="stat"><div class="label">Blood groups</div><div class="value"><%= uniqueGroups.size() %></div><div class="sub">types found</div></div>
        <div class="stat"><div class="label">Showing</div><div class="value"><%= endIdx - startIdx %></div><div class="sub">of results</div></div>
    </div>

    <div class="results-bar">
        <span class="results-label">Showing <%= endIdx - startIdx %> of <%= totalDonors %> donors</span>
        <button class="btn-export" onclick="exportCSV()">Export CSV</button>
    </div>

    <% if (totalDonors == 0) { %>
    <div class="empty-state">
        <div style="font-size:40px">&#128269;</div>
        <p>No donors found. Try different search filters.</p>
    </div>
    <% } else { %>
    <div class="donor-grid">
        <% for (int i = startIdx; i < endIdx; i++) {
            Donor d = filtered.get(i);
            boolean isAvail = d.getLastDonation() == null || d.getLastDonation().isEmpty();
            java.lang.String[] canDonateTo = compat.getOrDefault(d.getBloodGroup(), new java.lang.String[]{});
            StringBuilder sb = new StringBuilder();
            for (int j = 0; j < canDonateTo.length; j++) {
                sb.append(canDonateTo[j]);
                if (j < canDonateTo.length - 1) sb.append(", ");
            }
            java.lang.String[] nameParts = d.getFullName().split(" ");
            java.lang.String initials = "";
            for (int k = 0; k < Math.min(2, nameParts.length); k++) {
                if (nameParts[k].length() > 0) initials += nameParts[k].charAt(0);
            }
            initials = initials.toUpperCase();
        %>
        <div class="donor-card">
            <div class="card-top">
                <span class="blood-badge"><%= d.getBloodGroup() %></span>
                <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
                    <div class="avatar"><%= initials %></div>
                    <span class="avail-badge <%= isAvail ? "avail-yes" : "avail-no" %>">
                        <%= isAvail ? "Available" : "Not Available" %>
                    </span>
                </div>
            </div>
            <div class="donor-name"><%= d.getFullName() %></div>
            <div class="divider"></div>
            <div class="donor-info">
                <div class="info-icon">&#128205;</div>
                <div class="info-text">Location: <strong><%= d.getAddress() %></strong></div>
            </div>
            <div class="donor-info">
                <div class="info-icon">&#128222;</div>
                <div class="info-text">Phone: <strong><%= d.getPhone() %></strong></div>
            </div>
            <c:if test="${!empty d.donorId}">
                <form action="${pageContext.request.contextPath}/PatientController" method="post" style="margin-top:8px;">
                    <input type="hidden" name="action" value="addToWishlist"/>
                    <input type="hidden" name="donorId" value="<%= d.getId() %>"/>
                    <button type="submit" class="btn-clear" style="background:#e0f7fa; color:#006064; border:1px solid #b2ebf2;">
                        <i class="fas fa-heart"></i> Add to Wishlist
                    </button>
                </form>
            </c:if>
            <% if (d.getLastDonation() != null && !d.getLastDonation().isEmpty()) { %>
            <div class="donor-info">
                <div class="info-icon">&#128197;</div>
                <div class="info-text">Last donated: <strong><%= d.getLastDonation() %></strong></div>
            </div>
            <% } %>
            <div class="compat-tag">Can donate to: <%= sb.toString() %></div>
        </div>
        <% } %>
    </div>

    <% if (totalPages > 1) { %>
    <div style="display:flex;justify-content:center;gap:8px;margin-top:24px;flex-wrap:wrap">
        <% for (int p = 1; p <= totalPages; p++) { %>
        <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors&bloodGroup=<%= bloodGroup %>&location=<%= location %>&availability=<%= availability %>&page=<%= p %>"
           style="padding:8px 16px;border-radius:10px;font-size:13px;font-weight:600;text-decoration:none;border:1.5px solid <%= p==pageNum?"#c0392b":"#eee" %>;background:<%= p==pageNum?"#c0392b":"white" %>;color:<%= p==pageNum?"white":"#888" %>">
            <%= p %>
        </a>
        <% } %>
    </div>
    <% } %>
    <% } %>
    <% } else { %>
    <div class="empty-state">
        <div style="font-size:40px">&#128149;</div>
        <p>Use the search above to find available donors.</p>
    </div>
    <% } %>

</div>

<script id="donorData" type="application/json">
<% if (donors != null && !donors.isEmpty()) { %>
    [<% for (int i = 0; i < donors.size(); i++) {
        Donor d = donors.get(i);
        boolean av = d.getLastDonation() == null || d.getLastDonation().isEmpty();
    %>{"name":"<%= d.getFullName() %>","blood":"<%= d.getBloodGroup() %>","location":"<%= d.getAddress() %>","phone":"<%= d.getPhone() %>","available":"<%= av?"Yes":"No" %>"}<%if(i<donors.size()-1){%>,<%}%>
<% } %>]
    <% } else { %>[]<% } %>
</script>

<script>
    function exportCSV() {
        var data = JSON.parse(document.getElementById("donorData").textContent);
        if (!data.length) { alert("No donors to export."); return; }
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
