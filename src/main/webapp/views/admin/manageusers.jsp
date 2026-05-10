<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced User Management - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>👥 Manage Users</h1>
            <div class="topbar-right">
                <span class="admin-badge">Administrator</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <!-- Search & Filters -->
            <div class="card" style="padding: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <div style="display: flex; gap: 10px;">
                        <a href="?filter=all" class="admin-badge" style="text-decoration: none; ${param.filter == 'all' || empty param.filter ? 'background: var(--red-primary); color: white;' : ''}">All Members</a>
                        <a href="?filter=pending" class="admin-badge" style="text-decoration: none; ${param.filter == 'pending' ? 'background: var(--red-primary); color: white;' : ''}">Pending Review</a>
                        <a href="?filter=approved" class="admin-badge" style="text-decoration: none; ${param.filter == 'approved' ? 'background: var(--red-primary); color: white;' : ''}">Verified Members</a>
                    </div>
                </div>

                <form action="" method="GET" style="display: flex; gap: 10px;">
                    <input type="hidden" name="filter" value="${param.filter}">
                    <input type="text" name="search" placeholder="Search by name, email, or role..." value="${param.search}" 
                           style="flex: 1; padding: 10px 15px; border-radius: 8px; border: 1px solid var(--border); outline: none;">
                    <button type="submit" class="logout-btn">Search Now</button>
                </form>
            </div>

            <c:if test="${not empty param.success}">
                <div class="admin-badge" style="width: 100%; margin-bottom: 20px; padding: 15px; background: #eafaf1; color: #1e8449; border: 1px solid #82e0aa;">
                    ✅ Action processed successfully.
                </div>
            </c:if>

            <div class="card">
                <div class="card-header">User Database</div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Member</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Registration</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td><span style="font-family: monospace;">#${u.userId}</span></td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <div style="width: 32px; height: 32px; background: var(--red-light); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: var(--red-primary);">
                                                ${not empty u.name ? u.name.substring(0,1).toUpperCase() : 'U'}
                                            </div>
                                            <div>
                                                <div style="font-weight: 600;">${u.name}</div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted);">${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="admin-badge" style="background: #f4f6f9; color: #2c3e50;">${u.role}</span></td>
                                    <td>
                                        <span class="badge ${u.status == 'pending' ? 'badge-pending' : (u.status == 'approved' ? 'badge-accepted' : 'badge-rejected')}">
                                            ${u.status}
                                        </span>
                                    </td>
                                    <td><div style="font-size: 0.8rem; color: var(--text-muted);">${u.createdAt}</div></td>
                                    <td>
                                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                            <c:if test="${u.status == 'pending'}">
                                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="display:inline;">
                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                    <input type="hidden" name="action" value="approve">
                                                    <button type="submit" class="admin-badge" style="background: #eafaf1; color: #1e8449; border: 1px solid #82e0aa; cursor: pointer;">Verify</button>
                                                </form>
                                            </c:if>
                                            <form action="${pageContext.request.contextPath}/admin/users" method="POST" onsubmit="return confirm('Delete this user permanently?')" style="display:inline;">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="delete">
                                                <button type="submit" class="admin-badge" style="background: #fdedec; color: #cb4335; border: 1px solid #f1948a; cursor: pointer;">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        <strong>No users found matching your criteria.</strong>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>