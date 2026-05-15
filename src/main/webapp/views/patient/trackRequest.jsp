<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Requests | Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .request-card {
            background: white; border-radius: var(--radius); padding: 20px; box-shadow: var(--shadow); margin-bottom: 20px; border-left: 5px solid var(--red-primary); display: flex; justify-content: space-between; align-items: center;
        }
        .request-main { display: flex; align-items: center; gap: 20px; }
        .blood-group-circle {
            width: 50px; height: 50px; border-radius: 50%; background: var(--red-light); color: var(--red-primary); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 1.2rem;
        }
        .request-details h3 { font-size: 1rem; margin-bottom: 4px; }
        .request-details p { font-size: 0.8rem; color: var(--text-muted); }
        
        .status-pill { padding: 6px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .status-pending { background: #fef9e7; color: #d68910; }
        .status-accepted { background: #eafaf1; color: #1e8449; }
        .status-rejected { background: #fdedec; color: #cb4335; }
        
        .btn-cancel {
            background: transparent; color: #cb4335; border: 1px solid #f5b7b1; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 0.8rem; font-weight: 600; transition: 0.2s;
        }
        .btn-cancel:hover { background: #fdedec; }
    </style>
</head>
<body>

    <jsp:include page="patient-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>📜 My Blood Requests</h1>
            <div class="topbar-right">
                <span class="admin-badge">Patient</span>
                <div class="user-info">
                    <strong><%= donorName != null ? donorName : "User" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="section-title">🕒 Request History</div>

            <c:if test="${empty requests}">
                <div class="card" style="padding: 60px; text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 15px;">📋</div>
                    <h3>No requests found</h3>
                    <p style="color: var(--text-muted);">You haven't posted any blood requests yet.</p>
                    <a href="PatientController?action=requestForm" class="logout-btn" style="display: inline-block; margin-top: 20px;">Post First Request</a>
                </div>
            </c:if>

            <c:forEach var="req" items="${requests}">
                <div class="request-card">
                    <div class="request-main">
                        <div class="blood-group-circle">${req.bloodGroup}</div>
                        <div class="request-details">
                            <h3>Blood Group ${req.bloodGroup} Needed</h3>
                            <p>Requested on ${req.requestDate} | Quantity: ${req.quantity} Units</p>
                            <p>Urgency: <strong>${req.urgency}</strong></p>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <span class="status-pill status-${req.status.toLowerCase()}">${req.status}</span>
                        <c:if test="${req.status eq 'Pending'}">
                            <form action="PatientController" method="POST" onsubmit="return confirm('Cancel this request?')">
                                <input type="hidden" name="action" value="cancelRequest">
                                <input type="hidden" name="requestId" value="${req.id}">
                                <button type="submit" class="btn-cancel"><i class="fas fa-trash"></i> Cancel</button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>

</body>
</html>
