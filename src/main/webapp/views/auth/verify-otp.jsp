<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - Blood Bridge</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

    <!-- Navigation -->
    <jsp:include page="../common/navbar.jsp" />

    <!-- Auth Container -->
    <div class="auth-wrapper">
        <div class="auth-card glass-card">
            <div class="auth-header">
                <h2>Verify OTP</h2>
                <p>We've sent a 6-digit code to your email.</p>
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
            
            <form action="${pageContext.request.contextPath}/verify-otp" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="otp">Enter 6-Digit OTP</label>
                    <input type="text" id="otp" name="otp" placeholder="123456" maxlength="6" pattern="\d{6}" required>
                </div>
                
                <button type="submit" class="btn btn-primary btn-full">Verify Code</button>
            </form>

            <div class="auth-footer">
                <p>Didn't receive the code? <a href="${pageContext.request.contextPath}/forgot-password">Resend OTP</a></p>
            </div>
        </div>
    </div>

</body>
</html>
