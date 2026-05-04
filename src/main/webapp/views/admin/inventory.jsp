<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Inventory - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="admin-sidebar.jsp" />

        <main class="main-content">
            <header class="page-header">
                <h1>Blood Inventory</h1>
                <p>Monitor and manage blood stock levels across all types.</p>
            </header>

            <c:if test="${not empty param.success}">
                <div style="background: #e6fffa; color: #234e52; padding: 1rem; border-radius: 8px; border: 1px solid #b2f5ea; margin-bottom: 2rem; font-weight: 600;">
                    Inventory updated successfully.
                </div>
            </c:if>

            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>Blood Group</th>
                            <th>Current Stock</th>
                            <th>Status</th>
                            <th>Last Updated</th>
                            <th style="text-align: right;">Quick Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${inventory}">
                            <tr>
                                <td><strong>${item.bloodGroup}</strong></td>
                                <td><span style="font-weight: 800; font-size: 1.1rem;">${item.unitsAvailable}</span> Units</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.unitsAvailable < 10}">
                                            <span class="badge badge-rejected">Critical</span>
                                        </c:when>
                                        <c:when test="${item.unitsAvailable < 20}">
                                            <span class="badge badge-pending">Low</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-approved">Stable</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span style="font-size: 0.85rem; color: var(--clr-text-muted);">${item.lastUpdated}</span></td>
                                <td style="text-align: right;">
                                    <form action="${pageContext.request.contextPath}/admin/updateinventory" method="POST" style="display: flex; gap: 0.5rem; justify-content: flex-end; align-items: center;">
                                        <input type="hidden" name="bloodGroup" value="${item.bloodGroup}">
                                        <input type="number" name="units" value="1" min="1" style="width: 60px; padding: 0.4rem; border-radius: 6px; border: 1px solid var(--clr-border);">
                                        <button type="submit" name="action" value="add" class="btn-action" style="padding: 0.4rem 0.8rem; background: #28a745; color: white; border: none;">+ Add</button>
                                        <button type="submit" name="action" value="remove" class="btn-action" style="padding: 0.4rem 0.8rem; background: var(--clr-primary); color: white; border: none;">- Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty inventory}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 3rem; color: var(--clr-text-muted);">No inventory data found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
