<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports | Blood Bridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="admin-sidebar.jsp" />

    <main class="main-content">
        <!-- Top bar -->
        <header class="topbar">
            <h1>📈 System Reports</h1>
            <div class="topbar-right">
                <button onclick="window.print()" class="admin-badge" style="cursor: pointer; border: none;">🖨️ Print Report</button>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="page-body">
            <div class="summary-row">
                <div class="summary-card">
                    <div class="s-num">${totalDonors}</div>
                    <div class="s-label">Registered Donors</div>
                </div>
                <div class="summary-card">
                    <div class="s-num">${totalPatients}</div>
                    <div class="s-label">Registered Patients</div>
                </div>
                <div class="summary-card">
                    <div class="s-num">${totalRequests}</div>
                    <div class="s-label">Pending Requests</div>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
