<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BloodBridge – Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">

<div class="auth-container">
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
    </div>

    <div class="auth-card" style="text-align:center;">
        <div style="font-size: 3rem; margin-bottom: 1rem;">⚠️</div>
        <h2>Something went wrong</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error-detail"><%= request.getAttribute("errorMessage") %></p>
        <% } else if (exception != null) { %>
            <p class="error-detail"><%= exception.getMessage() %></p>
        <% } else { %>
            <p class="error-detail">An unexpected error occurred. Please try again.</p>
        <% } %>

        <div style="margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                Return to Login
            </a>
        </div>
    </div>
</div>

</body>
</html>
