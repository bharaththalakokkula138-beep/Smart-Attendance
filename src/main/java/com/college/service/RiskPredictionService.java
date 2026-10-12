package com.college.service;

import com.college.dao.AttendanceDAO;
import com.college.dao.RuleDAO;
import com.college.model.Attendance;
import com.college.model.AttendanceRule;
import com.college.model.RiskPrediction;
import com.college.model.SubjectAttendanceSummary;
import com.college.util.AttendanceCalculator;

import java.util.List;

public class RiskPredictionService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final RuleDAO ruleDAO = new RuleDAO();

    /**
     * Performs comprehensive multi-factor attendance risk prediction for a subject or overall
     */
    public RiskPrediction predictSubjectRisk(int studentId, int subjectId) {
        AttendanceRule rule = ruleDAO.getActiveRule();
        double requiredPct = rule.getMinimumPercentage();
        SubjectAttendanceSummary summary = attendanceDAO.getSubjectSummary(studentId, subjectId, requiredPct);

        RiskPrediction pred = new RiskPrediction();
        if (summary == null) {
            pred.setRiskLevel("LOW RISK");
            pred.setRiskBadgeClass("badge-safe");
            pred.setRecommendation("No attendance records found yet.");
            return pred;
        }

        int conducted = summary.getClassesConducted();
        int attended = summary.getClassesAttended();
        int absences = summary.getClassesAbsent();
        double currentPct = summary.getAttendancePercentage();

        pred.setCurrentPercentage(currentPct);
        pred.setRequiredPercentage(requiredPct);
        pred.setClassesConducted(conducted);
        pred.setClassesAttended(attended);
        pred.setAbsences(absences);

        // Standard semester subject duration: 50 classes planned
        int totalPlanned = 50;
        int remainingClasses = Math.max(0, totalPlanned - conducted);
        pred.setEstimatedRemainingClasses(remainingClasses);

        // Maximum attainable percentage if student attends 100% of remaining classes
        int maxAttended = attended + remainingClasses;
        int maxConducted = conducted + remainingClasses;
        double maxPossiblePct = AttendanceCalculator.calculatePercentage(maxAttended, maxConducted);
        pred.setMaxPossiblePercentage(maxPossiblePct);

        // Consecutive classes needed to reach required %
        int needed = AttendanceCalculator.calculateClassesRequired(attended, conducted, requiredPct);
        pred.setConsecutiveClassesNeeded(needed);

        // Recent trend analysis: inspect last 8 records
        List<Attendance> recentList = attendanceDAO.getRecentAttendanceRecords(studentId, 8);
        int recentAbsences = 0;
        int recentTotal = 0;
        for (Attendance a : recentList) {
            if (a.getSubjectId() == subjectId) {
                recentTotal++;
                if ("ABSENT".equalsIgnoreCase(a.getStatus())) {
                    recentAbsences++;
                }
            }
        }
        double recentAbsenceRate = recentTotal > 0 ? ((double) recentAbsences / recentTotal) * 100.0 : 0.0;
        pred.setRecentAbsenceRate(AttendanceCalculator.round(recentAbsenceRate, 1));

        // Evaluate risk category and build reasons
        boolean isHighRisk = false;
        boolean isMediumRisk = false;

        if (currentPct < rule.getCriticalThreshold()) {
            isHighRisk = true;
            pred.addReason("Current attendance is at a critical " + currentPct + "% (below " + rule.getCriticalThreshold() + "%).");
        } else if (currentPct < requiredPct) {
            isMediumRisk = true;
            pred.addReason("Current attendance of " + currentPct + "% is below the mandatory " + requiredPct + "% requirement.");
        }

        if (needed > remainingClasses) {
            isHighRisk = true;
            pred.addReason("Mathematically critical: You need " + needed + " consecutive classes, but only ~" + remainingClasses + " classes remain this semester.");
        } else if (needed > 0) {
            pred.addReason("You must attend the next " + needed + " consecutive classes without absence to cross " + requiredPct + "%.");
        }

        if (recentAbsenceRate >= 40.0) {
            if (currentPct < requiredPct) {
                isHighRisk = true;
            } else {
                isMediumRisk = true;
            }
            pred.addReason("Recent absence rate is alarming (" + pred.getRecentAbsenceRate() + "% absences in recent sessions).");
        }

        if (currentPct >= requiredPct && summary.getClassesCanMiss() <= 1) {
            isMediumRisk = true;
            pred.addReason("Low safety cushion: You can only afford to miss " + summary.getClassesCanMiss() + " more class before dipping below " + requiredPct + "%.");
        }

        // Final Classification and Recommendation
        if (isHighRisk) {
            pred.setRiskLevel("HIGH RISK");
            pred.setRiskBadgeClass("badge-critical");
            pred.setRiskColor("#ef4444");
            pred.setRecommendation("Attend all upcoming " + remainingClasses + " classes without any further absences. Meet your subject faculty (" + summary.getFacultyName() + ") and academic advisor immediately.");
        } else if (isMediumRisk) {
            pred.setRiskLevel("MEDIUM RISK");
            pred.setRiskBadgeClass("badge-warning");
            pred.setRiskColor("#f59e0b");
            pred.setRecommendation("Prioritize attending upcoming sessions. Maintain consistent presence in the next " + Math.max(needed, 5) + " classes to fortify your attendance buffer.");
        } else {
            pred.setRiskLevel("LOW RISK");
            pred.setRiskBadgeClass("badge-safe");
            pred.setRiskColor("#10b981");
            pred.addReason("Attendance is well above the threshold (" + currentPct + "% >= " + requiredPct + "%).");
            pred.addReason("Healthy safety cushion: You can miss up to " + summary.getClassesCanMiss() + " classes and still remain safe.");
            pred.setRecommendation("Maintain your consistent attendance routine. Excellent performance!");
        }

        return pred;
    }
}
