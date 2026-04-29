<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BloodBridge — Save Lives</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
<div class="auth-container">
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
        <p>Connecting donors with lives in need</p>
    </div>
    <div class="auth-card" style="text-align:center;">
        <h2>Welcome</h2>
        <p style="color:var(--gray-700);margin-bottom:1.5rem;">
            BloodBridge is an ethical blood donation platform connecting voluntary donors
            with patients in need. Every donation saves a life.
        </p>
        <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/login"    class="btn btn-primary">Login</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Register</a>
        </div>
        <div style="margin-top:1.25rem;display:flex;gap:1rem;justify-content:center;">
            <a href="${pageContext.request.contextPath}/about"   style="font-size:0.875rem;">About Us</a>
            <a href="${pageContext.request.contextPath}/contact" style="font-size:0.875rem;">Contact</a>
        </div>
    </div>
</div>
</body>
</html>
