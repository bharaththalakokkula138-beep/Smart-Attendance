package com.college.controller.student;

import com.college.model.AttendanceRule;
import com.college.model.LeavePredictionResult;
import com.college.model.SubjectAttendanceSummary;
import com.college.model.User;
import com.college.service.AttendanceService;
import com.college.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LeaveCalculatorServlet", urlPatterns = {"/student/leave-calculator"})
public class LeaveCalculatorServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = user.getId();
        AttendanceRule rule = attendanceService.getCurrentRule();
        List<SubjectAttendanceSummary> subjects = attendanceService.getStudentSubjectSummaries(studentId);
        int unreadCount = notificationService.getUnreadCount(studentId);

        String subjectIdStr = req.getParameter("subjectId");
        String upcomingStr = req.getParameter("upcomingClasses");
        String missStr = req.getParameter("classesToMiss");

        int subjectId = !subjects.isEmpty() ? subjects.get(0).getSubjectId() : 1;
        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
            try {
                subjectId = Integer.parseInt(subjectIdStr);
            } catch (NumberFormatException ignored) {}
        }

        int upcomingClasses = 2; // Default from example in section 6
        if (upcomingStr != null && !upcomingStr.isEmpty()) {
            try {
                upcomingClasses = Math.max(1, Integer.parseInt(upcomingStr));
            } catch (NumberFormatException ignored) {}
        }

        int classesToMiss = 2; // Default from example in section 6
        if (missStr != null && !missStr.isEmpty()) {
            try {
                classesToMiss = Math.max(0, Math.min(upcomingClasses, Integer.parseInt(missStr)));
            } catch (NumberFormatException ignored) {}
        }

        LeavePredictionResult result = attendanceService.calculateLeaveImpact(studentId, subjectId, upcomingClasses, classesToMiss);

        req.setAttribute("subjects", subjects);
        req.setAttribute("rule", rule);
        req.setAttribute("unreadCount", unreadCount);
        req.setAttribute("selectedSubjectId", subjectId);
        req.setAttribute("upcomingClasses", upcomingClasses);
        req.setAttribute("classesToMiss", classesToMiss);
        req.setAttribute("leaveResult", result);

        req.getRequestDispatcher("/student/leave-calculator.jsp").forward(req, resp);
    }
}
