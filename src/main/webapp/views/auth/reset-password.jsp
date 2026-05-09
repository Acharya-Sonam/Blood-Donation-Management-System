<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Blood Bridge</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

    <!-- Navigation -->
    <jsp:include page="navbar.jsp" />

    <!-- Auth Container -->
    <div class="auth-wrapper">
        <div class="auth-card glass-card">
            <div class="auth-header">
                <h2>Set New Password</h2>
                <p>Choose a strong password to secure your account.</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/reset-password" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter new password" required minlength="8">
                </div>

                <div class="form-group">
                    <label for="confirm_password">Confirm New Password</label>
                    <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm new password" required minlength="8">
                </div>
                
                <button type="submit" class="btn btn-primary btn-full">Reset Password</button>
            </form>
        </div>
    </div>

</body>
</html>
