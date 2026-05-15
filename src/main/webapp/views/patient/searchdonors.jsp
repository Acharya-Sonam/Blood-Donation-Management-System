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
        /* Specific overrides for search page results to keep it premium but integrated */
        .page-header-integrated {
            background: var(--red-primary);
            padding: 32px 28px 60px;
            color: white;
            margin: -28px -28px 0 -28px;
            margin-bottom: 30px;
        }
        .page-header-integrated h1 { font-size: 1.8rem; font-weight: 800; margin-bottom: 8px; }
        .page-header-integrated p { opacity: 0.8; font-size: 0.9rem; }

        .search-card-refined {
            background: white;
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: var(--shadow);
            margin-top: -50px;
            margin-bottom: 24px;
            position: relative;
            z-index: 5;
        }
        .form-row { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .form-group { flex: 1; min-width: 180px; }
        .form-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; }
        .form-group input, .form-group select {
            width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem;
        }
        .btn-search-refined {
            background: var(--sidebar-bg); color: white; border: none; padding: 12px 30px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s;
        }
        .btn-search-refined:hover { background: var(--red-primary); }

        .donor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .donor-card {
            background: white; border-radius: var(--radius); padding: 20px; box-shadow: var(--shadow); transition: 0.2s; border-bottom: 4px solid transparent;
        }
        .donor-card:hover { transform: translateY(-5px); border-bottom-color: var(--red-primary); }
        .blood-badge-large {
            background: var(--red-light); color: var(--red-primary); font-size: 1.2rem; font-weight: 800; padding: 10px 15px; border-radius: 10px; display: inline-block;
        }
        .avail-badge { font-size: 0.7rem; font-weight: 700; padding: 4px 10px; border-radius: 20px; text-transform: uppercase; }
        .avail-yes { background: #eafaf1; color: #1e8449; }
        .avail-no { background: #fdedec; color: #cb4335; }
    </style>
</head>
<body>

    <%-- Sidebar based on role --%>
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

            <div class="search-card-refined">
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
                    </div>
                </form>
            </div>

            <%
                if (donors != null) {
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
            %>

            <div class="section-title">✨ <%= filtered.size() %> Donors Found</div>
            
            <div class="donor-grid">
                <% for (Donor d : filtered) {
                    boolean isAvail = d.getLastDonation() == null || d.getLastDonation().isEmpty();
                %>
                <div class="donor-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <span class="blood-badge-large"><%= d.getBloodGroup() %></span>
                        <span class="avail-badge <%= isAvail ? "avail-yes" : "avail-no" %>">
                            <%= isAvail ? "Available" : "Cooling Down" %>
                        </span>
                    </div>
                    <h3 style="font-size: 1.1rem; margin-bottom: 10px;"><%= d.getFullName() %></h3>
                    <div style="color: var(--text-muted); font-size: 0.85rem; display: flex; flex-direction: column; gap: 8px;">
                        <div>📍 <%= d.getAddress() %></div>
                        <div>📞 <%= d.getPhone() %></div>
                        <% if (!isAvail) { %>
                            <div style="color: var(--red-primary); font-weight: 600;">🗓️ Last Donated: <%= d.getLastDonation() %></div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>

            <% if (filtered.isEmpty()) { %>
                <div class="card" style="padding: 50px; text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 15px;">🔍</div>
                    <h3>No matching donors found</h3>
                    <p style="color: var(--text-muted);">Try adjusting your filters or searching in a different location.</p>
                </div>
            <% } %>

            <% } %>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>

</body>
</html>
