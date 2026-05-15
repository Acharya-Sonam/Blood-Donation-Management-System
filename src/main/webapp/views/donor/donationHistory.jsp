<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation History | Blood Bridge</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        :root {
            --font: 'Inter', sans-serif;
        }
        body { font-family: var(--font); }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--red-primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 20px;
            transition: gap 0.2s;
        }
        .back-link:hover { gap: 12px; }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="donor-sidebar.jsp" />

    <main class="main-content">
        <!-- Top bar -->
        <header class="topbar">
            <h1>📜 Donation History</h1>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/donor/dashboard" class="logout-btn" style="background: var(--sidebar-bg); margin-right: 10px;">
                    🏠 Dashboard
                </a>
                <span class="admin-badge">Donor</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <a href="${pageContext.request.contextPath}/donor/dashboard" class="back-link">
                ← Back to Dashboard
            </a>

            <div class="section-title">📊 Lifetime Impact</div>
            
            <div class="stats-grid">
                <div class="stat-card blue">
                    <span class="stat-icon">🩸</span>
                    <span class="stat-number">${totalDonations}</span>
                    <span class="stat-label">Total Units Donated</span>
                </div>
                <div class="stat-card green">
                    <span class="stat-icon">🗓️</span>
                    <span class="stat-number" style="font-size: 1.2rem; margin-top: 10px;">
                        ${not empty lastDonation ? lastDonation : 'Never'}
                    </span>
                    <span class="stat-label">Last Donation Date</span>
                </div>
                <div class="stat-card ${isEligible ? 'green' : 'orange'}">
                    <span class="stat-icon">${isEligible ? '✅' : '⏳'}</span>
                    <span class="stat-number" style="font-size: 1.1rem; margin-top: 10px;">
                        ${isEligible ? 'Eligible Now' : nextEligible}
                    </span>
                    <span class="stat-label">Eligibility Status</span>
                </div>
            </div>

            <div class="section-title">🕒 Detailed Records</div>
            <div class="card">
                <div class="card-header">Your Donation Logs</div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Donation ID</th>
                                <th>Date of Donation</th>
                                <th>Quantity (Units)</th>
                                <th>Verification Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${donations}">
                                <tr>
                                    <td><span style="font-family: monospace; font-weight: 600;">#${d.donationId}</span></td>
                                    <td>${d.donationDate}</td>
                                    <td><strong>${d.unitsDonated} Units</strong></td>
                                    <td>
                                        <span class="badge badge-accepted">Completed</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty donations}">
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        <strong>You haven't made any donations yet. Start your journey today!</strong>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
