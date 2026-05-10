<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Record Donation - Blood Bridge</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <jsp:include page="../common/navbar.jsp" />

    <div class="auth-wrapper">
        <div class="auth-card glass-card">
            <div class="auth-header">
                <h2>Record Donation</h2>
                <p>Register your donation to update your history and eligibility.</p>
            </div>

            <c:if test="${not isEligible}">
                <div class="alert alert-error" style="margin-bottom: 2rem;">
                    <strong>Not Eligible:</strong> You can donate again after ${nextEligible}. 
                    Standard cooling period is 3 months between donations.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/donor/donations" method="POST" class="auth-form">
                <input type="hidden" name="inventoryId" value="0"> <!-- Handled automatically by server based on blood group -->
                
                <div class="form-group">
                    <label for="donationDate">Donation Date</label>
                    <input type="date" id="donationDate" name="donationDate" required 
                           value="<%= java.time.LocalDate.now() %>"
                           ${not isEligible ? 'disabled' : ''}>
                </div>

                <div class="form-group">
                    <label for="units">Units Donated</label>
                    <select id="units" name="units" required ${not isEligible ? 'disabled' : ''}>
                        <option value="1">1 Unit (Standard)</option>
                        <option value="2">2 Units</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="requestId">Request ID (Optional)</label>
                    <input type="number" id="requestId" name="requestId" placeholder="Enter Request ID if linked to a specific patient"
                           ${not isEligible ? 'disabled' : ''}>
                </div>

                <button type="submit" class="btn btn-primary btn-full" ${not isEligible ? 'disabled' : ''}>
                    Record Donation
                </button>
            </form>

            <div class="auth-footer">
                <p><a href="${pageContext.request.contextPath}/donor/donationHistory">View Donation History</a></p>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
