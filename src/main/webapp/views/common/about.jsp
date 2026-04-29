<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About — BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
<div class="auth-container auth-container--wide">
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
        <p>Our Mission</p>
    </div>
    <div class="auth-card">
        <h2>About BloodBridge</h2>
        <p style="margin-bottom:1rem;color:var(--gray-700);line-height:1.8;">
            BloodBridge is a web-based ethical blood donation management platform designed to connect
            voluntary blood donors with patients in urgent need. Our platform operates on the principles
            of informed consent, donor anonymity, and data privacy.
        </p>
        <p style="margin-bottom:1rem;color:var(--gray-700);line-height:1.8;">
            We believe every donation is a voluntary act of kindness. No commercial transactions
            of blood are permitted on this platform. All donor and patient data is handled with
            strict confidentiality.
        </p>
        <h3 style="color:var(--red-dark);margin-bottom:0.75rem;">Our Values</h3>
        <ul style="color:var(--gray-700);line-height:2;padding-left:1.5rem;">
            <li>Voluntary and ethical donations only</li>
            <li>Full donor consent and anonymity</li>
            <li>Transparent request and approval process</li>
            <li>No commercial blood transactions</li>
            <li>Secure and private data handling</li>
        </ul>
        <div style="margin-top:1.5rem;display:flex;gap:1rem;">
            <a href="${pageContext.request.contextPath}/login"   class="btn btn-primary">Login</a>
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary">Contact Us</a>
        </div>
    </div>
</div>
</body>
</html>
