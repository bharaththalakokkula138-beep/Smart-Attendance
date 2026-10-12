package com.college.controller.student;

import com.college.model.AttendanceRule;
import com.college.model.SubjectAttendanceSummary;
import com.college.model.User;
import com.college.service.AttendanceService;
import com.college.service.NotificationService;
import com.college.util.AttendanceCalculator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShortageCalculatorServlet", urlPatterns = {"/student/shortage-calculator"})
public class ShortageCalculatorServlet extends HttpServlet {

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
        String conductedStr = req.getParameter("conducted");
        String attendedStr = req.getParameter("attended");
        String reqPctStr = req.getParameter("requiredPercentage");

        double requiredPercentage = (reqPctStr != null && !reqPctStr.isEmpty()) ?
                Double.parseDouble(reqPctStr) : rule.getMinimumPercentage();

        int conducted = 40;
        int attended = 28;
        String subjectName = "Custom Calculation";

        if (subjectIdStr != null && !subjectIdStr.isEmpty() && !subjectIdStr.equals("custom")) {
            int subjId = Integer.parseInt(subjectIdStr);
            SubjectAttendanceSummary match = null;
            for (SubjectAttendanceSummary s : subjects) {
                if (s.getSubjectId() == subjId) {
                    match = s;
                    break;
                }
            }
            if (match != null) {
                conducted = match.getClassesConducted();
                attended = match.getClassesAttended();
                subjectName = match.getSubjectName();
                req.setAttribute("selectedSubjectId", subjId);
            }
        } else if (conductedStr != null && attendedStr != null) {
            try {
                conducted = Math.max(1, Integer.parseInt(conductedStr));
                attended = Math.min(conducted, Math.max(0, Integer.parseInt(attendedStr)));
            } catch (NumberFormatException ignored) {}
        } else if (!subjects.isEmpty()) {
            // Default to first subject below required % if any, else first subject
            SubjectAttendanceSummary defaultSubj = subjects.get(0);
            for (SubjectAttendanceSummary s : subjects) {
                if (s.getAttendancePercentage() < requiredPercentage) {
                    defaultSubj = s;
                    break;
                }
            }
            conducted = defaultSubj.getClassesConducted();
            attended = defaultSubj.getClassesAttended();
            subjectName = defaultSubj.getSubjectName();
            req.setAttribute("selectedSubjectId", defaultSubj.getSubjectId());
        }

        double currentPercentage = AttendanceCalculator.calculatePercentage(attended, conducted);
        int classesRequired = AttendanceCalculator.calculateClassesRequired(attended, conducted, requiredPercentage);
        int classesCanMiss = AttendanceCalculator.calculateClassesCanMiss(attended, conducted, requiredPercentage);
        String status = AttendanceCalculator.getStatus(currentPercentage, requiredPercentage);

        req.setAttribute("subjects", subjects);
        req.setAttribute("rule", rule);
        req.setAttribute("unreadCount", unreadCount);
        req.setAttribute("calcSubjectName", subjectName);
        req.setAttribute("calcConducted", conducted);
        req.setAttribute("calcAttended", attended);
        req.setAttribute("calcAbsent", Math.max(0, conducted - attended));
        req.setAttribute("calcCurrentPct", currentPercentage);
        req.setAttribute("calcRequiredPct", requiredPercentage);
        req.setAttribute("calcClassesRequired", classesRequired);
        req.setAttribute("calcClassesCanMiss", classesCanMiss);
        req.setAttribute("calcStatus", status);
        req.setAttribute("calcBadgeClass", AttendanceCalculator.getStatusBadgeClass(status));

        req.getRequestDispatcher("/student/shortage-calculator.jsp").forward(req, resp);
    }
}
