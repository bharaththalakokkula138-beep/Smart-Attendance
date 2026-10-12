package com.college.controller.auth;

import com.college.model.User;
import com.college.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User user = (User) session.getAttribute("loggedUser");
            redirectByRole(req, resp, user.getRole());
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String identifier = req.getParameter("identifier");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        User user = authService.login(identifier, password, role);

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setMaxInactiveInterval(60 * 60); // 1 hour session
            redirectByRole(req, resp, user.getRole());
        } else {
            req.setAttribute("errorMessage", "Invalid username/email or password. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp, String role) throws IOException {
        if ("STUDENT".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        } else if ("FACULTY".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/faculty/dashboard");
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
