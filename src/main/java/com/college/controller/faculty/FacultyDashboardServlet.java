package com.college.controller.faculty;

import com.college.dao.AttendanceDAO;
import com.college.dao.RuleDAO;
import com.college.dao.SubjectDAO;
import com.college.model.AttendanceRule;
import com.college.model.Subject;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "FacultyDashboardServlet", urlPatterns = {"/faculty/dashboard"})
public class FacultyDashboardServlet extends HttpServlet {

    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final RuleDAO ruleDAO = new RuleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int facultyId = user.getId();
        AttendanceRule rule = ruleDAO.getActiveRule();
        List<Subject> subjects = subjectDAO.getSubjectsByFaculty(facultyId);
        Map<String, Object> stats = attendanceDAO.getFacultySummaryStats(facultyId, rule.getMinimumPercentage());

        req.setAttribute("subjects", subjects);
        req.setAttribute("stats", stats);
        req.setAttribute("rule", rule);

        req.getRequestDispatcher("/faculty/dashboard.jsp").forward(req, resp);
    }
}
