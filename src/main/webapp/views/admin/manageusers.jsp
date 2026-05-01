<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.blooddonationmanagementsystem.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<div class="dashboard-container">

    <!-- ── SIDEBAR ─────────────────────────────────────────── -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <h2>🩸 Blood Bridge</h2>
            <p>Admin Panel</p>
        </div>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/manageusers" class="active">👥 Manage Users</a></li>
                <li><a href="${pageContext.request.contextPath}/auth/logout">🚪 Logout</a></li>
            </ul>
        </nav>
    </aside>

    <!-- ── MAIN CONTENT ────────────────────────────────────── -->
    <main class="main-content">

        <div class="page-header">
            <h1>Manage Users</h1>
            <p>Approve, reject, or delete user accounts</p>
        </div>

        <!-- ── SUCCESS MESSAGE ─────────────────────────────── -->
        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <c:choose>
                    <c:when test="${param.success == 'approved'}">✅ User approved successfully!</c:when>
                    <c:when test="${param.success == 'rejected'}">❌ User rejected successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">🗑️ User deleted successfully!</c:when>
                    <c:when test="${param.success == 'roleupdated'}">🔄 User role updated successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <!-- ── FILTER TABS ──────────────────────────────────── -->
        <div class="filter-tabs">
            <a href="?filter=all"
               class="tab ${filter == 'all' ? 'active' : ''}">All Users</a>
            <a href="?filter=pending"
               class="tab ${filter == 'pending' ? 'active' : ''}">⏳ Pending</a>
            <a href="?filter=approved"
               class="tab ${filter == 'approved' ? 'active' : ''}">✅ Approved</a>
            <a href="?filter=rejected"
               class="tab ${filter == 'rejected' ? 'active' : ''}">❌ Rejected</a>
        </div>

        <!-- ── USERS TABLE ──────────────────────────────────── -->
        <div class="table-container">
            <table class="users-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Registered</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty users}">
                        <tr>
                            <td colspan="6" class="no-data">No users found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="user" items="${users}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="badge badge-role">${user.role}</span>
                                </td>
                                <td>
                                        <span class="badge
                                            ${user.status == 'approved' ? 'badge-approved' :
                                              user.status == 'pending'  ? 'badge-pending'  :
                                                                          'badge-rejected'}">
                                                ${user.status}
                                        </span>
                                </td>
                                <td>${user.createdAt}</td>
                                <td class="actions">

                                    <!-- Approve Button -->
                                    <c:if test="${user.status == 'pending'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/approve" style="display:inline">
                                            <input type="hidden" name="userId" value="${user.userId}"/>
                                            <button type="submit" class="btn btn-approve">✅ Approve</button>
                                        </form>

                                        <!-- Reject Button -->
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reject" style="display:inline">
                                            <input type="hidden" name="userId" value="${user.userId}"/>
                                            <button type="submit" class="btn btn-reject">❌ Reject</button>
                                        </form>
                                    </c:if>

                                    <!-- Update Role -->
                                    <form method="post" action="${pageContext.request.contextPath}/admin/updaterole" style="display:inline">
                                        <input type="hidden" name="userId" value="${user.userId}"/>
                                        <select name="role" class="role-select">
                                            <option value="donor"   ${user.role == 'donor'   ? 'selected' : ''}>Donor</option>
                                            <option value="patient" ${user.role == 'patient' ? 'selected' : ''}>Patient</option>
                                            <option value="admin"   ${user.role == 'admin'   ? 'selected' : ''}>Admin</option>
                                        </select>
                                        <button type="submit" class="btn btn-role">🔄 Update</button>
                                    </form>

                                    <!-- Delete Button -->
                                    <form method="post" action="${pageContext.request.contextPath}/admin/delete" style="display:inline"
                                          onsubmit="return confirm('Are you sure you want to delete this user?')">
                                        <input type="hidden" name="userId" value="${user.userId}"/>
                                        <button type="submit" class="btn btn-delete">🗑️ Delete</button>
                                    </form>

                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

    </main>
</div>

</body>
</html>