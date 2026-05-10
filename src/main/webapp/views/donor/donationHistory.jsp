<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation History - Blood Bridge</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .history-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        .history-card {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .history-stat {
            font-size: 0.9rem;
            color: var(--clr-text-muted);
        }
        .history-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--clr-secondary);
        }
    </style>
</head>
<body class="auth-page">
    <jsp:include page="../common/navbar.jsp" />

    <div class="container" style="margin-top: 4rem; margin-bottom: 4rem;">
        <div class="glass-card" style="padding: 3rem;">
            <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--clr-secondary); margin-bottom: 1rem;">
                Your Donation Journey
            </h1>
            <p style="color: var(--clr-text-muted); font-size: 1.1rem; margin-bottom: 2rem;">
                Every drop counts. Here's a look at the lives you've helped save.
            </p>
            
            <c:if test="${not empty param.success}">
                <div class="glass-card" style="padding: 1rem; background: rgba(40, 167, 69, 0.1); border: 1px solid rgba(40, 167, 69, 0.3); color: #28a745; margin-bottom: 2rem; border-radius: 12px; display: flex; align-items: center; gap: 10px;">
                    <span style="font-size: 1.2rem;">✅</span>
                    <span>Your donation has been recorded successfully! Thank you for your contribution.</span>
                </div>
            </c:if>

            <div style="display: flex; gap: 2rem; margin-bottom: 3rem; flex-wrap: wrap;">
                <div class="glass-card" style="padding: 1.5rem; flex: 1; min-width: 200px; border-color: rgba(230, 57, 70, 0.2);">
                    <div class="history-stat">Total Donations</div>
                    <div class="history-value">${totalDonations} Units</div>
                </div>
                <div class="glass-card" style="padding: 1.5rem; flex: 1; min-width: 200px;">
                    <div class="history-stat">Last Donation</div>
                    <div class="history-value">${not empty lastDonation ? lastDonation : 'N/A'}</div>
                </div>
                <div class="glass-card" style="padding: 1.5rem; flex: 1; min-width: 200px; border-color: ${isEligible ? '#28a74533' : '#e6394633'};">
                    <div class="history-stat">Next Eligibility</div>
                    <div class="history-value" style="color: ${isEligible ? '#28a745' : '#e63946'};">
                        ${isEligible ? 'Eligible Now' : nextEligible}
                    </div>
                </div>
            </div>

            <div class="table-container">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="border-bottom: 2px solid var(--clr-border);">
                            <th style="padding: 1rem; text-align: left;">Donation ID</th>
                            <th style="padding: 1rem; text-align: left;">Date</th>
                            <th style="padding: 1rem; text-align: left;">Units</th>
                            <th style="padding: 1rem; text-align: left;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${donations}">
                            <tr style="border-bottom: 1px solid var(--clr-border);">
                                <td style="padding: 1rem;">#${d.donationId}</td>
                                <td style="padding: 1rem;">${d.donationDate}</td>
                                <td style="padding: 1rem;">${d.unitsDonated} Units</td>
                                <td style="padding: 1rem;">
                                    <span class="badge badge-success">Completed</span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty donations}">
                            <tr>
                                <td colspan="4" style="padding: 4rem; text-align: center; color: var(--clr-text-muted);">
                                    You haven't made any donations yet. Start your journey today!
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
