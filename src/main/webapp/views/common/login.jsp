<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BloodBridge – Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">

<div class="auth-container">

    <!-- Logo / Brand -->
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
        <p>Connecting donors with lives in need</p>
    </div>

    <!-- Success message after registration -->
    <% if ("true".equals(request.getParameter("registered"))) { %>
        <div class="alert alert-success">
            Registration successful! Your account is pending admin approval.
        </div>
    <% } %>

    <!-- Success message after logout -->
    <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="alert alert-info">
            You have been logged out successfully.
        </div>
    <% } %>

    <!-- Error message from controller -->
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <!-- Login Form -->
    <div class="auth-card">
        <h2>Sign In</h2>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       placeholder="Enter your email"
                       value="${param.email}" required />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password" required />
            </div>

            <button type="submit" class="btn btn-primary btn-full">Login</button>

        </form>

        <div class="auth-footer">
            <p>Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Register here</a>
            </p>
        </div>
    </div>

</div>

</body>
</html>
