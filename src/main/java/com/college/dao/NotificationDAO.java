package com.college.dao;

import com.college.model.Notification;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> getNotificationsByStudent(int studentId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE student_id = ? ORDER BY created_at DESC LIMIT 30";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    n.setStudentId(rs.getInt("student_id"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setType(rs.getString("type"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    n.setRead(rs.getBoolean("is_read"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadCount(int studentId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE student_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean markAsRead(int notificationId, int studentId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE notification_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAllAsRead(int studentId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createNotification(int studentId, String title, String message, String type) {
        String sql = "INSERT INTO notifications (student_id, title, message, type) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, type);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
