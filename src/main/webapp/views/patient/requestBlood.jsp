<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String donorName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Blood | Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-card {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: var(--radius);
            padding: 40px;
            box-shadow: var(--shadow);
        }
        .form-header { margin-bottom: 30px; border-bottom: 1px solid var(--border); padding-bottom: 20px; }
        .form-header h2 { color: var(--red-primary); font-weight: 800; font-size: 1.5rem; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .full-width { grid-column: span 2; }
        
        .input-group { margin-bottom: 20px; }
        .input-group label { display: block; font-size: 0.8rem; font-weight: 600; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; }
        .input-group input, .input-group select, .input-group textarea {
            width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.95rem;
        }
        .btn-submit {
            background: var(--red-primary); color: white; border: none; padding: 15px; border-radius: 8px; font-weight: 700; cursor: pointer; width: 100%; transition: 0.2s; font-size: 1rem;
        }
        .btn-submit:hover { background: var(--red-dark); transform: translateY(-2px); }
        
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; font-weight: 500; }
        .alert-error { background: #fdedec; color: #cb4335; border: 1px solid #f5b7b1; }
    </style>
</head>
<body>

    <jsp:include page="patient-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>💉 Request Blood</h1>
            <div class="topbar-right">
                <span class="admin-badge">Patient</span>
                <div class="user-info">
                    <strong><%= donorName != null ? donorName : "User" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="form-card">
                <div class="form-header">
                    <h2>Post a New Request</h2>
                    <p style="color: var(--text-muted); font-size: 0.85rem;">Please provide accurate details to help donors find you quickly.</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/PatientController" method="post">
                    <input type="hidden" name="action" value="submitRequest">
                    
                    <div class="form-grid">
                        <div class="input-group">
                            <label>Blood Group Needed</label>
                            <select name="bloodGroup" required>
                                <option value="" disabled selected>Select Group</option>
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
                        <div class="input-group">
                            <label>Quantity (Units)</label>
                            <input type="number" name="quantity" placeholder="Units needed" min="1" required>
                        </div>
                        <div class="input-group">
                            <label>Urgency Level</label>
                            <select name="urgency" required>
                                <option value="Normal">Normal (Within 2-3 days)</option>
                                <option value="Urgent">Urgent (Within 24 hours)</option>
                                <option value="Critical">Critical (Immediate)</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label>Contact Phone</label>
                            <input type="tel" name="phone" placeholder="Emergency contact number" required>
                        </div>
                        <div class="input-group full-width">
                            <label>Additional Notes</label>
                            <textarea name="notes" rows="3" placeholder="Any specific requirements or hospital details..."></textarea>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Submit Blood Request</button>
                </form>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
    </main>

</body>
</html>
