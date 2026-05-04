<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard - Blood Bridge</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        </head>

        <body>
            <div class="dashboard-container">
                <!-- Sidebar -->
                <jsp:include page="admin-sidebar.jsp" />

                <!-- Main Content -->
                <main class="main-content">
                    <header class="page-header">
                        <h1>Dashboard Summary</h1>
                        <p>Monitor system health and key metrics at a glance.</p>
                    </header>

                    <!-- Polished "Normal" Stats -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div
                                style="font-size: 0.8rem; font-weight: 700; color: var(--clr-text-muted); text-transform: uppercase; margin-bottom: 0.5rem;">
                                Total Members</div>
                            <div class="value">${totalDonors}</div>
                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--clr-border);">
                                <a href="${pageContext.request.contextPath}/admin/manageusers?filter=all"
                                    style="font-size: 0.8rem; font-weight: 600; color: var(--clr-primary);">Manage All
                                    →</a>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div
                                style="font-size: 0.8rem; font-weight: 700; color: var(--clr-text-muted); text-transform: uppercase; margin-bottom: 0.5rem;">
                                Pending Members</div>
                            <div class="value" style="color: #ffc107;">${pendingApprovals}</div>
                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--clr-border);">
                                <a href="${pageContext.request.contextPath}/admin/manageusers?filter=pending"
                                    style="font-size: 0.8rem; font-weight: 600; color: #ffc107;">Review Now →</a>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div
                                style="font-size: 0.8rem; font-weight: 700; color: var(--clr-text-muted); text-transform: uppercase; margin-bottom: 0.5rem;">
                                Blood Requests</div>
                            <div class="value" style="color: var(--clr-secondary);">${totalRequests}</div>
                            <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--clr-border);">
                                <a href="${pageContext.request.contextPath}/admin/requests"
                                    style="font-size: 0.8rem; font-weight: 600; color: var(--clr-secondary);">View Feed
                                    →</a>
                            </div>
                        </div>
                    </div>

                    <!-- "Interesting" Normal Content: Recent Activity Feed -->
                    <div style="margin-top: 3rem; display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">

                        <div class="table-container" style="padding: 2rem;">
                            <h3 style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                                <span>📅</span> Recent System Activity
                            </h3>
                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                <div
                                    style="display: flex; gap: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--clr-border);">
                                    <div style="background: #f0fdf4; padding: 0.5rem; border-radius: 8px;">👤</div>
                                    <div>
                                        <div style="font-weight: 600;">New Donor Registration</div>
                                        <div style="font-size: 0.8rem; color: var(--clr-text-muted);">A new member just
                                            registered and is awaiting approval.</div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; gap: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--clr-border);">
                                    <div style="background: #fef2f2; padding: 0.5rem; border-radius: 8px;">🩸</div>
                                    <div>
                                        <div style="font-weight: 600;">Urgent Request Created</div>
                                        <div style="font-size: 0.8rem; color: var(--clr-text-muted);">O- Negative blood
                                            request posted by City Hospital.</div>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 1rem; padding-bottom: 1rem;">
                                    <div style="background: #eff6ff; padding: 0.5rem; border-radius: 8px;">📦</div>
                                    <div>
                                        <div style="font-weight: 600;">Stock Level Update</div>
                                        <div style="font-size: 0.8rem; color: var(--clr-text-muted);">Inventory for A+
                                            was updated by Admin.</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="table-container"
                            style="padding: 2rem; background: var(--clr-secondary); color: white;">
                            <h3 style="margin-bottom: 1rem; color: white;">Quick Shortcuts</h3>
                            <p style="font-size: 0.85rem; color: rgba(255,255,255,0.7); margin-bottom: 1.5rem;">Access
                                frequently used tools.</p>
                            <div style="display: flex; flex-direction: column; gap: 0.8rem;">
                                <a href="${pageContext.request.contextPath}/admin/inventory" class="btn-action"
                                    style="background: rgba(255,255,255,0.1); border: none; color: white; justify-content: flex-start;">📦
                                    Blood Inventory</a>
                                <a href="${pageContext.request.contextPath}/admin/manageusers" class="btn-action"
                                    style="background: rgba(255,255,255,0.1); border: none; color: white; justify-content: flex-start;">👥
                                    User Management</a>
                                <a href="${pageContext.request.contextPath}/admin/requests" class="btn-action"
                                    style="background: rgba(255,255,255,0.1); border: none; color: white; justify-content: flex-start;">🩸
                                    Active Requests</a>
                            </div>
                        </div>

                    </div>
                </main>
            </div>
        </body>

        </html>