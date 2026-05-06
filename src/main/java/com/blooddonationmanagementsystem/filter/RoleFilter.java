package com.blooddonationmanagementsystem.filter;

import com.blooddonationmanagementsystem.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


@WebFilter("/*")
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String contextPath = request.getContextPath();
        String requestURI  = request.getRequestURI();
        String path        = requestURI.substring(contextPath.length());

        // Get the logged in user from session (may be null for public pages)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // If no user is logged in, AuthFilter handles the redirect — skip role check
        if (user == null) {
            chain.doFilter(request, response);
            return;
        }

        String role = user.getRole();

        //Enforce role boundaries

        if (path.startsWith("/admin/") && !"admin".equals(role)) {
            // Non-admin tried to access admin pages
            redirectToDashboard(role, contextPath, response);
            return;
        }

        if (path.startsWith("/donor/") && !"donor".equals(role)) {
            // Non-donor tried to access donor pages
            redirectToDashboard(role, contextPath, response);
            return;
        }

        if (path.startsWith("/patient/") && !"patient".equals(role)) {
            // Non patient tried to access patient pages
            redirectToDashboard(role, contextPath, response);
            return;
        }

        // Role is correct allow the request through
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private void redirectToDashboard(String role, String contextPath,
                                     HttpServletResponse response) throws IOException {
        if ("admin".equals(role)) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if ("donor".equals(role)) {
            response.sendRedirect(contextPath + "/donor/dashboard");
        } else if ("patient".equals(role)) {
            response.sendRedirect(contextPath + "/patient/dashboard");
        } else {
            response.sendRedirect(contextPath + "/login");
        }
    }
}