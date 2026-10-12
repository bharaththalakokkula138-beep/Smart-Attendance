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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "FacultyStudentsServlet", urlPatterns = {"/faculty/students"})
public class FacultyStudentsServlet extends HttpServlet {

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
        String filter = req.getParameter("filter"); // ALL, SAFE, WARNING, CRITICAL, BELOW_75
        String search = req.getParameter("search");

        int selectedSubjectId = (!subjects.isEmpty()) ? subjects.get(0).getSubjectId() : 0;
        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
            try {
                selectedSubjectId = Integer.parseInt(subjectIdStr);
            } catch (NumberFormatException ignored) {}
        }

        List<Map<String, Object>> students = new ArrayList<>();
        int safeCount = 0;
        int warningCount = 0;
        int criticalCount = 0;

        if (selectedSubjectId > 0) {
            List<Map<String, Object>> allStudents = attendanceDAO.getStudentsForSubjectAnalytics(selectedSubjectId, rule.getMinimumPercentage());
            for (Map<String, Object> s : allStudents) {
                String status = (String) s.get("status");
                double pct = (Double) s.get("percentage");

                if ("SAFE".equalsIgnoreCase(status)) safeCount++;
                else if ("WARNING".equalsIgnoreCase(status)) warningCount++;
                else criticalCount++;

                // Search matching
                boolean matchesSearch = true;
                if (search != null && !search.trim().isEmpty()) {
                    String q = search.trim().toLowerCase();
                    String roll = ((String) s.get("rollNo")).toLowerCase();
                    String name = ((String) s.get("name")).toLowerCase();
                    matchesSearch = roll.contains(q) || name.contains(q);
                }

                // Filter matching
                boolean matchesFilter = true;
                if (filter != null && !filter.isEmpty() && !"ALL".equalsIgnoreCase(filter)) {
                    if ("BELOW_75".equalsIgnoreCase(filter)) {
                        matchesFilter = pct < rule.getMinimumPercentage();
                    } else {
                        matchesFilter = status.equalsIgnoreCase(filter);
                    }
                }

                if (matchesSearch && matchesFilter) {
                    students.add(s);
                }
            }
        }

        req.setAttribute("subjects", subjects);
        req.setAttribute("selectedSubjectId", selectedSubjectId);
        req.setAttribute("students", students);
        req.setAttribute("totalCount", students.size());
        req.setAttribute("safeCount", safeCount);
        req.setAttribute("warningCount", warningCount);
        req.setAttribute("criticalCount", criticalCount);
        req.setAttribute("selectedFilter", filter != null ? filter : "ALL");
        req.setAttribute("searchQuery", search != null ? search : "");
        req.setAttribute("rule", rule);

        req.getRequestDispatcher("/faculty/students.jsp").forward(req, resp);
    }
}
