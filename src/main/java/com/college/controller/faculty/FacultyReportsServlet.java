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

@WebServlet(name = "FacultyReportsServlet", urlPatterns = {"/faculty/reports"})
public class FacultyReportsServlet extends HttpServlet {

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

        String subjectIdStr = req.getParameter("subjectId");
        int selectedSubjectId = (!subjects.isEmpty()) ? subjects.get(0).getSubjectId() : 0;
        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
            try {
                selectedSubjectId = Integer.parseInt(subjectIdStr);
            } catch (NumberFormatException ignored) {}
        }

        Subject currentSubject = null;
        List<Map<String, Object>> students = null;

        if (selectedSubjectId > 0) {
            currentSubject = subjectDAO.getSubjectById(selectedSubjectId);
            students = attendanceDAO.getStudentsForSubjectAnalytics(selectedSubjectId, rule.getMinimumPercentage());
        }

        req.setAttribute("subjects", subjects);
        req.setAttribute("currentSubject", currentSubject);
        req.setAttribute("selectedSubjectId", selectedSubjectId);
        req.setAttribute("students", students);
        req.setAttribute("rule", rule);

        req.getRequestDispatcher("/faculty/reports.jsp").forward(req, resp);
    }
}
