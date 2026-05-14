<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oops! Something went wrong - Blood Bridge</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-wrapper">
        <div class="auth-card glass-card" style="text-align: center; max-width: 600px;">
            <div style="font-size: 5rem; margin-bottom: 1.5rem;">⚠️</div>
            <h2 style="color: var(--clr-secondary); font-weight: 800; margin-bottom: 1rem;">
                System Interruption
            </h2>
            <p style="color: var(--clr-text-muted); line-height: 1.6; margin-bottom: 2rem;">
                We encountered an unexpected error while processing your request. This might be due to a database connection issue or a missing configuration.
            </p>

            <% if (exception != null) { %>
                <div style="background: rgba(230, 57, 70, 0.05); padding: 1rem; border-radius: 8px; border: 1px solid rgba(230, 57, 70, 0.2); text-align: left; margin-bottom: 2rem;">
                    <strong style="color: var(--clr-primary); font-size: 0.9rem;">Technical Details:</strong>
                    <pre style="font-size: 0.8rem; overflow-x: auto; color: #444; margin-top: 0.5rem; font-family: 'Courier New', Courier, monospace;">
<% 
    java.io.StringWriter sw = new java.io.StringWriter();
    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
    exception.printStackTrace(pw);
    out.print(sw.toString());
%>
                    </pre>
                </div>
            <% } %>

            <div style="display: flex; gap: 1rem; justify-content: center;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Home</a>
                <button onclick="window.history.back()" class="btn btn-secondary">Go Back</button>
            </div>
        </div>
    </div>
</body>
</html>
