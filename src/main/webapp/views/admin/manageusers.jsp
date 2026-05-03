<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Panel</title>
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
                <h1>Manage Users</h1>
                <p>Approve, reject, or update roles for registered members.</p>
            </header>

            <c:if test="${not empty param.success}">
                <div style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 12px; margin-bottom: 2rem; font-weight: 600;">
                    Action completed successfully.
                </div>
            </c:if>

            <div style="margin-bottom: 2rem; display: flex; gap: 0.5rem;">
                <a href="?filter=all" class="btn-action ${param.filter == 'all' || empty param.filter ? 'active' : ''}">All Users</a>
                <a href="?filter=pending" class="btn-action ${param.filter == 'pending' ? 'active' : ''}">Pending</a>
                <a href="?filter=approved" class="btn-action ${param.filter == 'approved' ? 'active' : ''}">Approved</a>
            </div>

            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.userId}</td>
                                <td><strong>${u.name}</strong></td>
                                <td>${u.email}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/updaterole" method="POST" style="display:inline;">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <select name="role" onchange="this.form.submit()" class="role-select">
                                            <option value="donor" ${u.role == 'donor' ? 'selected' : ''}>Donor</option>
                                            <option value="patient" ${u.role == 'patient' ? 'selected' : ''}>Patient</option>
                                            <option value="admin" ${u.role == 'admin' ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <span class="badge badge-${u.status}">${u.status}</span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <c:if test="${u.status == 'pending'}">
                                            <form action="${pageContext.request.contextPath}/admin/approve" method="POST">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <button type="submit" class="btn-action btn-approve">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/reject" method="POST">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <button type="submit" class="btn-action btn-reject">Reject</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/admin/delete" method="POST" onsubmit="return confirm('Are you sure?')">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <button type="submit" class="btn-action">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 3rem; color: var(--clr-text-muted);">No users found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>