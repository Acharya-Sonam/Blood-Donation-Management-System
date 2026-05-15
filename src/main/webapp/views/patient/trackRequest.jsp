<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 4/2/2026
  Time: 1:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track My Requests - BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --dark: #2c3e50;
            --light: #ecf0f1;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --white: #ffffff;
        }

        body {
            background: #f8f9fa;
            font-family: 'Inter', sans-serif;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            background: var(--white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #f1f1f1;
            padding-bottom: 20px;
        }

        h2 {
            color: var(--dark);
            margin: 0;
            font-size: 24px;
        }

        h2 i {
            color: var(--primary);
            margin-right: 10px;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-pending { background: #fff8e1; color: #ffa000; border: 1px solid #ffe082; }
        .status-accepted { background: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        .status-rejected { background: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        th {
            background: none;
            color: #888;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            padding: 10px 20px;
        }

        tbody tr {
            background: var(--white);
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            transition: 0.3s;
        }

        tbody tr:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        td {
            padding: 20px;
            border-top: 1px solid #f1f1f1;
            border-bottom: 1px solid #f1f1f1;
        }

        td:first-child { border-left: 1px solid #f1f1f1; border-radius: 12px 0 0 12px; }
        td:last-child { border-right: 1px solid #f1f1f1; border-radius: 0 12px 12px 0; }

        .blood-group-icon {
            background: var(--primary);
            color: white;
            width: 35px;
            height: 35px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-weight: bold;
            margin-right: 10px;
        }

        .urgency-Critical { color: var(--danger); font-weight: 700; }
        .urgency-Urgent { color: var(--warning); font-weight: 600; }

        .btn-cancel {
            background: #fff;
            color: #999;
            border: 1px solid #ddd;
            padding: 8px 15px;
            border-radius: 8px;
            font-size: 13px;
            transition: 0.3s;
        }

        .btn-cancel:hover {
            border-color: var(--danger);
            color: var(--danger);
            background: #fff5f5;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container fade-in">
        <a href="${pageContext.request.contextPath}/patient/dashboard" style="text-decoration:none; color:var(--primary); font-weight:600; display:inline-block; margin-bottom:15px;">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="header-section">
            <h2><i class="fas fa-history"></i> My Blood Requests</h2>
            <a href="PatientController?action=requestForm" style="text-decoration:none; color:var(--primary); font-weight:600;"><i class="fas fa-plus"></i> New Request</a>
        </div>

        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("cancelled")) { %>
            <div class="alert" style="background:#e6fffa; color:#2c7a7b; padding:15px; border-radius:10px; margin-bottom:20px; border:1px solid #b2f5ea;">
                <i class="fas fa-check-circle"></i> Request cancelled successfully.
            </div>
        <% } %>
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("cancel_error")) { %>
            <div class="alert" style="background:#fff5f5; color:#c53030; padding:15px; border-radius:10px; margin-bottom:20px; border:1px solid #feb2b2;">
                <i class="fas fa-exclamation-circle"></i> Failed to cancel request.
            </div>
        <% } %>

        <c:if test="${empty requests}">
            <div style="text-align: center; padding: 60px;">
                <img src="https://cdni.iconscout.com/illustration/premium/thumb/no-data-found-8867280-7265556.png" style="width:200px; opacity:0.5;">
                <p style="margin-top: 15px; color: #777;">You haven't made any blood requests yet.</p>
            </div>
        </c:if>

        <c:if test="${not empty requests}">
            <table>
                <thead>
                    <tr>
                        <th>Request Details</th>
                        <th>Quantity</th>
                        <th>Urgency</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${requests}">
                        <tr>
                            <td>
                                <div style="display:flex; align-items:center;">
                                    <div class="blood-group-icon">${req.bloodGroup}</div>
                                    <div>
                                        <div style="font-weight:600; color:var(--dark);">Blood Group ${req.bloodGroup}</div>
                                        <div style="font-size:12px; color:#999;">Requested on ${req.requestDate}</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight:600;">${req.quantity} <span style="font-weight:400; color:#888;">Units</span></div>
                            </td>
                            <td>
                                <span class="urgency-${req.urgency}">
                                    <i class="fas fa-bolt"></i> ${req.urgency}
                                </span>
                            </td>
                            <td>
                                <span class="status-badge status-${req.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${req.status eq 'Pending'}"><i class="fas fa-clock"></i></c:when>
                                        <c:when test="${req.status eq 'Accepted'}"><i class="fas fa-check-circle"></i></c:when>
                                        <c:when test="${req.status eq 'Rejected'}"><i class="fas fa-times-circle"></i></c:when>
                                    </c:choose>
                                    ${req.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${req.status eq 'Pending'}">
                                    <form action="PatientController" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this request?')">
                                        <input type="hidden" name="action" value="cancelRequest">
                                        <input type="hidden" name="requestId" value="${req.id}">
                                        <button type="submit" class="btn-cancel"><i class="fas fa-trash-alt"></i> Cancel</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</body>
</html>
