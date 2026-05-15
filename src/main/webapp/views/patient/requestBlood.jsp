<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Blood - BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e74c3c;
            --secondary: #c0392b;
            --dark: #2c3e50;
            --light: #ecf0f1;
            --glass: rgba(255, 255, 255, 0.9);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background: var(--glass);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }

        h2 {
            color: var(--primary);
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: var(--dark);
            font-weight: 600;
        }

        select, input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }

        select:focus, input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 8px rgba(231, 76, 60, 0.2);
        }

        .btn-submit {
            background: var(--primary);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 10px;
            width: 100%;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/navbar.jsp" />

    <div class="container fade-in">
        <h2><i class="fas fa-heartbeat"></i> Request Blood</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("error")) { %>
            <div class="alert alert-error">
                Something went wrong. Please try again.
            </div>
        <% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("duplicate")) { %>
            <div class="alert alert-error">
                You already have a pending request for this blood group.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/PatientController" method="POST">
            <input type="hidden" name="action" value="submitRequest">

            <div class="form-group">
                <label>Blood Group Needed</label>
                <select name="bloodGroup" required>
                    <option value="">Select Blood Group</option>
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                </select>
            </div>

            <div class="form-group">
                <label>Quantity (in Units)</label>
                <input type="number" name="quantity" min="1" max="10" placeholder="Enter quantity" required>
            </div>

            <div class="form-group">
                <label>Urgency Level</label>
                <select name="urgency" required>
                    <option value="Normal">Normal</option>
                    <option value="Urgent">Urgent</option>
                    <option value="Critical">Critical</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">Submit Request</button>
        </form>
    </div>

    <script>
        // Simple animation
        document.querySelector('.container').style.opacity = 0;
        document.querySelector('.container').style.transform = 'translateY(20px)';
        window.onload = () => {
            document.querySelector('.container').style.transition = 'all 0.8s ease-out';
            document.querySelector('.container').style.opacity = 1;
            document.querySelector('.container').style.transform = 'translateY(0)';
        };
    </script>
</body>
</html>
