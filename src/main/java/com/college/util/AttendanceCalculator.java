package com.college.util;

public class AttendanceCalculator {

    public static final double DEFAULT_REQUIRED_PERCENTAGE = 75.0;
    public static final double DEFAULT_WARNING_OFFSET = 5.0; // 70.0% to 75.0% is warning

    /**
     * Calculate attendance percentage: (Attended / Conducted) * 100
     */
    public static double calculatePercentage(int attended, int conducted) {
        if (conducted <= 0) {
            return 100.0;
        }
        double pct = ((double) attended / conducted) * 100.0;
        return round(pct, 1);
    }

    /**
     * Determine attendance status category: SAFE, WARNING, CRITICAL
     */
    public static String getStatus(double percentage, double requiredPercentage) {
        double warningThreshold = requiredPercentage - DEFAULT_WARNING_OFFSET;
        if (percentage >= requiredPercentage) {
            return "SAFE";
        } else if (percentage >= warningThreshold) {
            return "WARNING";
        } else {
            return "CRITICAL";
        }
    }

    /**
     * Determine CSS badge class for visual indicators:
     * Green = Safe, Yellow = Warning, Red = Critical
     */
    public static String getStatusBadgeClass(String status) {
        if ("SAFE".equalsIgnoreCase(status)) {
            return "badge-safe";
        } else if ("WARNING".equalsIgnoreCase(status)) {
            return "badge-warning";
        } else {
            return "badge-critical";
        }
    }

    /**
     * Calculate minimum consecutive classes 'x' student must attend to reach required percentage R:
     * (Attended + x) / (Conducted + x) >= R / 100
     * x = ceil((R * Conducted - 100 * Attended) / (100 - R))
     */
    public static int calculateClassesRequired(int attended, int conducted, double requiredPercentage) {
        if (conducted <= 0) return 0;
        double currentPct = ((double) attended / conducted) * 100.0;
        if (currentPct >= requiredPercentage) {
            return 0;
        }
        if (requiredPercentage >= 100.0) {
            return 0;
        }
        double numerator = (requiredPercentage * conducted) - (100.0 * attended);
        double denominator = 100.0 - requiredPercentage;
        int needed = (int) Math.ceil(numerator / denominator);
        return Math.max(needed, 0);
    }

    /**
     * Calculate maximum classes that can be missed while remaining above or equal to required percentage:
     * Attended / (Conducted + m) >= R / 100
     * m = floor((100 * Attended - R * Conducted) / R)
     */
    public static int calculateClassesCanMiss(int attended, int conducted, double requiredPercentage) {
        if (conducted <= 0) return 0;
        double currentPct = ((double) attended / conducted) * 100.0;
        if (currentPct < requiredPercentage) {
            return 0;
        }
        if (requiredPercentage <= 0.0) {
            return 999;
        }
        double numerator = (100.0 * attended) - (requiredPercentage * conducted);
        int canMiss = (int) Math.floor(numerator / requiredPercentage);
        return Math.max(canMiss, 0);
    }

    /**
     * Future attendance simulator: "Can I Take Leave?"
     */
    public static double predictAttendance(int attended, int conducted, int upcomingClasses, int classesToMiss) {
        int classesToAttend = Math.max(0, upcomingClasses - classesToMiss);
        int newAttended = attended + classesToAttend;
        int newConducted = conducted + upcomingClasses;
        return calculatePercentage(newAttended, newConducted);
    }

    /**
     * Utility method to round to specified decimal places
     */
    public static double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();
        long factor = (long) Math.pow(10, places);
        value = value * factor;
        long tmp = Math.round(value);
        return (double) tmp / factor;
    }
}
