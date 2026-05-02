<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Blood Bridge</title>
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
                <h2>Join Blood Bridge</h2>
                <p>Register as a donor or to request blood.</p>
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form">
                
                <div class="form-group">
                    <label for="role">Registration Type</label>
                    <select id="role" name="role" required class="form-select">
                        <option value="">Select Role</option>
                        <option value="donor" <%= "donor".equals(request.getAttribute("role")) ? "selected" : "" %>>I want to Donate Blood (Donor)</option>
                        <option value="patient" <%= "patient".equals(request.getAttribute("role")) ? "selected" : "" %>>I need Blood (Patient)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" required value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Min 6 characters" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" required>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" placeholder="10 digits" required value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" required value="<%= request.getAttribute("dateOfBirth") != null ? request.getAttribute("dateOfBirth") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="bloodGroup">Blood Group</label>
                    <select id="bloodGroup" name="bloodGroup" required class="form-select">
                        <option value="">Select Blood Group</option>
                        <option value="A+" <%= "A+".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>A+</option>
                        <option value="A-" <%= "A-".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>A-</option>
                        <option value="B+" <%= "B+".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>B+</option>
                        <option value="B-" <%= "B-".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>B-</option>
                        <option value="O+" <%= "O+".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>O+</option>
                        <option value="O-" <%= "O-".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>O-</option>
                        <option value="AB+" <%= "AB+".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>AB+</option>
                        <option value="AB-" <%= "AB-".equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>AB-</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" placeholder="Current city/area" required value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                </div>

                <div id="patientFields" style="display: none;">
                    <div class="form-group">
                        <label for="hospitalName">Hospital Name</label>
                        <input type="text" id="hospitalName" name="hospitalName" placeholder="Enter hospital name" value="<%= request.getAttribute("hospitalName") != null ? request.getAttribute("hospitalName") : "" %>">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-full">Create Account</button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
            </div>
        </div>
    </div>

    <script>
        const roleSelect = document.getElementById('role');
        const patientFields = document.getElementById('patientFields');
        const hospitalInput = document.getElementById('hospitalName');

        roleSelect.addEventListener('change', function() {
            if (this.value === 'patient') {
                patientFields.style.display = 'block';
                hospitalInput.setAttribute('required', 'required');
            } else {
                patientFields.style.display = 'none';
                hospitalInput.removeAttribute('required');
            }
        });

        // Trigger on load if there's an error (to preserve selection)
        if (roleSelect.value === 'patient') {
            patientFields.style.display = 'block';
            hospitalInput.setAttribute('required', 'required');
        }
    </script>

    <style>
        .form-select {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--clr-border);
            border-radius: var(--radius-md);
            font-family: var(--font-main);
            font-size: 1rem;
            background-color: white;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        @media (max-width: 480px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

</body>
</html>
