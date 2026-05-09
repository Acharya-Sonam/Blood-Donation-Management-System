<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo">
            <span class="blood-drop">🩸</span> Blood Bridge
        </a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/views/common/campaigns.jsp">Campaigns</a></li>
            <li><a href="${pageContext.request.contextPath}/views/common/about.jsp">About Us</a></li>
            <li><a href="${pageContext.request.contextPath}/views/common/contact.jsp">Contact Us</a></li>
            <li><a href="${pageContext.request.contextPath}/login" class="nav-btn btn-outline">Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register" class="nav-btn btn-primary">Register</a></li>
        </ul>
    </div>
</nav>
