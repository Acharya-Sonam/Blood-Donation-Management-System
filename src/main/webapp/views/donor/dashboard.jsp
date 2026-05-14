<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.BloodRequest, com.blooddonationmanagementsystem.model.Donor" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    List<BloodRequest> requests = (List<BloodRequest>) request.getAttribute("requests");
    Donor donor = (Donor) request.getAttribute("donor");
    Integer donationCount = (Integer) request.getAttribute("donationCount");
    Boolean isEligible = (Boolean) request.getAttribute("isEligible");
    String nextEligibleDate = (String) request.getAttribute("nextEligibleDate");
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Dashboard – Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .quick-search {
            background: var(--white);
            border-radius: var(--radius);
            padding: 20px;
            box-shadow: var(--shadow);
            margin-bottom: 28px;
            border-top: 4px solid var(--red-primary);
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }
        .search-form .form-group {
            flex: 1;
        }
        .search-form label {
            display: block;
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 5px;
        }
        .search-form select, .search-form input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .btn-search {
            background: var(--red-primary);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-search:hover { background: var(--red-dark); }
        
        .eligibility-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .eligible { background: #eafaf1; color: #1e8449; }
        .not-eligible { background: #fdedec; color: #cb4335; }
    </style>
</head>
<body>

    <jsp:include page="donor-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>Donor Dashboard</h1>
            <div class="topbar-right">
                <span class="admin-badge">Verified Donor</span>
                <div class="user-info">
                    <strong><%= donorName != null ? donorName : "Donor" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            
            <div class="section-title">📊 Your Statistics</div>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">🩸</div>
                    <div class="stat-number"><%= donor != null ? donor.getBloodGroup() : "N/A" %></div>
                    <div class="stat-label">Blood Group</div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon">✅</div>
                    <div class="stat-number"><%= donationCount != null ? donationCount : 0 %></div>
                    <div class="stat-label">Total Donations</div>
                </div>
                <div class="stat-card <%= (isEligible != null && isEligible) ? "blue" : "orange" %>">
                    <div class="stat-icon"><%= (isEligible != null && isEligible) ? "👍" : "⏳" %></div>
                    <div class="stat-number" style="font-size: 1.2rem; margin-top: 5px;">
                        <%= (isEligible != null && isEligible) ? "Eligible Now" : "Next: " + (nextEligibleDate != null ? nextEligibleDate : "TBD") %>
                    </div>
                    <div class="stat-label">Eligibility Status</div>
                </div>
            </div>

            <div class="section-title">🔍 Quick Donor Search</div>
            <div class="quick-search">
                <form action="<%= request.getContextPath() %>/donor/dashboard" method="get" class="search-form">
                    <input type="hidden" name="action" value="searchDonors">
                    <div class="form-group">
                        <label>Blood Group</label>
                        <select name="bloodGroup">
                            <option value="">Any</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Location</label>
                        <input type="text" name="location" placeholder="Enter city or area...">
                    </div>
                    <button type="submit" class="btn-search">Search Donors</button>
                </form>
            </div>

            <div class="section-title">💉 Pending Blood Requests</div>
            <div class="card">
                <div class="card-header">Active Requests in the System</div>
                <div class="table-wrap">
                    <% if (requests == null || requests.isEmpty()) { %>
                        <div style="padding: 40px; text-align: center; color: var(--text-muted);">
                            <p>No pending blood requests at the moment. You're all caught up! 🌟</p>
                        </div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Patient</th>
                                    <th>Blood Group</th>
                                    <th>Units</th>
                                    <th>Urgency</th>
                                    <th>Date</th>
                                    <th style="text-align: center;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (BloodRequest r : requests) {
                                        String badgeClass = "Critical".equalsIgnoreCase(r.getUrgency()) ? "badge-rejected"
                                                          : "Urgent".equalsIgnoreCase(r.getUrgency()) ? "badge-pending"
                                                          : "badge-accepted";
                                %>
                                <tr>
                                    <td><strong><%= r.getPatientName() != null ? r.getPatientName() : "Unknown" %></strong></td>
                                    <td><span class="admin-badge" style="background: #fdf2f2; color: #c0392b;"><%= r.getBloodGroup() %></span></td>
                                    <td><%= r.getQuantity() %> Unit(s)</td>
                                    <td><span class="badge <%= badgeClass %>"><%= r.getUrgency() %></span></td>
                                    <td><%= r.getRequestDate() %></td>
                                    <td style="text-align: center;">
                                        <form action="<%= request.getContextPath() %>/PatientController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="requestId" value="<%= r.getId() %>">
                                            <input type="hidden" name="status" value="Approved">
                                            <button class="logout-btn" style="background: #27ae60; padding: 5px 12px; border: none; cursor: pointer;" type="submit">Accept</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

</body>
</html>

