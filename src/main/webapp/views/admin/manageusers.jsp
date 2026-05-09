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
    <div class="dashboard-container">
        <jsp:include page="admin-sidebar.jsp" />

        <main class="main-content">
            <!-- Search & Filters -->
            <div style="background: var(--clr-white); padding: 1.5rem; border-radius: 12px; border: 1px solid var(--clr-border); margin-bottom: 2rem; display: flex; flex-direction: column; gap: 1.5rem;">
                
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div style="display: flex; gap: 0.5rem;">
                        <a href="?filter=all" class="btn-action ${param.filter == 'all' || empty param.filter ? 'active' : ''}">All Members</a>
                        <a href="?filter=pending" class="btn-action ${param.filter == 'pending' ? 'active' : ''}">Pending Review</a>
                        <a href="?filter=approved" class="btn-action ${param.filter == 'approved' ? 'active' : ''}">Verified Members</a>
                    </div>
                </div>

                <form action="" method="GET" style="display: flex; gap: 0.5rem;">
                    <input type="hidden" name="filter" value="${param.filter}">
                    <input type="text" name="search" placeholder="Search by name, email, or role..." value="${param.search}" 
                           style="flex: 1; padding: 0.7rem 1.2rem; border-radius: 8px; border: 2px solid var(--clr-border); font-family: var(--font-main); font-size: 1rem; outline: none;">
                    <button type="submit" class="btn-search">Search Now</button>
                </form>
            </div>

            <c:if test="${not empty param.success}">
                <div style="background: #e6fffa; color: #234e52; padding: 1rem; border-radius: 8px; border: 1px solid #b2f5ea; margin-bottom: 2rem; font-weight: 600; display: flex; align-items: center; gap: 0.5rem;">
                    <span>✅</span> Action processed successfully.
                </div>
            </c:if>

            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Member</th>
                            <th>Contact Info</th>
                            <th>Role & Status</th>
                            <th>Registration</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td><span style="color: var(--clr-text-muted); font-family: monospace;">#${u.userId}</span></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 0.8rem;">
                                        <div style="width: 35px; height: 35px; background: #f1f5f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; color: var(--clr-secondary);">
                                            ${u.name.substring(0,1)}
                                        </div>
                                        <div>
                                            <div style="font-weight: 700; color: var(--clr-secondary);">${u.name}</div>
                                            <div style="font-size: 0.8rem; color: var(--clr-text-muted);">${u.email}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; font-weight: 600;">Role: ${u.role}</div>
                                </td>
                                <td>
                                    <div style="display: flex; flex-direction: column; gap: 0.3rem;">
                                        <span class="badge badge-${u.status}">${u.status}</span>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.85rem; color: var(--clr-text-muted);">${u.createdAt}</div>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 0.4rem; justify-content: flex-end;">
                                        <c:if test="${u.status == 'pending'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="approve">
                                                <button type="submit" class="btn-action" style="color: #28a745; border-color: #28a745;">Verify</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="reject">
                                                <button type="submit" class="btn-action" style="color: #e63946; border-color: #e63946;">Reject</button>
                                            </form>
                                        </c:if>
                                        <div style="position: relative;">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="POST" onsubmit="return confirm('Delete this user permanently?')">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="delete">
                                                <button type="submit" class="btn-action">Delete</button>
                                            </form>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 4rem; color: var(--clr-text-muted);">
                                    <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                                    <strong>No users found matching your criteria.</strong>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>