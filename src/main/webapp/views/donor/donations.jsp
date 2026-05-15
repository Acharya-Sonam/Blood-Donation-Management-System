<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    Boolean isEligible = (Boolean) request.getAttribute("isEligible");
    String nextEligible = (String) request.getAttribute("nextEligible");
    Integer linkedRequestId = (Integer) request.getAttribute("linkedRequestId");
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Record Donation – Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .donation-form-card {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: var(--radius);
            padding: 40px;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--red-primary);
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header h2 {
            font-size: 1.5rem;
            color: var(--text-dark);
            margin-bottom: 8px;
        }
        .form-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        .linked-request-alert {
            background: #eafaf1;
            border: 1px solid #c3e6cb;
            color: #1e8449;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.9rem;
        }
        .btn-submit-donation {
            width: 100%;
            background: var(--red-primary);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
        }
        .btn-submit-donation:hover {
            background: var(--red-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(192,57,43,0.2);
        }
        .btn-submit-donation:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
    </style>
</head>
<body>

<jsp:include page="donor-sidebar.jsp" />

<main class="main-content">
    <header class="topbar">
        <h1>Record Donation</h1>
        <div class="topbar-right">
            <span class="admin-badge">Official Record</span>
            <div class="user-info">
                <strong><%= donorName != null ? donorName : "Donor" %></strong>
            </div>
        </div>
    </header>

    <div class="page-body">
        
        <div class="donation-form-card">
            <div class="form-header">
                <h2>Log Your Contribution</h2>
                <p>Register your donation details to keep your medical history updated.</p>
            </div>

            <% if (linkedRequestId != null && linkedRequestId > 0) { %>
                <div class="linked-request-alert">
                    <span>✓</span>
                    <div>
                        <strong>Fulfilling Request #<%= linkedRequestId %></strong>
                        <p style="margin: 0; font-size: 0.8rem;">This donation will be linked to the patient's blood request.</p>
                    </div>
                </div>
            <% } %>

            <% if (isEligible != null && !isEligible) { %>
                <div class="alert alert-error" style="margin-bottom: 24px; background: #fdf2f2; border: 1px solid #f5c6cb; color: #c0392b; padding: 15px; border-radius: 8px;">
                    <strong>Eligibility Alert:</strong> You are not eligible to donate yet. 
                    Standard safety period is 3 months. Next available date: <%= nextEligible %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/donor/donations" method="POST">
                <input type="hidden" name="inventoryId" value="0">
                <input type="hidden" name="requestId" value="<%= linkedRequestId != null ? linkedRequestId : "" %>">

                <div class="input-group">
                    <label>Donation Date</label>
                    <input type="date" name="donationDate" required 
                           value="<%= LocalDate.now() %>"
                           <%= (isEligible != null && !isEligible) ? "disabled" : "" %>>
                </div>

                <div class="input-group">
                    <label>Units Donated</label>
                    <select name="units" required <%= (isEligible != null && !isEligible) ? "disabled" : "" %>>
                        <option value="1">1 Unit (Standard)</option>
                        <option value="2">2 Units (Power Donation)</option>
                    </select>
                </div>

                <% if (linkedRequestId == null || linkedRequestId <= 0) { %>
                <div class="input-group">
                    <label>Reference Request ID (Optional)</label>
                    <input type="number" name="requestId" placeholder="Leave blank for walk-in donation"
                           <%= (isEligible != null && !isEligible) ? "disabled" : "" %>>
                </div>
                <% } %>

                <button type="submit" class="btn-submit-donation" <%= (isEligible != null && !isEligible) ? "disabled" : "" %>>
                    Confirm & Record Donation
                </button>
            </form>

            <div style="text-align: center; margin-top: 25px;">
                <a href="<%= request.getContextPath() %>/donor/donationHistory" style="color: var(--red-primary); text-decoration: none; font-size: 0.9rem; font-weight: 600;">
                    ← View My Donation History
                </a>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </div>
</main>

</body>
</html>
