<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bloodbridge.model.Donor" %>
<%@ page import="com.bloodbridge.util.BloodCompatibilityUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find a Donor — Blood Bridge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f7f7f7;
            color: #333;
        }

        /* ---- Navbar ---- */
        .navbar {
            background: #c0392b;
            color: white;
            padding: 14px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .navbar h1 { font-size: 20px; font-weight: 700; letter-spacing: 0.5px; }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            opacity: 0.85;
            margin-left: 20px;
        }
        .navbar a:hover { opacity: 1; }

        /* ---- Main layout ---- */
        .container {
            max-width: 920px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
            color: #c0392b;
        }
        .page-subtitle {
            font-size: 14px;
            color: #888;
            margin-bottom: 24px;
        }

        /* ---- Stats bar ---- */
        .stats-row {
            display: flex;
            gap: 14px;
            margin-bottom: 24px;
        }
        .stat-card {
            flex: 1;
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            border: 1px solid #eee;
            text-align: center;
        }
        .stat-number {
            font-size: 30px;
            font-weight: 700;
            color: #c0392b;
        }
        .stat-label {
            font-size: 12px;
            color: #999;
            margin-top: 4px;
        }

        /* ---- Search form ---- */
        .search-card {
            background: white;
            border-radius: 12px;
            padding: 22px;
            border: 1px solid #eee;
            margin-bottom: 24px;
        }

        .mode-row {
            display: flex;
            gap: 10px;
            margin-bottom: 16px;
        }
        .mode-btn {
            padding: 8px 20px;
            border-radius: 25px;
            border: 1px solid #ddd;
            font-size: 13px;
            cursor: pointer;
            background: white;
            color: #666;
            transition: all 0.2s;
        }
        .mode-btn.active {
            background: #c0392b;
            color: white;
            border-color: #c0392b;
        }
        .mode-btn:hover:not(.active) {
            border-color: #c0392b;
            color: #c0392b;
        }

        .form-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
            min-width: 160px;
        }
        .form-group label {
            font-size: 12px;
            color: #888;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-group select,
        .form-group input {
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            color: #333;
            background: #fafafa;
            transition: border-color 0.2s;
        }
        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #c0392b;
            background: white;
        }

        .btn-search {
            background: #c0392b;
            color: white;
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: background 0.2s;
            letter-spacing: 0.3px;
        }
        .btn-search:hover { background: #a93226; }

        /* ---- Compatibility info box ---- */
        .compat-info {
            background: #fef9e7;
            border: 1px solid #f9ca24;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 13px;
            color: #7d6608;
            margin-bottom: 14px;
            display: none;
        }
        .compat-info.show { display: block; }

        /* ---- Result label ---- */
        .result-label {
            font-size: 13px;
            color: #999;
            margin-bottom: 14px;
        }

        /* ---- Donor cards ---- */
        .donor-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            width: 100%;
        }

        .donor-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #eee;
            padding: 18px 20px;
            display: flex;
            flex-direction: row;
            align-items: center;
            gap: 16px;
            transition: all 0.2s;
            width: 100%;
        }
        .donor-card:hover {
            border-color: #c0392b;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(192,57,43,0.08);
        }
        .donor-card.urgent-card {
            border-left: 4px solid #c0392b;
            background: #fffafa;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #fdecea;
            color: #c0392b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .donor-info { flex: 1; }

        .donor-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
            color: #222;
        }

        .donor-meta {
            font-size: 13px;
            color: #999;
            margin-bottom: 10px;
        }

        .badges {
            display: flex;
            gap: 6px;
            flex-wrap: nowrap;
            align-items: center;
            overflow-x: auto;
        }
        .badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }
        .badge-blood {
            background: #fdecea;
            color: #c0392b;
            font-size: 13px;
            padding: 4px 12px;
        }
        .badge-eligible {
            background: #eafaf1;
            color: #1e8449;
        }
        .badge-wait {
            background: #fef9e7;
            color: #b7950b;
        }
        .badge-days {
            background: #f0f0f0;
            color: #666;
        }
        .badge-universal {
            background: #eaf4fd;
            color: #1a5276;
        }
        .badge-urgent {
            background: #c0392b;
            color: white;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%   { opacity: 1; }
            50%  { opacity: 0.6; }
            100% { opacity: 1; }
        }

        .btn-contact {
            background: white;
            border: 1.5px solid #c0392b;
            color: #c0392b;
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            flex-shrink: 0;
            align-self: center;
            transition: all 0.2s;
            margin-left: auto;
        }
        .btn-contact:hover {
            background: #c0392b;
            color: white;
        }

        /* ---- Empty state ---- */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #bbb;
        }
        .empty-icon {
            font-size: 48px;
            margin-bottom: 14px;
        }
        .empty-state p {
            font-size: 16px;
            color: #666;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .empty-state span {
            font-size: 13px;
            color: #aaa;
        }

        /* ---- Error ---- */
        .error-box {
            background: #fdecea;
            border: 1px solid #e74c3c;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
        }

        /* ---- Footer ---- */
        .footer {
            text-align: center;
            padding: 30px;
            font-size: 12px;
            color: #bbb;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h1>🩸 Blood Bridge</h1>
    <div>
        <a href="http://localhost:8081/searchDonors">🔍 Search Donors</a>
        <a href="http://localhost:8081/views/patient/compatibility.jsp">🩸 Compatibility Chart</a>
        <a href="#">📋 My Requests</a>
        <a href="http://localhost:8081/logout">🚪 Logout</a>
    </div>
</div>

<div class="container">

    <p class="page-title">Find a Donor</p>
    <p class="page-subtitle">Search by blood group, location, or use compatibility mode to find all matching donors</p>

    <%-- Error message --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-box">⚠️ ${errorMessage}</div>
    <% } %>

    <%-- Stats bar --%>
    <%
        Integer totalCount  = (Integer) request.getAttribute("totalCount");
        Long eligibleCount  = (Long)    request.getAttribute("eligibleCount");
        if (totalCount  == null) totalCount  = 0;
        if (eligibleCount == null) eligibleCount = 0L;
    %>
    <div style="display:flex; gap:14px; margin-bottom:24px;">
        <div style="flex:1; background:linear-gradient(135deg,#c0392b,#e74c3c); border-radius:14px; padding:20px 24px; color:white; display:flex; align-items:center; gap:16px;">
            <div style="font-size:36px;">🩸</div>
            <div>
                <div style="font-size:32px; font-weight:700; line-height:1;"><%= totalCount %></div>
                <div style="font-size:13px; opacity:0.85; margin-top:4px;">Total donors found</div>
            </div>
        </div>
        <div style="flex:1; background:linear-gradient(135deg,#1e8449,#27ae60); border-radius:14px; padding:20px 24px; color:white; display:flex; align-items:center; gap:16px;">
            <div style="font-size:36px;">✅</div>
            <div>
                <div style="font-size:32px; font-weight:700; line-height:1;"><%= eligibleCount %></div>
                <div style="font-size:13px; opacity:0.85; margin-top:4px;">Eligible to donate now</div>
            </div>
        </div>
        <div style="flex:1; background:linear-gradient(135deg,#b7950b,#f39c12); border-radius:14px; padding:20px 24px; color:white; display:flex; align-items:center; gap:16px;">
            <div style="font-size:36px;">⏳</div>
            <div>
                <div style="font-size:32px; font-weight:700; line-height:1;"><%= totalCount - eligibleCount %></div>
                <div style="font-size:13px; opacity:0.85; margin-top:4px;">On wait period</div>
            </div>
        </div>
    </div>
        <%-- Blood type availability summary --%>
    <%
        Map<String, int[]> bloodTypeStats = (Map<String, int[]>) request.getAttribute("bloodTypeStats");
    %>

    <% if (bloodTypeStats != null) { %>

    <div style="background:white; border-radius:14px; border:1px solid #eee; padding:24px; margin-bottom:24px; box-shadow:0 2px 12px rgba(0,0,0,0.04);">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:20px;">
            <div>
                <p style="font-size:16px; font-weight:700; color:#222; margin-bottom:2px;">🩸 Blood supply overview</p>
                <p style="font-size:12px; color:#aaa;">Live availability across all blood types</p>
            </div>
            <div style="display:flex; gap:12px; font-size:11px; color:#888;">
                <span style="display:flex; align-items:center; gap:4px;"><span style="width:10px; height:10px; border-radius:50%; background:#27ae60; display:inline-block;"></span> Available</span>
                <span style="display:flex; align-items:center; gap:4px;"><span style="width:10px; height:10px; border-radius:50%; background:#f39c12; display:inline-block;"></span> Low</span>
                <span style="display:flex; align-items:center; gap:4px;"><span style="width:10px; height:10px; border-radius:50%; background:#e74c3c; display:inline-block;"></span> None eligible</span>
                <span style="display:flex; align-items:center; gap:4px;"><span style="width:10px; height:10px; border-radius:50%; background:#ddd; display:inline-block;"></span> No donors</span>
            </div>
        </div>

        <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:12px;">
            <%
                for (Map.Entry<String, int[]> entry : bloodTypeStats.entrySet()) {
                    String bt = entry.getKey();
                    int total = entry.getValue()[0];
                    int eligible = entry.getValue()[1];

                    String bgColor, dotColor, statusText, statusColor;

                    if (total == 0) {
                        bgColor = "#f7f7f7"; dotColor = "#ddd"; statusText = "No donors"; statusColor = "#bbb";
                    } else if (eligible == 0) {
                        bgColor = "#fff0f0"; dotColor = "#e74c3c"; statusText = "None eligible"; statusColor = "#e74c3c";
                    } else if (eligible <= 1) {
                        bgColor = "#fffbf0"; dotColor = "#f39c12"; statusText = "Low supply"; statusColor = "#f39c12";
                    } else {
                        bgColor = "#f0faf4"; dotColor = "#27ae60"; statusText = "Available"; statusColor = "#27ae60";
                    }
            %>

            <div style="background:<%= bgColor %>; border-radius:12px; padding:16px 12px; text-align:center; border:1px solid <%= dotColor %>22; position:relative; cursor:pointer;"
                 onclick="document.querySelector('#bloodTypeSelect').value='<%= bt %>'; document.querySelector('form').submit();">

                <div style="position:absolute; top:10px; right:10px; width:8px; height:8px; border-radius:50%; background:<%= dotColor %>;"></div>

                <div style="font-size:22px; font-weight:700; color:#c0392b; margin-bottom:6px;">
                    <%= bt %>
                </div>

                <div style="font-size:24px; font-weight:700; color:#222; margin-bottom:4px; line-height:1;">
                    <%= eligible %><span style="font-size:14px; color:#aaa; font-weight:400;">/<%= total %></span>
                </div>

                <div style="font-size:11px; font-weight:600; color:<%= statusColor %>; margin-bottom:8px;">
                    <%= statusText %>
                </div>

                <div style="font-size:10px; color:#bbb;">click to search</div>
            </div>

            <% } %>
        </div>

        <p style="font-size:11px; color:#ccc; margin-top:14px; text-align:right;">
            Showing eligible / total donors per blood type
        </p>
    </div>
    <% } %>
    <%-- Search form --%>
    <div class="search-card">
        <form action="http://localhost:8081/searchDonors" method="post">

            <%
                String currentMode = (String) request.getAttribute("searchMode");
                if (currentMode == null) currentMode = "exact";
            %>

            <div class="mode-row">
                <button type="button"
                        class="mode-btn <%= "exact".equals(currentMode) ? "active" : "" %>"
                        onclick="setMode('exact')">
                    🔍 Exact match
                </button>
                <button type="button"
                        class="mode-btn <%= "compatible".equals(currentMode) ? "active" : "" %>"
                        onclick="setMode('compatible')">
                    💉 Compatible donors
                </button>
            </div>
            <input type="hidden" name="searchMode" id="searchModeInput" value="<%= currentMode %>">

            <%-- Compatibility info box --%>
            <div class="compat-info <%= "compatible".equals(currentMode) ? "show" : "" %>" id="compatInfo">
                💡 Compatible mode finds all donor blood types that are safe for the selected blood group — not just exact matches.
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Blood group</label>
                    <select name="bloodType" id="bloodTypeSelect">
                        <option value="">All blood groups</option>
                        <%
                            String[] types = {"A+","A-","B+","B-","O+","O-","AB+","AB-"};
                            String selected = (String) request.getAttribute("searchedBloodType");
                            for (String t : types) {
                        %>
                        <option value="<%= t %>" <%= t.equals(selected) ? "selected" : "" %>><%= t %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Location</label>
                    <input type="text"
                           name="location"
                           placeholder="e.g. Kathmandu"
                           value="${searchedLocation}">

                    <label>Urgency</label>
                    <select name="urgency">
                        <option value="">All donors</option>
                        <option value="urgent" <%= "urgent".equals(request.getAttribute("searchedUrgency")) ? "selected" : "" %>>
                            🔴 Urgent only
                        </option>
                        <option value="normal" <%= "normal".equals(request.getAttribute("searchedUrgency")) ? "selected" : "" %>>
                            🟢 Normal only
                        </option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-search">Search Donors</button>
        </form>
    </div>

    <%-- Results --%>
    <%
        List<Donor> donors = (List<Donor>) request.getAttribute("donors");
    %>

    <% if (donors != null && !donors.isEmpty()) { %>

    <p class="result-label">
        Showing <strong><%= donors.size() %></strong> donor<%= donors.size() > 1 ? "s" : "" %>
        <% if (request.getAttribute("searchedBloodType") != null && !"".equals(request.getAttribute("searchedBloodType"))) { %>
        for <strong>${searchedBloodType}</strong>
        <% } %>
        <% if (request.getAttribute("searchedLocation") != null && !"".equals(request.getAttribute("searchedLocation"))) { %>
        in <strong>${searchedLocation}</strong>
        <% } %>
    </p>

    <div style="display:flex; flex-direction:column; gap:12px; width:100%;">
        <%
            for (Donor donor : donors) {
                String[] parts = donor.getName().split(" ");
                String initials = parts[0].substring(0,1).toUpperCase();
                if (parts.length > 1) initials += parts[parts.length-1].substring(0,1).toUpperCase();
                long days = donor.getDaysSinceLastDonation();
                boolean universal = BloodCompatibilityUtil.isUniversalDonor(donor.getBloodType());
        %>
        <div style="background:white; border-radius:12px; border:1px solid #eee; <%= donor.isUrgent() ? "border-left:4px solid #c0392b; background:#fffafa;" : "" %> padding:18px 20px; display:flex; flex-direction:row; align-items:center; gap:16px; width:100%;">

            <%-- Avatar --%>
            <div style="width:48px; height:48px; border-radius:50%; background:#fdecea; color:#c0392b; display:flex; align-items:center; justify-content:center; font-size:15px; font-weight:700; flex-shrink:0;">
                <%= initials %>
            </div>

            <%-- Donor info --%>
            <div style="flex:1; min-width:0;">
                <div style="font-size:16px; font-weight:600; margin-bottom:4px; color:#222;">
                    <%= donor.getName() %>
                </div>
                <div style="font-size:13px; color:#999; margin-bottom:10px;">
                    📍 <%= donor.getLocation() %>
                    <% if (days >= 0) { %>
                    &nbsp;·&nbsp; Last donated <%= days %> days ago
                    <% } else { %>
                    &nbsp;·&nbsp; No previous donation
                    <% } %>
                </div>
                <div style="display:flex; flex-direction:row; gap:6px; flex-wrap:wrap; align-items:center;">
                    <span style="background:#fdecea; color:#c0392b; font-size:13px; padding:4px 12px; border-radius:20px; font-weight:600;">
                        <%= donor.getBloodType() %>
                    </span>
                    <% if (donor.isUrgent()) { %>
                    <span style="background:#c0392b; color:white; font-size:11px; font-weight:600; padding:4px 10px; border-radius:20px; animation:pulse 1.5s infinite;">
                            🔴 URGENT
                        </span>
                    <% } %>
                    <% if (universal) { %>
                    <span style="background:#eaf4fd; color:#1a5276; font-size:11px; font-weight:600; padding:4px 10px; border-radius:20px;">
                            ⭐ Universal Donor
                        </span>
                    <% } %>
                    <% if (donor.isEligible()) { %>
                    <span style="background:#eafaf1; color:#1e8449; font-size:11px; font-weight:600; padding:4px 10px; border-radius:20px;">
                            ✓ Eligible now
                        </span>
                    <% } else { %>
                    <span style="background:#fef9e7; color:#b7950b; font-size:11px; font-weight:600; padding:4px 10px; border-radius:20px;">
                            ⏳ Wait period
                        </span>
                    <% } %>
                    <% if (days >= 0) { %>
                    <span style="background:#f0f0f0; color:#666; font-size:11px; font-weight:600; padding:4px 10px; border-radius:20px;">
                            <%= days %> days since last donation
                        </span>
                    <% } %>
                </div>
            </div>

            <%-- Contact button --%>
            <button style="background:white; border:1.5px solid #c0392b; color:#c0392b; padding:8px 18px; border-radius:8px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; flex-shrink:0;"
                    onclick="alert('📞 Contact <%= donor.getName() %>\nPhone: <%= donor.getPhone() %>\nBlood Type: <%= donor.getBloodType() %>\nLocation: <%= donor.getLocation() %>')">
                Contact
            </button>

        </div>
        <% } %>
    </div>

    <% } else if (donors != null && donors.isEmpty()) { %>

    <div class="empty-state">
        <div class="empty-icon">🔍</div>
        <p>No donors found</p>
        <span>Try a different blood group, switch to compatible mode, or search a different location</span>
    </div>

    <% } %>

    <div class="footer">
        Blood Bridge — Connecting donors with patients &nbsp;·&nbsp; Lifeline Coders © 2026
    </div>

</div>

<script>
    function setMode(mode) {
        document.getElementById('searchModeInput').value = mode;
        document.querySelectorAll('.mode-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');
        document.getElementById('compatInfo').classList.toggle('show', mode === 'compatible');
    }
</script>

</body>
</html>