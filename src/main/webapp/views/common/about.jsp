<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Blood Bridge</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="ambient-page">

    <!-- Navigation -->
    <jsp:include page="navbar.jsp" />

    <!-- Page Header -->
    <header class="page-header">
        <div class="page-header-content">
            <h1>About Blood Bridge</h1>
            <p>Connecting heroes to those in need, one drop at a time.</p>
        </div>
    </header>

    <!-- About Content -->
    <section class="about-section">
        <div class="about-container">
            <div class="about-card">
                <div class="about-text">
                <h2>Our Mission</h2>
                <p>Blood Bridge was founded with a simple yet powerful mission: to eliminate the critical shortage of blood in medical emergencies. We leverage modern technology to connect voluntary blood donors directly with hospitals, clinics, and patients in urgent need.</p>
                <p>Every single day, thousands of lives are lost because the right blood type isn't available at the right time. Our platform aims to bridge that gap by providing real-time alerts, location-based matching, and a seamless donation experience.</p>
                
                <h2 style="margin-top: 2rem;">How It Works</h2>
                <ul class="timeline">
                    <li><strong>Register:</strong> Sign up as a donor and input your blood type and location.</li>
                    <li><strong>Get Notified:</strong> Receive instant alerts when your blood is needed nearby.</li>
                    <li><strong>Donate:</strong> Visit the assigned clinic or campaign drive to donate.</li>
                    <li><strong>Save Lives:</strong> Your single donation can save up to 3 lives.</li>
                </ul>
            </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <p>&copy; 2026 Blood Bridge Blood Donation System. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>
