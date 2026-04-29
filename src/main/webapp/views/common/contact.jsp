<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact — BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
<div class="auth-container auth-container--wide">
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
        <p>Get in Touch</p>
    </div>
    <div class="auth-card">
        <h2>Contact Us</h2>

        <% if ("true".equals(request.getParameter("sent"))) { %>
            <div class="alert alert-success">Your message has been sent. We will get back to you shortly.</div>
        <% } %>

        <p style="color:var(--gray-700);margin-bottom:1.25rem;">
            Have a question or need support? Fill out the form below or reach us directly.
        </p>

        <div style="margin-bottom:1.25rem;color:var(--gray-700);font-size:0.9rem;">
            <p>📧 support@bloodbridge.com</p>
            <p>📞 +977-9814980015</p>
            <p>🕐 Mon–Fri: 9am – 5pm</p>
        </div>

        <form action="${pageContext.request.contextPath}/contact" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Your Name</label>
                    <input type="text" name="name" placeholder="Full name" required />
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="your@email.com" required />
                </div>
            </div>
            <div class="form-group">
                <label>Subject</label>
                <input type="text" name="subject" placeholder="What is this about?" required />
            </div>
            <div class="form-group">
                <label>Message</label>
                <textarea name="message" rows="4" placeholder="Write your message here..."
                          style="resize:vertical;" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Send Message</button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary" style="margin-left:0.5rem;">Back</a>
        </form>
    </div>
</div>
</body>
</html>
