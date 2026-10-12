package com.college.controller.common;

import com.college.dao.AttendanceDAO;
import com.college.dao.RuleDAO;
import com.college.dao.SubjectDAO;
import com.college.model.AttendanceRule;
import com.college.model.StudentAttendanceOverview;
import com.college.model.Subject;
import com.college.model.User;
import com.college.service.AttendanceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final RuleDAO ruleDAO = new RuleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String type = req.getParameter("type"); // student, faculty, admin
        AttendanceRule rule = ruleDAO.getActiveRule();
        req.setAttribute("rule", rule);
        req.setAttribute("currentDate", LocalDate.now().toString());

        if ("student".equalsIgnoreCase(type) || "STUDENT".equalsIgnoreCase(user.getRole())) {
            int studentId = user.getId();
            String sId = req.getParameter("studentId");
            if (("ADMIN".equalsIgnoreCase(user.getRole()) || "FACULTY".equalsIgnoreCase(user.getRole())) && sId != null) {
                studentId = Integer.parseInt(sId);
            }
            StudentAttendanceOverview overview = attendanceService.getStudentDashboardData(studentId);
            req.setAttribute("overview", overview);
            req.setAttribute("reportType", "student");
        } else if ("faculty".equalsIgnoreCase(type) || "FACULTY".equalsIgnoreCase(user.getRole())) {
            String subjIdStr = req.getParameter("subjectId");
            int subjId = 1;
            if (subjIdStr != null) {
                subjId = Integer.parseInt(subjIdStr);
            }
            Subject subj = subjectDAO.getSubjectById(subjId);
            List<Map<String, Object>> students = attendanceDAO.getStudentsForSubjectAnalytics(subjId, rule.getMinimumPercentage());
            req.setAttribute("currentSubject", subj);
            req.setAttribute("students", students);
            req.setAttribute("reportType", "faculty");
        } else if ("admin".equalsIgnoreCase(type) || "ADMIN".equalsIgnoreCase(user.getRole())) {
            Map<String, Object> stats = attendanceDAO.getAdminOverallStats(rule.getMinimumPercentage());
            req.setAttribute("stats", stats);
            req.setAttribute("reportType", "admin");
        }

        req.getRequestDispatcher("/common/printable-report.jsp").forward(req, resp);
    }
}
