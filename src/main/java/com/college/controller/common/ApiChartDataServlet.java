package com.college.controller.common;

import com.college.dao.AttendanceDAO;
import com.college.dao.RuleDAO;
import com.college.model.AttendanceRule;
import com.college.model.User;
import com.college.service.AttendanceService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ApiChartDataServlet", urlPatterns = {"/api/charts"})
public class ApiChartDataServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final RuleDAO ruleDAO = new RuleDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        String action = req.getParameter("action");
        AttendanceRule rule = ruleDAO.getActiveRule();
        Map<String, Object> data = new HashMap<>();

        if ("studentTrend".equalsIgnoreCase(action)) {
            int studentId = user.getId();
            data.put("monthlyTrend", attendanceService.getMonthlyTrend(studentId));
            data.put("cumulativeTrend", attendanceService.getCumulativeTrend(studentId));
            data.put("requiredPercentage", rule.getMinimumPercentage());
        } else if ("facultyStats".equalsIgnoreCase(action)) {
            int facultyId = user.getId();
            data.put("stats", attendanceDAO.getFacultySummaryStats(facultyId, rule.getMinimumPercentage()));
        } else if ("adminStats".equalsIgnoreCase(action)) {
            data.put("stats", attendanceDAO.getAdminOverallStats(rule.getMinimumPercentage()));
        }

        resp.getWriter().write(gson.toJson(data));
    }
}
