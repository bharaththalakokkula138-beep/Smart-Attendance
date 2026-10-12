package com.college.controller.filter;

import com.college.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow public static resources and auth endpoints
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")
                || path.equals("/login.jsp") || path.equals("/login") || path.equals("/logout")
                || path.equals("/") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please log in to continue");
            return;
        }

        String role = user.getRole();

        // Enforce role boundaries
        if (path.startsWith("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Administrator privileges required.");
            return;
        }

        if (path.startsWith("/faculty/") && !"FACULTY".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Faculty privileges required.");
            return;
        }

        if (path.startsWith("/student/") && !"STUDENT".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Student privileges required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
