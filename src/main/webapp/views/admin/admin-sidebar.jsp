<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
    <div class="sidebar-brand">
        <h2>🩸 Blood Bridge</h2>
        <p>Admin Dashboard</p>
    </div>
    <nav>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                    📊 Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/users" class="${pageContext.request.requestURI.contains('manageusers') ? 'active' : ''}">
                    👥 Manage Users
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/requests" class="${pageContext.request.requestURI.contains('manageRequests') ? 'active' : ''}">
                    🩸 Blood Requests
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/inventory" class="${pageContext.request.requestURI.contains('inventory') ? 'active' : ''}">
                    📦 Inventory
                </a>
            </li>
            <li class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Logout</a>
            </li>
        </ul>
    </nav>
</aside>
