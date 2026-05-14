package com.blooddonationmanagementsystem.filter;

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
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        String path = requestURI.substring(contextPath.length());

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check for active session 
        HttpSession session = request.getSession(false);
        boolean isLoggedIn  = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // Session is valid 
            chain.doFilter(request, response);
        } else {
            // No session 
            response.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
            || path.equals("/login")
            || path.equals("/register")
            || path.equals("/index.jsp")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/images/")
            || path.startsWith("/views/auth/")
            || path.startsWith("/views/common/")
            || path.equals("/about")
            || path.equals("/contact")
            || path.equals("/error");
    }
}
