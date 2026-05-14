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
    <title>Wishlist - Blood Bridge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <jsp:include page="donor-sidebar.jsp" />

    <main class="main-content">
        <header class="topbar">
            <h1>My Wishlist</h1>
            <div class="topbar-right">
                <div class="user-info">
                    <strong><%= donorName != null ? donorName : "Donor" %></strong>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="card" style="padding: 2rem; text-align: center;">
                <h2>Your Wishlist is Empty</h2>
                <p>You haven't added any campaigns or donors to your wishlist yet.</p>
                <a href="<%= request.getContextPath() %>/donor/dashboard" class="btn btn-primary" style="margin-top: 1rem;">Go to Dashboard</a>
            </div>
        </div>
    </main>
</body>
</html>
