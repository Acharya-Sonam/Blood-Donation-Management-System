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
        }

        body {
            background: #f4f7f6;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        h2 {
            color: var(--dark);
            margin-bottom: 25px;
            border-left: 5px solid var(--primary);
            padding-left: 15px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-accepted { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            text-align: left;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f8f9fa;
            color: var(--dark);
            font-weight: 600;
        }

        tr:hover { background: #fafafa; }

        .urgency-Critical { color: var(--danger); font-weight: bold; }
        .urgency-Urgent { color: var(--warning); font-weight: bold; }

        .btn-cancel {
            background: none;
            border: 1px solid var(--danger);
            color: var(--danger);
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-cancel:hover {
            background: var(--danger);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container fade-in">
        <h2><i class="fas fa-list-ul"></i> My Blood Requests</h2>

        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("cancelled")) { %>
            <div class="alert" style="background:#d4edda; color:#155724; padding:15px; border-radius:10px; margin-bottom:20px;">
                Request cancelled successfully.
            </div>
        <% } %>
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("cancel_error")) { %>
            <div class="alert" style="background:#f8d7da; color:#721c24; padding:15px; border-radius:10px; margin-bottom:20px;">
                Failed to cancel request. It may đã be processed.
            </div>
        <% } %>

        <c:if test="${empty requests}">
            <div style="text-align: center; padding: 40px;">
                <i class="fas fa-search-plus" style="font-size: 50px; color: #ccc;"></i>
                <p style="margin-top: 15px; color: #777;">You haven't made any blood requests yet.</p>
                <a href="PatientController?action=requestForm" class="btn-primary" style="display: inline-block; margin-top: 20px; padding: 10px 20px; background: var(--primary); color: white; text-decoration: none; border-radius: 5px;">Make a Request</a>
            </div>
        </c:if>

        <c:if test="${not empty requests}">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Blood Group</th>
                        <th>Quantity</th>
                        <th>Urgency</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${requests}">
                        <tr>
                            <td>${req.requestDate}</td>
                            <td><strong>${req.bloodGroup}</strong></td>
                            <td>${req.quantity} Units</td>
                            <td>
                                <span class="urgency-${req.urgency}">${req.urgency}</span>
                            </td>
                            <td>
                                <span class="status-badge status-${req.status.toLowerCase()}">${req.status}</span>
                            </td>
                            <td>
                                <c:if test="${req.status eq 'Pending'}">
                                    <form action="PatientController" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this request?')">
                                        <input type="hidden" name="action" value="cancelRequest">
                                        <input type="hidden" name="requestId" value="${req.id}">
                                        <button type="submit" class="btn-cancel">Cancel</button>
                                    </form>
                                </c:if>
                                <c:if test="${req.status ne 'Pending'}">
                                    <span style="color: #999; font-size: 12px;">No actions</span>
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
