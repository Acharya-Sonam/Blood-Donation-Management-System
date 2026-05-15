<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
    <div class="sidebar-brand">
        <h2>🩸 Blood Bridge</h2>
        <p>Donor Dashboard</p>
    </div>
    <nav>
        <ul>
            <li>
                <a href="${pageContext.request.contextPath}/donor/dashboard" class="${pageContext.request.requestURI.contains('dashboard.jsp') || pageContext.request.requestURI.endsWith('/dashboard') ? 'active' : ''}">
                    📊 Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor/dashboard?action=searchDonors" class="${pageContext.request.requestURI.contains('searchdonors.jsp') ? 'active' : ''}">
                    🔍 Search Donors
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor/dashboard?action=viewRequests" class="${pageContext.request.requestURI.contains('viewrequests.jsp') ? 'active' : ''}">
                    🩸 Blood Requests
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/donor/donationHistory" class="${pageContext.request.requestURI.contains('donationHistory') ? 'active' : ''}">
                    📜 Donation History
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/views/donor/profile.jsp" class="${pageContext.request.requestURI.contains('profile.jsp') ? 'active' : ''}">
                    👤 My Profile
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/views/donor/wishlist.jsp" class="${pageContext.request.requestURI.contains('wishlist.jsp') ? 'active' : ''}">
                    ❤️ Wishlist
                </a>
            </li>
            <li class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Logout</a>
            </li>
        </ul>
    </nav>
</aside>
