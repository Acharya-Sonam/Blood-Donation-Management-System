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
            
            <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="role">Register As</label>
                    <select id="role" name="role" required style="width: 100%; padding: 0.8rem 1rem; border: 2px solid var(--clr-border); border-radius: var(--radius-md); font-family: var(--font-main); font-size: 1rem;">
                        <option value="">Select Role</option>
                        <option value="donor">Donor</option>
                        <option value="patient">Patient</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div>
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Create password" required>
                    </div>
                    <div>
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                    </div>
                </div>

                <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div>
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" placeholder="Phone number" required>
                    </div>
                    <div>
                        <label for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="bloodGroup">Blood Group</label>
                    <select id="bloodGroup" name="bloodGroup" required style="width: 100%; padding: 0.8rem 1rem; border: 2px solid var(--clr-border); border-radius: var(--radius-md); font-family: var(--font-main); font-size: 1rem;">
                        <option value="">Select Blood Group</option>
                        <option value="A+">A+</option>
                        <option value="A-">A-</option>
                        <option value="B+">B+</option>
                        <option value="B-">B-</option>
                        <option value="O+">O+</option>
                        <option value="O-">O-</option>
                        <option value="AB+">AB+</option>
                        <option value="AB-">AB-</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" placeholder="Enter your address" required>
                </div>

                <div id="hospitalField" class="form-group" style="display: none;">
                    <label for="hospitalName">Hospital Name (for Patients)</label>
                    <input type="text" id="hospitalName" name="hospitalName" placeholder="Enter hospital name">
                </div>

                <button type="submit" class="btn btn-primary btn-full">Create Account</button>
            </form>

            <script>
                document.getElementById('role').addEventListener('change', function() {
                    const hospitalField = document.getElementById('hospitalField');
                    if (this.value === 'patient') {
                        hospitalField.style.display = 'block';
                        document.getElementById('hospitalName').required = true;
                    } else {
                        hospitalField.style.display = 'none';
                        document.getElementById('hospitalName').required = false;
                    }
                });
            </script>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
            </div>
        </div>
    </div>

</body>
</html>
