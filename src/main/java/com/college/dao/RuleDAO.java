package com.college.dao;

import com.college.model.AttendanceRule;
import com.college.util.DBConnection;

import java.sql.*;

public class RuleDAO {

    public AttendanceRule getActiveRule() {
        String sql = "SELECT * FROM attendance_rules WHERE is_active = TRUE ORDER BY rule_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                AttendanceRule rule = new AttendanceRule();
                rule.setRuleId(rs.getInt("rule_id"));
                rule.setRuleName(rs.getString("rule_name"));
                rule.setMinimumPercentage(rs.getDouble("minimum_percentage"));
                rule.setWarningThreshold(rs.getDouble("warning_threshold"));
                rule.setCriticalThreshold(rs.getDouble("critical_threshold"));
                rule.setActive(rs.getBoolean("is_active"));
                rule.setUpdatedAt(rs.getTimestamp("updated_at"));
                return rule;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Default fallback if database table is empty
        return new AttendanceRule(1, "College Mandatory Policy", 75.0, 70.0, 65.0, true);
    }

    public boolean updateRule(double minPercentage, double warningThreshold, double criticalThreshold) {
        String sql = "UPDATE attendance_rules SET minimum_percentage = ?, warning_threshold = ?, critical_threshold = ?, updated_at = NOW() WHERE is_active = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, minPercentage);
            ps.setDouble(2, warningThreshold);
            ps.setDouble(3, criticalThreshold);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
