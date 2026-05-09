<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Bridge - Blood Donation Management System</title>
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Navigation -->
    <jsp:include page="views/common/navbar.jsp" />

    <!-- Hero Section -->
    <header class="hero">
        <div class="hero-content">
            <div class="badge">Every Drop Counts</div>
            <h1 class="hero-title">Give the Gift of <span>Life</span> Today.</h1>
            <p class="hero-subtitle">
                Join thousands of heroes saving lives every day. Whether you need blood or want to donate, Blood Bridge connects you with those who matter most.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-large">Become a Donor</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-large">Request Blood</a>
            </div>
            <div class="hero-stats">
                <div class="stat-item">
                    <h3>10k+</h3>
                    <p>Donors</p>
                </div>
                <div class="stat-item">
                    <h3>25k+</h3>
                    <p>Lives Saved</p>
                </div>
                <div class="stat-item">
                    <h3>50+</h3>
                    <p>Hospitals</p>
                </div>
            </div>
        </div>
        <div class="hero-image">
            <div class="glass-card main-card">
                <div class="card-header">
                    <h4>Urgent Needs</h4>
                    <span class="live-indicator"></span>
                </div>
                <ul class="urgent-list">
                    <li>
                        <a href="${pageContext.request.contextPath}/login" style="display: flex; align-items: center; gap: 1rem; width: 100%; text-decoration: none; color: inherit;">
                            <span class="blood-type o-neg">O-</span>
                            <div class="urgent-details">
                                <strong>City Hospital</strong>
                                <small>Needed urgently for trauma unit</small>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/login" style="display: flex; align-items: center; gap: 1rem; width: 100%; text-decoration: none; color: inherit;">
                            <span class="blood-type a-pos">A+</span>
                            <div class="urgent-details">
                                <strong>General Clinic</strong>
                                <small>Surgical requirement</small>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </header>

    <!-- Features Section -->
    <section class="features">
        <div class="section-heading">
            <h2>Why Use Blood Bridge?</h2>
            <p>We've built a platform that is fast, secure, and intuitive for both donors and recipients.</p>
        </div>
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Real-Time Requests</h3>
                <p>Get notified instantly when your blood type is urgently needed nearby.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure Platform</h3>
                <p>Your data is encrypted and handled with the highest level of privacy.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📍</div>
                <h3>Location Based</h3>
                <p>Find blood banks, clinics, and campaigns closest to your current location.</p>
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