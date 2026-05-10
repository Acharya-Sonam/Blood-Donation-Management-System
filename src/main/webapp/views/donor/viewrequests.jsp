<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Blood Requests - BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --dark: #2c3e50;
            --success: #27ae60;
            --danger: #e74c3c;
            --info: #3498db;
        }

        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }

        .header {
            background: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .container {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .request-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 6px solid var(--info);
            transition: 0.3s;
        }

        .request-card:hover { transform: scale(1.01); }

        .urgency-Critical { border-left-color: var(--danger); }
        .urgency-Urgent { border-left-color: #f39c12; }

        .info-group h4 { margin: 0; color: var(--dark); font-size: 1.2rem; }
        .info-group p { margin: 5px 0; color: #666; font-size: 0.9rem; }

        .blood-badge {
            background: var(--primary);
            color: white;
            padding: 5px 12px;
            border-radius: 6px;
            font-weight: 700;
        }

        .actions { display: flex; gap: 10px; }

        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-accept { background: var(--success); color: white; }
        .btn-accept:hover { background: #219150; }

        .btn-reject { background: #eee; color: #333; }
        .btn-reject:hover { background: #ddd; }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="header">
        <h2><i class="fas fa-handholding-heart"></i> Patient Blood Requests</h2>
        <span>Showing all pending requests</span>
    </div>

    <div class="container">
        <c:if test="${empty requests}">
            <div style="text-align:center; padding:50px; background:white; border-radius:15px;">
                <i class="fas fa-check-circle" style="font-size:60px; color:var(--success);"></i>
                <h3 style="margin-top:20px;">No Pending Requests Found</h3>
                <p>All blood requests are currently fulfilled. Great job!</p>
            </div>
        </c:if>

        <c:forEach var="req" items="${requests}">
            <div class="request-card urgency-${req.urgency}">
                <div class="info-group">
                    <h4>${req.patientName}'s Request</h4>
                    <p><i class="fas fa-tint"></i> Blood Group: <span class="blood-badge">${req.bloodGroup}</span></p>
                    <p><i class="fas fa-cubes"></i> Quantity: ${req.quantity} Units</p>
                    <p><i class="fas fa-clock"></i> Requested on: ${req.requestDate}</p>
                    <p><i class="fas fa-exclamation-circle"></i> Urgency: <strong>${req.urgency}</strong></p>
                </div>

                <div class="actions">
                    <form action="PatientController" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" value="${req.id}">
                        <input type="hidden" name="status" value="Accepted">
                        <button type="submit" class="btn-action btn-accept">
                            <i class="fas fa-check"></i> Accept
                        </button>
                    </form>

                    <form action="PatientController" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" value="${req.id}">
                        <input type="hidden" name="status" value="Rejected">
                        <button type="submit" class="btn-action btn-reject">
                            <i class="fas fa-times"></i> Reject
                        </button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>
