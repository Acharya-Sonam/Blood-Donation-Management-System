<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String patientName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            font-family: 'Poppins', sans-serif;
        }
        .profile-header {
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .profile-header h2 {
            color: #2c3e50;
            margin: 0;
        }
        .btn-danger {
            background-color: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body style="background: #f8f9fa;">
    <jsp:include page="../common/navbar.jsp" />

    <div class="container fade-in">
        <div class="profile-header">
            <h2><i class="fas fa-user-circle"></i> My Profile</h2>
        </div>

        <div style="margin-bottom: 40px;">
            <p>Welcome, <strong><%= patientName != null ? patientName : "Patient" %></strong>! Manage your profile settings here.</p>
            <p><strong>Role:</strong> Verified Patient</p>
        </div>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
        
        <div>
            <h3 style="color: #e74c3c; margin-bottom: 15px;"><i class="fas fa-exclamation-triangle"></i> Danger Zone</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 20px;">Once you delete your account, there is no going back. Please be certain.</p>
            <form action="<%= request.getContextPath() %>/profile/delete" method="POST" onsubmit="return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone.');">
                <button type="submit" class="btn-danger">
                    <i class="fas fa-trash-alt"></i> Delete Account
                </button>
            </form>
        </div>
    </div>
</body>
</html>
