<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaigns - Blood Bridge</title>
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
            <h1>Active Campaigns</h1>
            <p>Join a local blood drive and make an impact in your community today.</p>
        </div>
    </header>

    <!-- Campaigns List -->
    <section class="campaigns-section">
        <div class="campaign-grid">
            <!-- Campaign Card 1 -->
            <div class="campaign-card">
                <div class="campaign-date">
                    <span class="day">15</span>
                    <span class="month">MAY</span>
                </div>
                <div class="campaign-info">
                    <h3>City Center Blood Drive</h3>
                    <p class="location">📍 Central Plaza, Downtown</p>
                    <p class="time">⏰ 9:00 AM - 4:00 PM</p>
                    <p class="desc">Annual summer blood drive hosted by the Rotary Club. All blood types urgently needed.</p>
                </div>
                <div class="campaign-action">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                </div>
            </div>

            <!-- Campaign Card 2 -->
            <div class="campaign-card">
                <div class="campaign-date">
                    <span class="day">22</span>
                    <span class="month">MAY</span>
                </div>
                <div class="campaign-info">
                    <h3>University Donor Week</h3>
                    <p class="location">📍 Student Union Building</p>
                    <p class="time">⏰ 10:00 AM - 5:00 PM</p>
                    <p class="desc">Calling all students! Help us reach our goal of 500 pints donated this week.</p>
                </div>
                <div class="campaign-action">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                </div>
            </div>
            
            <!-- Campaign Card 3 -->
            <div class="campaign-card">
                <div class="campaign-date">
                    <span class="day">02</span>
                    <span class="month">JUN</span>
                </div>
                <div class="campaign-info">
                    <h3>Corporate LifeSavers</h3>
                    <p class="location">📍 Tech Park North, Building C</p>
                    <p class="time">⏰ 8:00 AM - 2:00 PM</p>
                    <p class="desc">Open to the public. Sponsored by leading tech firms in the valley.</p>
                </div>
                <div class="campaign-action">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
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
