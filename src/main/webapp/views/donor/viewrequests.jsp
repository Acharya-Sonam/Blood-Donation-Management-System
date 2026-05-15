<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.blooddonationmanagementsystem.model.BloodRequest" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    List<BloodRequest> requests = (List<BloodRequest>) request.getAttribute("requests");
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Requests – Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 24px;
            margin-top: 20px;
        }
        .request-card-premium {
            background: white;
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--red-primary);
            transition: transform 0.2s;
            position: relative;
            overflow: hidden;
        }
        .request-card-premium:hover {
            transform: translateY(-5px);
        }
        .urgency-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .urgency-critical { background: #fdf2f2; color: #c0392b; border: 1px solid #f5c6cb; }
        .urgency-urgent { background: #fff9e6; color: #f39c12; border: 1px solid #ffeeba; }
        .urgency-normal { background: #eafaf1; color: #1e8449; border: 1px solid #c3e6cb; }

        .patient-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .patient-avatar {
            width: 50px;
            height: 50px;
            background: #f0f2f5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .patient-details h3 {
            font-size: 1.1rem;
            margin: 0;
            color: var(--text-dark);
        }
        .patient-details p {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin: 2px 0 0;
        }

        .request-specs {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-top: 1px solid #f0f2f5;
            border-bottom: 1px solid #f0f2f5;
            margin-bottom: 20px;
        }
        .spec-item {
            text-align: center;
        }
        .spec-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            display: block;
            margin-bottom: 4px;
        }
        .spec-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        .blood-group-large {
            color: var(--red-primary);
        }

        .action-group {
            display: flex;
            gap: 12px;
        }
        .btn-accept {
            flex: 2;
            background: var(--red-primary);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-accept:hover { background: var(--red-dark); }
        
        .btn-ignore {
            flex: 1;
            background: #f0f2f5;
            color: var(--text-dark);
            border: none;
            padding: 10px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
    </style>
</head>
<body>

<jsp:include page="donor-sidebar.jsp" />

<main class="main-content">
    <header class="topbar">
        <h1>Available Blood Requests</h1>
        <div class="topbar-right">
            <span class="admin-badge">Real-time Feed</span>
            <div class="user-info">
                <strong><%= donorName != null ? donorName : "Donor" %></strong>
            </div>
        </div>
    </header>

    <div class="page-body">
        <div class="section-title">🩸 Helping Hands Needed</div>
        
        <% if (requests == null || requests.isEmpty()) { %>
            <div class="card" style="padding: 60px; text-align: center;">
                <div style="font-size: 4rem; margin-bottom: 20px;">🌟</div>
                <h3>No Pending Requests</h3>
                <p style="color: var(--text-muted); max-width: 400px; margin: 10px auto;">Great news! All patients have been attended to. Check back later for new requests.</p>
                <a href="<%= request.getContextPath() %>/donor/dashboard" class="btn-find-donor" style="display:inline-block; margin-top: 20px;">Back to Dashboard</a>
            </div>
        <% } else { %>
            <div class="request-grid">
                <% for (BloodRequest r : requests) { 
                    String urgencyClass = r.getUrgency().toLowerCase();
                %>
                    <div class="request-card-premium">
                        <span class="urgency-badge urgency-<%= urgencyClass %>">
                            <%= r.getUrgency() %>
                        </span>
                        
                        <div class="patient-info">
                            <div class="patient-avatar">👤</div>
                            <div class="patient-details">
                                <h3><%= r.getPatientName() != null ? r.getPatientName() : "Anonymous Patient" %></h3>
                                <p>Requested on <%= r.getRequestDate() %></p>
                            </div>
                        </div>

                        <div class="request-specs">
                            <div class="spec-item">
                                <span class="spec-label">Blood Group</span>
                                <span class="spec-value blood-group-large"><%= r.getBloodGroup() %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Quantity</span>
                                <span class="spec-value"><%= r.getQuantity() %> Units</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Status</span>
                                <span class="spec-value" style="color: #f39c12;"><%= r.getStatus() %></span>
                            </div>
                        </div>

                        <div class="action-group">
                            <form action="<%= request.getContextPath() %>/PatientController" method="post" style="width: 100%; display: flex; gap: 10px;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="requestId" value="<%= r.getId() %>">
                                <input type="hidden" name="status" value="Approved">
                                <button type="submit" class="btn-accept">Accept Request</button>
                                <button type="button" class="btn-ignore" onclick="this.closest('.request-card-premium').style.opacity='0.5'">Ignore</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <jsp:include page="../common/footer.jsp" />
    </div>
</main>

</body>
</html>
