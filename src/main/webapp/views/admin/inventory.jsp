<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blood Inventory | Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>📦 Blood Inventory</h1>
            <div class="topbar-right">
                <span class="admin-badge">Administrator</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <div class="card">
                <div class="card-header">Update Blood Stock</div>
                <div style="padding: 20px;">
                    <form action="${pageContext.request.contextPath}/admin/inventory" method="POST" style="display: flex; gap: 15px; align-items: flex-end;">
                        <div style="flex: 1;">
                            <label style="display: block; font-size: 0.8rem; margin-bottom: 5px; color: var(--text-muted);">Blood Group</label>
                            <select name="bloodGroup" class="admin-badge" style="width: 100%; border: 1px solid var(--border); background: #fff; padding: 10px;">
                                <option>A+</option><option>A-</option>
                                <option>B+</option><option>B-</option>
                                <option>O+</option><option>O-</option>
                                <option>AB+</option><option>AB-</option>
                            </select>
                        </div>
                        <div style="flex: 1;">
                            <label style="display: block; font-size: 0.8rem; margin-bottom: 5px; color: var(--text-muted);">Units to Add/Set</label>
                            <input type="number" name="units" required placeholder="e.g. 10" 
                                   style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border); outline: none;">
                        </div>
                        <button type="submit" class="logout-btn" style="padding: 10px 25px;">Update Stock</button>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Current Inventory Overview</div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Blood Group</th>
                                <th>Stock Level</th>
                                <th>Status</th>
                                <th style="width: 60%;">Visual Indicator</th>
                            </tr>
                        </thead>
                        <tbody>
                             <c:forEach var="item" items="${inventory}">
                                <tr>
                                    <td><strong>${item.bloodGroup}</strong></td>
                                    <td>${item.unitsAvailable} Units</td>
                                    <td>
                                        <span class="badge ${item.unitsAvailable < 5 ? 'badge-rejected' : (item.unitsAvailable > 15 ? 'badge-accepted' : 'badge-pending')}">
                                            ${item.unitsAvailable < 5 ? 'Low Stock' : (item.unitsAvailable > 15 ? 'High' : 'Normal')}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="bar-track" style="margin: 0;">
                                            <div class="bar-fill ${item.unitsAvailable < 5 ? 'orange' : (item.unitsAvailable > 15 ? 'green' : 'blue')}" 
                                                 style="width: ${item.unitsAvailable * 5}%">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
