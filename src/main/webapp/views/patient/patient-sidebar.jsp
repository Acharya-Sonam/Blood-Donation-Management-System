<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
    <div class="sidebar-brand">
        <h2>🩸 Blood Bridge</h2>
        <p>Patient Dashboard</p>
    </div>
    <nav>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                    📊 Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/PatientController?action=searchDonors" class="${pageContext.request.requestURI.contains('searchdonors') ? 'active' : ''}">
                    🔍 Search Donors
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/PatientController?action=requestForm" class="${pageContext.request.requestURI.contains('requestBlood') ? 'active' : ''}">
                    💉 Request Blood
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/PatientController?action=myRequests" class="${pageContext.request.requestURI.contains('trackRequest') ? 'active' : ''}">
                    📜 My Requests
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/views/patient/profile.jsp" class="${pageContext.request.requestURI.contains('profile') ? 'active' : ''}">
                    👤 My Profile
                </a>
            </li>
            <li class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Logout</a>
            </li>
        </ul>
    </nav>
</aside>
