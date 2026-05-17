<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.blooddonationmanagementsystem.model.Donor" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    List<Donor> wishlist = (List<Donor>) session.getAttribute("wishlist");
    String patientName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist – Blood Bridge</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        /* Modernized grid layout */
        .donor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }

        /* Highly distinct white cards with strong hover shadow & border contrast */
        .donor-card {
            background: #ffffff;
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-bottom-color 0.22s ease;
            border-bottom: 4px solid transparent;
            position: relative;
            overflow: hidden;
        }
        .donor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 26px rgba(0,0,0,0.12);
            border-bottom-color: var(--red-primary);
        }

        /* Avatar & Blood Group badges */
        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .avatar-circle {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: var(--red-light);
            color: var(--red-primary);
            font-size: 1.05rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(192,57,43,0.15);
        }
        .blood-badge-large {
            background: var(--red-primary);
            color: white;
            font-size: 1rem;
            font-weight: 800;
            padding: 8px 14px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(192,57,43,0.2);
        }

        .donor-name {
            font-size: 1.12rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 12px;
        }
        .donor-info {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 7px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .donor-info span {
            color: #2c3e50;
            font-weight: 600;
        }

        /* Direct High-Contrast Action Buttons */
        .btn-request-action {
            background: var(--red-primary);
            color: white !important;
            border: none;
            text-align: center;
            font-weight: 600;
            width: 100%;
            font-size: 0.85rem;
            padding: 10px 0;
            border-radius: 8px;
            text-decoration: none;
            display: block;
            box-shadow: 0 4px 10px rgba(192,57,43,0.15);
            transition: background 0.2s, transform 0.1s;
        }
        .btn-request-action:hover {
            background: var(--red-dark);
            transform: translateY(-1px);
        }

        .btn-remove-action {
            background: #fdf2f2;
            color: #c0392b;
            border: 1px solid #f5c6cb;
            width: 100%;
            font-size: 0.85rem;
            padding: 10px 0;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: background 0.2s, color 0.2s, border-color 0.2s;
        }
        .btn-remove-action:hover {
            background: #c0392b;
            color: white;
            border-color: #c0392b;
        }
    </style>
</head>
<body>

<jsp:include page="patient-sidebar.jsp" />

<main class="main-content">
    <header class="topbar">
        <h1>My Preferred Donors</h1>
        <div class="topbar-right">
            <span class="admin-badge" style="background:#e0f7fa; color:#006064;">Patient Panel</span>
            <div class="user-info">
                <strong><%= patientName != null ? patientName : "Patient" %></strong>
            </div>
        </div>
    </header>

    <div class="page-body">
        
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("removed")) { %>
            <div class="alert alert-success" style="background: #eafaf1; border: 1px solid #c3e6cb; color: #1e8449; padding: 15px; border-radius: 8px; margin-bottom: 24px; font-weight: 500;">
                ✓ Donor removed from your wishlist successfully.
            </div>
        <% } %>

        <% if (wishlist == null || wishlist.isEmpty()) { %>
            <div class="card" style="padding: 4rem 2rem; text-align: center; border-radius: 16px; box-shadow: var(--shadow); background: white; border: 1px solid var(--border);">
                <div style="font-size: 4rem; margin-bottom: 1.5rem;">❤️</div>
                <h2 style="font-size: 1.6rem; color: var(--text-dark); margin-bottom: 10px; font-weight: 700;">Your Wishlist is Empty</h2>
                <p style="color: var(--text-muted); margin-bottom: 28px; max-width: 450px; margin-left: auto; margin-right: auto; line-height: 1.5;">
                    Keep track of compatible or exceptionally active donors! Search the donor directory to save them to your preferred list.
                </p>
                <a href="<%= request.getContextPath() %>/PatientController?action=searchDonors" style="background: var(--red-primary); color: white; border: none; font-weight: 600; padding: 12px 28px; border-radius: 8px; text-decoration: none; display: inline-block; box-shadow: 0 4px 12px rgba(192,57,43,0.2);">
                    🔍 Find Preferred Donors
                </a>
            </div>
        <% } else { %>
            <div class="donor-grid">
                <% for (Donor d : wishlist) {
                    java.lang.String fullName = d.getFullName() != null ? d.getFullName() : "?";
                    java.lang.String[] nameParts = fullName.trim().split("\\s+");
                    java.lang.String initials = nameParts.length >= 2
                            ? "" + nameParts[0].charAt(0) + nameParts[nameParts.length - 1].charAt(0)
                            : fullName.substring(0, Math.min(2, fullName.length()));
                    initials = initials.toUpperCase();
                %>
                <div class="donor-card">
                    
                    <div>
                        <div class="card-top">
                            <div class="avatar-circle"><%= initials %></div>
                            <span class="blood-badge-large">
                                <%= d.getBloodGroup() %>
                            </span>
                        </div>
                        
                        <div class="donor-name">
                            <%= d.getFullName() %>
                        </div>
                        
                        <div class="donor-info">
                            📍 <span>Location: <%= d.getAddress() %></span>
                        </div>
                        
                        <div class="donor-info">
                            📞 <span>Phone: <%= d.getPhone() %></span>
                        </div>
                    </div>

                    <div style="margin-top: 24px; display: flex; flex-direction: column; gap: 10px; border-top: 1px solid var(--border); padding-top: 16px;">
                        <a href="<%= request.getContextPath() %>/PatientController?action=requestDonation&donorId=<%= d.getDonorId() %>" 
                           class="btn-request-action">
                            💉 Request Donation
                        </a>
                        
                        <form action="<%= request.getContextPath() %>/PatientController" method="post" style="width: 100%; margin: 0;">
                            <input type="hidden" name="action" value="removeFromWishlist"/>
                            <input type="hidden" name="donorId" value="<%= d.getDonorId() %>"/>
                            <button type="submit" class="btn-remove-action">
                                ❌ Remove from Wishlist
                            </button>
                        </form>
                    </div>
                    
                </div>
                <% } %>
            </div>
        <% } %>

    </div>
    <jsp:include page="../common/footer.jsp" />
</main>

</body>
</html>
