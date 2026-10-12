package com.college.controller.student;

import com.college.model.RiskPrediction;
import com.college.model.StudentAttendanceOverview;
import com.college.model.SubjectAttendanceSummary;
import com.college.model.User;
import com.college.service.AttendanceService;
import com.college.service.NotificationService;
import com.college.service.RiskPredictionService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "StudentAnalyticsServlet", urlPatterns = {"/student/analytics"})
public class StudentAnalyticsServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
    private final RiskPredictionService riskService = new RiskPredictionService();
    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = user.getId();
        StudentAttendanceOverview overview = attendanceService.getStudentDashboardData(studentId);
        int unreadCount = notificationService.getUnreadCount(studentId);

        // Compute risk predictions for each subject
        Map<Integer, RiskPrediction> subjectRiskMap = new LinkedHashMap<>();
        if (overview != null && overview.getSubjectSummaries() != null) {
            for (SubjectAttendanceSummary s : overview.getSubjectSummaries()) {
                RiskPrediction pred = riskService.predictSubjectRisk(studentId, s.getSubjectId());
                subjectRiskMap.put(s.getSubjectId(), pred);
            }
        }

        // Monthly Trend
        Map<String, Double> monthlyTrend = attendanceService.getMonthlyTrend(studentId);
        // Cumulative timeline trend
        Map<String, Double> cumulativeTrend = attendanceService.getCumulativeTrend(studentId);

        req.setAttribute("overview", overview);
        req.setAttribute("unreadCount", unreadCount);
        req.setAttribute("subjectRiskMap", subjectRiskMap);
        req.setAttribute("monthlyTrendJson", gson.toJson(monthlyTrend));
        req.setAttribute("cumulativeTrendJson", gson.toJson(cumulativeTrend));

        req.getRequestDispatcher("/student/analytics.jsp").forward(req, resp);
    }
}
