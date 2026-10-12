package com.college.controller.admin;

import com.college.dao.*;
import com.college.model.AttendanceRule;
import com.college.model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final FacultyDAO facultyDAO = new FacultyDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final RuleDAO ruleDAO = new RuleDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        AttendanceRule rule = ruleDAO.getActiveRule();
        int totalStudents = studentDAO.countStudents();
        int totalFaculty = facultyDAO.countFaculty();
        int totalSubjects = subjectDAO.countSubjects();

        Map<String, Object> adminStats = attendanceDAO.getAdminOverallStats(rule.getMinimumPercentage());

        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("totalFaculty", totalFaculty);
        req.setAttribute("totalSubjects", totalSubjects);
        req.setAttribute("adminStats", adminStats);
        req.setAttribute("rule", rule);

        req.setAttribute("deptAveragesJson", gson.toJson(adminStats.get("departmentAverages")));
        req.setAttribute("subjAveragesJson", gson.toJson(adminStats.get("subjectAverages")));

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
