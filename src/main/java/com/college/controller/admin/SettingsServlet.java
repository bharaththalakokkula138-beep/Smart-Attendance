package com.college.controller.admin;

import com.college.dao.RuleDAO;
import com.college.model.AttendanceRule;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/admin/settings"})
public class SettingsServlet extends HttpServlet {

    private final RuleDAO ruleDAO = new RuleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        AttendanceRule rule = ruleDAO.getActiveRule();
        req.setAttribute("rule", rule);

        req.getRequestDispatcher("/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            double minPct = Double.parseDouble(req.getParameter("minimumPercentage"));
            double warnThreshold = Double.parseDouble(req.getParameter("warningThreshold"));
            double critThreshold = Double.parseDouble(req.getParameter("criticalThreshold"));

            if (minPct <= warnThreshold || warnThreshold <= critThreshold) {
                resp.sendRedirect(req.getContextPath() + "/admin/settings?error=Invalid thresholds: Minimum % must be greater than Warning %, which must be greater than Critical %.");
                return;
            }

            boolean ok = ruleDAO.updateRule(minPct, warnThreshold, critThreshold);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/settings?msg=Attendance policy rules updated successfully.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/settings?error=Failed to update attendance rules.");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/settings?error=Please enter valid numeric percentage values.");
        }
    }
}
