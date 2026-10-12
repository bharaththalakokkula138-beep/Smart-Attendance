package com.college.service;

import com.college.dao.*;
import com.college.model.*;
import com.college.util.AttendanceCalculator;

import java.sql.Date;
import java.util.List;
import java.util.Map;

public class AttendanceService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final RuleDAO ruleDAO = new RuleDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final NotificationService notificationService = new NotificationService();

    public AttendanceRule getCurrentRule() {
        return ruleDAO.getActiveRule();
    }

    public StudentAttendanceOverview getStudentDashboardData(int studentId) {
        AttendanceRule rule = ruleDAO.getActiveRule();
        return attendanceDAO.getStudentAttendanceOverview(studentId, rule.getMinimumPercentage());
    }

    public List<SubjectAttendanceSummary> getStudentSubjectSummaries(int studentId) {
        AttendanceRule rule = ruleDAO.getActiveRule();
        return attendanceDAO.getAllSubjectSummariesForStudent(studentId, rule.getMinimumPercentage());
    }

    public SubjectAttendanceSummary getSubjectSummary(int studentId, int subjectId) {
        AttendanceRule rule = ruleDAO.getActiveRule();
        return attendanceDAO.getSubjectSummary(studentId, subjectId, rule.getMinimumPercentage());
    }

    public List<Attendance> getRecentAttendance(int studentId, int limit) {
        return attendanceDAO.getRecentAttendanceRecords(studentId, limit);
    }

    public Map<String, Double> getMonthlyTrend(int studentId) {
        return attendanceDAO.getMonthlyAttendanceTrend(studentId);
    }

    public Map<String, Double> getCumulativeTrend(int studentId) {
        return attendanceDAO.getCumulativeAttendanceTrend(studentId);
    }

    /**
     * "Can I Take Leave?" Calculator logic
     */
    public LeavePredictionResult calculateLeaveImpact(int studentId, int subjectId, int upcomingClasses, int classesToMiss) {
        AttendanceRule rule = ruleDAO.getActiveRule();
        double req = rule.getMinimumPercentage();

        SubjectAttendanceSummary current = attendanceDAO.getSubjectSummary(studentId, subjectId, req);
        LeavePredictionResult res = new LeavePredictionResult();
        res.setSubjectId(subjectId);
        res.setUpcomingClasses(upcomingClasses);
        res.setClassesToMiss(classesToMiss);
        res.setRequiredPercentage(req);

        if (current == null) {
            res.setSubjectName("Selected Subject");
            res.setCurrentAttended(0);
            res.setCurrentConducted(0);
            res.setCurrentPercentage(0.0);
            res.setPredictedAttended(0);
            res.setPredictedConducted(upcomingClasses);
            res.setPredictedPercentage(0.0);
            res.setSafe(false);
            res.setStatus("CRITICAL");
            res.setBadgeClass("badge-critical");
            res.setMessage("No attendance records found for this subject.");
            res.setRecommendation("Attend all upcoming classes to establish attendance.");
            return res;
        }

        res.setSubjectName(current.getSubjectName());
        res.setCurrentAttended(current.getClassesAttended());
        res.setCurrentConducted(current.getClassesConducted());
        res.setCurrentPercentage(current.getAttendancePercentage());

        int attendCount = Math.max(0, upcomingClasses - classesToMiss);
        int predAttended = current.getClassesAttended() + attendCount;
        int predConducted = current.getClassesConducted() + upcomingClasses;
        double predPct = AttendanceCalculator.calculatePercentage(predAttended, predConducted);

        res.setPredictedAttended(predAttended);
        res.setPredictedConducted(predConducted);
        res.setPredictedPercentage(predPct);

        String status = AttendanceCalculator.getStatus(predPct, req);
        res.setStatus(status);
        res.setBadgeClass(AttendanceCalculator.getStatusBadgeClass(status));

        if (predPct >= req) {
            res.setSafe(true);
            res.setMessage("✅ You can take leave and remain above " + req + "%. Predicted attendance: " + predPct + "%.");
            int margin = AttendanceCalculator.calculateClassesCanMiss(predAttended, predConducted, req);
            res.setRecommendation("You still have a buffer to miss up to " + margin + " more class(es) safely.");
        } else if (predPct >= (req - rule.getWarningThreshold() + 65.0)) { // Warning
            res.setSafe(false);
            res.setMessage("⚠️ Warning! If you miss " + classesToMiss + " class(es), your attendance will fall to " + predPct + "% (below " + req + "% threshold).");
            res.setRecommendation("Recommended Action: Avoid taking this leave. Attend all upcoming " + upcomingClasses + " classes to stay safe.");
        } else { // Critical
            res.setSafe(false);
            res.setMessage("🔴 Critical Danger! Your attendance will collapse to " + predPct + "%! Shortage alert!");
            res.setRecommendation("Recommended Action: Strictly do not miss any class. Immediate attendance recovery is required.");
        }

        return res;
    }

    /**
     * Mark attendance for a session and trigger notification alerts if needed
     */
    public boolean markAttendanceBatch(int subjectId, Date date, Map<Integer, String> studentStatusMap, int facultyId) {
        boolean ok = attendanceDAO.saveBatchAttendance(subjectId, date, studentStatusMap, facultyId);
        if (ok) {
            AttendanceRule rule = ruleDAO.getActiveRule();
            // Check student statuses and generate notification for affected students
            for (Integer studentId : studentStatusMap.keySet()) {
                SubjectAttendanceSummary s = attendanceDAO.getSubjectSummary(studentId, subjectId, rule.getMinimumPercentage());
                if (s != null && s.getAttendancePercentage() < rule.getMinimumPercentage()) {
                    notificationService.checkAndTriggerAttendanceAlert(studentId, s);
                }
            }
        }
        return ok;
    }
}
