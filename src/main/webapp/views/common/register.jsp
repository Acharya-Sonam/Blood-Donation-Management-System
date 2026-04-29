<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BloodBridge – Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">

<div class="auth-container auth-container--wide">

    <!-- Brand -->
    <div class="auth-brand">
        <span class="brand-icon">🩸</span>
        <h1>BloodBridge</h1>
        <p>Create your account</p>
    </div>

    <!-- Error message from controller -->
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <div class="auth-card">
        <h2>Register</h2>

        <form action="${pageContext.request.contextPath}/register" method="post">

            //Role Selection 
            <div class="form-group">
                <label>Register as</label>
                <div class="role-toggle">
                    <label class="role-option">
                        <input type="radio" name="role" value="donor"
                            <%= "donor".equals(request.getAttribute("role")) ? "checked" : "" %> required />
                        <span>🩸 Blood Donor</span>
                    </label>
                    <label class="role-option">
                        <input type="radio" name="role" value="patient"
                            <%= "patient".equals(request.getAttribute("role")) ? "checked" : "" %> />
                        <span>🏥 Patient</span>
                    </label>
                </div>
            </div>

            //Full Name
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName"
                       placeholder="Enter your full name (letters only)"
                       value="${requestScope.fullName}" required />
                <small class="field-hint">Letters and spaces only. No numbers allowed.</small>
            </div>

            //Email
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       placeholder="Enter your email address"
                       value="${requestScope.email}" required />
            </div>

            //Password
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Min. 6 characters" required />
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Re-enter password" required />
                </div>
            </div>

            //Phone 
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone"
                       placeholder="10-digit phone number"
                       value="${requestScope.phone}" required />
                <small class="field-hint">Must be exactly 10 digits.</small>
            </div>

            //Date of Birth
            <div class="form-row">
                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" required />
                </div>

                //Blood Group
                <div class="form-group">
                    <label for="bloodGroup">Blood Group</label>
                    <select id="bloodGroup" name="bloodGroup" required>
                        <option value="">-- Select --</option>
                        <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                           for (String bg : groups) { %>
                            <option value="<%= bg %>"
                                <%= bg.equals(request.getAttribute("bloodGroup")) ? "selected" : "" %>>
                                <%= bg %>
                            </option>
                        <% } %>
                    </select>
                </div>
            </div>

            //Address
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address"
                       placeholder="Enter your address"
                       value="${requestScope.address}" />
            </div>

            //Hospital Name (patient only)
            <div class="form-group" id="hospitalGroup" style="display:none;">
                <label for="hospitalName">Hospital Name</label>
                <input type="text" id="hospitalName" name="hospitalName"
                       placeholder="Hospital where you are admitted (optional)" />
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                Create Account
            </button>

        </form>

        <div class="auth-footer">
            <p>Already have an account?
                <a href="${pageContext.request.contextPath}/login">Login here</a>
            </p>
        </div>
    </div>

</div>

<!-- Show hospital field only when "patient" role is selected -->
<script>
    var radios = document.querySelectorAll('input[name="role"]');
    var hospitalGroup = document.getElementById('hospitalGroup');

    function toggleHospital() {
        var selected = document.querySelector('input[name="role"]:checked');
        if (selected && selected.value === 'patient') {
            hospitalGroup.style.display = 'block';
        } else {
            hospitalGroup.style.display = 'none';
        }
    }

    radios.forEach(function(r) { r.addEventListener('change', toggleHospital); });
    toggleHospital(); // run on page load
</script>

</body>
</html>
