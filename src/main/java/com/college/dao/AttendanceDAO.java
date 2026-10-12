package com.college.dao;

import com.college.model.*;
import com.college.util.AttendanceCalculator;
import com.college.util.DBConnection;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class AttendanceDAO {

    /**
     * Record or update attendance for a student
     */
    public boolean saveAttendance(int studentId, int subjectId, Date date, String status, Integer markedBy) {
        String sql = "INSERT INTO attendance (student_id, subject_id, date, status, marked_by) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by), marked_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setDate(3, date);
            ps.setString(4, status.toUpperCase());
            if (markedBy != null && markedBy > 0) {
                ps.setInt(5, markedBy);
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Batch save attendance for a class session
     */
    public boolean saveBatchAttendance(int subjectId, Date date, Map<Integer, String> studentStatusMap, Integer markedBy) {
        String sql = "INSERT INTO attendance (student_id, subject_id, date, status, marked_by) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by), marked_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Map.Entry<Integer, String> entry : studentStatusMap.entrySet()) {
                    ps.setInt(1, entry.getKey());
                    ps.setInt(2, subjectId);
                    ps.setDate(3, date);
                    ps.setString(4, entry.getValue().toUpperCase());
                    if (markedBy != null && markedBy > 0) {
                        ps.setInt(5, markedBy);
                    } else {
                        ps.setNull(5, Types.INTEGER);
                    }
                    ps.addBatch();
                }
                ps.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get subject-wise attendance summary for a single subject and student
     */
    public SubjectAttendanceSummary getSubjectSummary(int studentId, int subjectId, double requiredPct) {
        String sql = "SELECT sub.subject_id, sub.subject_code, sub.subject_name, f.name AS faculty_name, " +
                     "COUNT(a.attendance_id) AS conducted, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM subjects sub " +
                     "LEFT JOIN faculty f ON sub.faculty_id = f.faculty_id " +
                     "LEFT JOIN attendance a ON sub.subject_id = a.subject_id AND a.student_id = ? " +
                     "WHERE sub.subject_id = ? " +
                     "GROUP BY sub.subject_id, sub.subject_code, sub.subject_name, f.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSubjectSummary(rs, requiredPct);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all subject attendance summaries for a student
     */
    public List<SubjectAttendanceSummary> getAllSubjectSummariesForStudent(int studentId, double requiredPct) {
        List<SubjectAttendanceSummary> list = new ArrayList<>();
        String sql = "SELECT sub.subject_id, sub.subject_code, sub.subject_name, f.name AS faculty_name, " +
                     "COUNT(a.attendance_id) AS conducted, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM subjects sub " +
                     "JOIN students st ON sub.department_id = st.department_id AND sub.semester = st.semester " +
                     "LEFT JOIN faculty f ON sub.faculty_id = f.faculty_id " +
                     "LEFT JOIN attendance a ON sub.subject_id = a.subject_id AND a.student_id = st.student_id " +
                     "WHERE st.student_id = ? " +
                     "GROUP BY sub.subject_id, sub.subject_code, sub.subject_name, f.name " +
                     "ORDER BY sub.subject_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubjectSummary(rs, requiredPct));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Build full StudentAttendanceOverview for dashboard
     */
    public StudentAttendanceOverview getStudentAttendanceOverview(int studentId, double requiredPct) {
        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.getStudentById(studentId);
        if (student == null) return null;

        StudentAttendanceOverview overview = new StudentAttendanceOverview();
        overview.setStudentId(student.getStudentId());
        overview.setRollNo(student.getRollNo());
        overview.setName(student.getName());
        overview.setDepartmentName(student.getDepartmentName());
        overview.setSemester(student.getSemester());
        overview.setRequiredPercentage(requiredPct);

        List<SubjectAttendanceSummary> summaries = getAllSubjectSummariesForStudent(studentId, requiredPct);
        overview.setSubjectSummaries(summaries);
        overview.setTotalSubjects(summaries.size());

        int totalConducted = 0;
        int totalAttended = 0;
        int belowReqCount = 0;

        for (SubjectAttendanceSummary s : summaries) {
            totalConducted += s.getClassesConducted();
            totalAttended += s.getClassesAttended();
            if (s.getAttendancePercentage() < requiredPct) {
                belowReqCount++;
            }
        }

        overview.setTotalConducted(totalConducted);
        overview.setTotalAttended(totalAttended);
        overview.setTotalAbsent(Math.max(0, totalConducted - totalAttended));
        overview.setSubjectsBelowRequired(belowReqCount);

        double overallPct = AttendanceCalculator.calculatePercentage(totalAttended, totalConducted);
        overview.setOverallPercentage(overallPct);
        String status = AttendanceCalculator.getStatus(overallPct, requiredPct);
        overview.setOverallStatus(status);
        overview.setOverallBadgeClass(AttendanceCalculator.getStatusBadgeClass(status));

        // Risk Level determination
        String riskLevel = "LOW";
        String riskBadge = "badge-safe";
        if (overallPct < requiredPct - AttendanceCalculator.DEFAULT_WARNING_OFFSET || belowReqCount >= 2) {
            riskLevel = "HIGH";
            riskBadge = "badge-critical";
        } else if (overallPct < requiredPct || belowReqCount == 1) {
            riskLevel = "MEDIUM";
            riskBadge = "badge-warning";
        }
        overview.setRiskLevel(riskLevel);
        overview.setRiskBadgeClass(riskBadge);

        return overview;
    }

    /**
     * Get recent attendance records for student (e.g. last 10)
     */
    public List<Attendance> getRecentAttendanceRecords(int studentId, int limit) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*, sub.subject_name, f.name AS faculty_name FROM attendance a " +
                     "JOIN subjects sub ON a.subject_id = sub.subject_id " +
                     "LEFT JOIN faculty f ON a.marked_by = f.faculty_id " +
                     "WHERE a.student_id = ? " +
                     "ORDER BY a.date DESC, a.attendance_id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance att = new Attendance();
                    att.setAttendanceId(rs.getInt("attendance_id"));
                    att.setStudentId(rs.getInt("student_id"));
                    att.setSubjectId(rs.getInt("subject_id"));
                    att.setSubjectName(rs.getString("subject_name"));
                    att.setDate(rs.getDate("date"));
                    att.setStatus(rs.getString("status"));
                    att.setMarkedByName(rs.getString("faculty_name"));
                    att.setMarkedAt(rs.getTimestamp("marked_at"));
                    list.add(att);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get monthly attendance trend data for student (for Chart.js)
     */
    public Map<String, Double> getMonthlyAttendanceTrend(int studentId) {
        Map<String, Double> trend = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(date, '%M %Y') AS month_label, " +
                     "DATE_FORMAT(date, '%Y-%m') AS sort_key, " +
                     "COUNT(*) AS conducted, " +
                     "SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM attendance WHERE student_id = ? " +
                     "GROUP BY sort_key, month_label " +
                     "ORDER BY sort_key ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String month = rs.getString("month_label");
                    int conducted = rs.getInt("conducted");
                    int attended = rs.getInt("attended");
                    trend.put(month, AttendanceCalculator.calculatePercentage(attended, conducted));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trend;
    }

    /**
     * Get cumulative progression trend over time (chronological running percentage)
     */
    public Map<String, Double> getCumulativeAttendanceTrend(int studentId) {
        Map<String, Double> trend = new LinkedHashMap<>();
        String sql = "SELECT date, status FROM attendance WHERE student_id = ? ORDER BY date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                int total = 0;
                int present = 0;
                // Group every 5 classes for smooth trend points
                int step = 0;
                while (rs.next()) {
                    total++;
                    if ("PRESENT".equalsIgnoreCase(rs.getString("status"))) {
                        present++;
                    }
                    step++;
                    if (step % 5 == 0) {
                        Date d = rs.getDate("date");
                        trend.put(d.toString(), AttendanceCalculator.calculatePercentage(present, total));
                    }
                }
                if (total > 0 && (step % 5 != 0)) {
                    trend.put("Current", AttendanceCalculator.calculatePercentage(present, total));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trend;
    }

    /**
     * Get attendance status of students in a subject for a specific date
     */
    public Map<Integer, String> getSubjectAttendanceForDate(int subjectId, Date date) {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT student_id, status FROM attendance WHERE subject_id = ? AND date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("student_id"), rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * Get student list with individual attendance stats for a subject (Faculty view)
     */
    public List<Map<String, Object>> getStudentsForSubjectAnalytics(int subjectId, double requiredPct) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT st.student_id, st.roll_no, st.name, st.email, " +
                     "COUNT(a.attendance_id) AS conducted, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM students st " +
                     "JOIN subjects sub ON st.department_id = sub.department_id AND st.semester = sub.semester " +
                     "LEFT JOIN attendance a ON sub.subject_id = a.subject_id AND st.student_id = a.student_id " +
                     "WHERE sub.subject_id = ? " +
                     "GROUP BY st.student_id, st.roll_no, st.name, st.email " +
                     "ORDER BY st.roll_no ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    int conducted = rs.getInt("conducted");
                    int attended = rs.getInt("attended");
                    int absent = Math.max(0, conducted - attended);
                    double pct = AttendanceCalculator.calculatePercentage(attended, conducted);
                    String status = AttendanceCalculator.getStatus(pct, requiredPct);
                    int needed = AttendanceCalculator.calculateClassesRequired(attended, conducted, requiredPct);
                    int canMiss = AttendanceCalculator.calculateClassesCanMiss(attended, conducted, requiredPct);

                    map.put("studentId", rs.getInt("student_id"));
                    map.put("rollNo", rs.getString("roll_no"));
                    map.put("name", rs.getString("name"));
                    map.put("email", rs.getString("email"));
                    map.put("conducted", conducted);
                    map.put("attended", attended);
                    map.put("absent", absent);
                    map.put("percentage", pct);
                    map.put("status", status);
                    map.put("badgeClass", AttendanceCalculator.getStatusBadgeClass(status));
                    map.put("classesRequired", needed);
                    map.put("classesCanMiss", canMiss);
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get aggregate statistics for faculty across their subjects
     */
    public Map<String, Object> getFacultySummaryStats(int facultyId, double requiredPct) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT st.student_id, sub.subject_id, " +
                     "COUNT(a.attendance_id) AS conducted, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM subjects sub " +
                     "JOIN students st ON sub.department_id = st.department_id AND sub.semester = st.semester " +
                     "LEFT JOIN attendance a ON sub.subject_id = a.subject_id AND st.student_id = a.student_id " +
                     "WHERE sub.faculty_id = ? " +
                     "GROUP BY st.student_id, sub.subject_id";
        int safe = 0;
        int warning = 0;
        int critical = 0;
        int total = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    total++;
                    int conducted = rs.getInt("conducted");
                    int attended = rs.getInt("attended");
                    double pct = AttendanceCalculator.calculatePercentage(attended, conducted);
                    String st = AttendanceCalculator.getStatus(pct, requiredPct);
                    if ("SAFE".equalsIgnoreCase(st)) safe++;
                    else if ("WARNING".equalsIgnoreCase(st)) warning++;
                    else critical++;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        stats.put("totalStudentSubjects", total);
        stats.put("safeCount", safe);
        stats.put("warningCount", warning);
        stats.put("criticalCount", critical);
        return stats;
    }

    /**
     * Get College-Wide Admin Analytics
     */
    public Map<String, Object> getAdminOverallStats(double requiredPct) {
        Map<String, Object> result = new HashMap<>();
        String sql = "SELECT st.student_id, " +
                     "COUNT(a.attendance_id) AS conducted, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                     "FROM students st " +
                     "LEFT JOIN attendance a ON st.student_id = a.student_id " +
                     "GROUP BY st.student_id";
        int above75 = 0;
        int between65And75 = 0;
        int below65 = 0;
        int total = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                total++;
                int conducted = rs.getInt("conducted");
                int attended = rs.getInt("attended");
                double pct = AttendanceCalculator.calculatePercentage(attended, conducted);
                if (pct >= 75.0) {
                    above75++;
                } else if (pct >= 65.0) {
                    between65And75++;
                } else {
                    below65++;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        result.put("totalStudents", total);
        result.put("above75", above75);
        result.put("between65And75", between65And75);
        result.put("below65", below65);

        // Department-wise average attendance
        Map<String, Double> deptAvg = new LinkedHashMap<>();
        String deptSql = "SELECT d.department_code, " +
                         "COUNT(a.attendance_id) AS conducted, " +
                         "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                         "FROM departments d " +
                         "JOIN students st ON d.department_id = st.department_id " +
                         "LEFT JOIN attendance a ON st.student_id = a.student_id " +
                         "GROUP BY d.department_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(deptSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int conducted = rs.getInt("conducted");
                int attended = rs.getInt("attended");
                deptAvg.put(rs.getString("department_code"), AttendanceCalculator.calculatePercentage(attended, conducted));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        result.put("departmentAverages", deptAvg);

        // Subject-wise average attendance
        Map<String, Double> subjAvg = new LinkedHashMap<>();
        String subjSql = "SELECT s.subject_code, " +
                         "COUNT(a.attendance_id) AS conducted, " +
                         "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended " +
                         "FROM subjects s " +
                         "LEFT JOIN attendance a ON s.subject_id = a.subject_id " +
                         "GROUP BY s.subject_code";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(subjSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int conducted = rs.getInt("conducted");
                int attended = rs.getInt("attended");
                subjAvg.put(rs.getString("subject_code"), AttendanceCalculator.calculatePercentage(attended, conducted));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        result.put("subjectAverages", subjAvg);

        return result;
    }

    private SubjectAttendanceSummary mapSubjectSummary(ResultSet rs, double requiredPct) throws SQLException {
        SubjectAttendanceSummary s = new SubjectAttendanceSummary();
        s.setSubjectId(rs.getInt("subject_id"));
        s.setSubjectCode(rs.getString("subject_code"));
        s.setSubjectName(rs.getString("subject_name"));
        s.setFacultyName(rs.getString("faculty_name") != null ? rs.getString("faculty_name") : "Not Assigned");

        int conducted = rs.getInt("conducted");
        int attended = rs.getInt("attended");
        int absent = Math.max(0, conducted - attended);
        double pct = AttendanceCalculator.calculatePercentage(attended, conducted);

        s.setClassesConducted(conducted);
        s.setClassesAttended(attended);
        s.setClassesAbsent(absent);
        s.setAttendancePercentage(pct);
        s.setRequiredPercentage(requiredPct);

        String status = AttendanceCalculator.getStatus(pct, requiredPct);
        s.setStatus(status);
        s.setBadgeClass(AttendanceCalculator.getStatusBadgeClass(status));

        s.setClassesRequired(AttendanceCalculator.calculateClassesRequired(attended, conducted, requiredPct));
        s.setClassesCanMiss(AttendanceCalculator.calculateClassesCanMiss(attended, conducted, requiredPct));

        return s;
    }
}
