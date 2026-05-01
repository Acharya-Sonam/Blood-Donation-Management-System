<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Blood Bridge</title>
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
            <h1>Contact Us</h1>
            <p>We'd love to hear from you. Reach out with any questions or feedback.</p>
        </div>
    </header>

    <div class="auth-wrapper" style="min-height: auto; padding: 4rem 2rem;">
        <div class="auth-card glass-card" style="max-width: 600px; width: 100%;">
            <div class="auth-header">
                <h2>Send a Message</h2>
                <p>Fill out the form below and our team will get back to you shortly.</p>
            </div>
            
            <form action="#" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="name">Your Name</label>
                    <input type="text" id="name" name="name" placeholder="Enter your name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" rows="5" placeholder="Write your message here..." style="width: 100%; padding: 0.8rem 1rem; border: 2px solid var(--clr-border); border-radius: var(--radius-md); font-family: var(--font-main); font-size: 1rem; background: rgba(255, 255, 255, 0.8); resize: vertical; transition: all 0.3s ease;" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-full">Send Message</button>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <p>&copy; 2026 Blood Bridge Blood Donation System. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>
