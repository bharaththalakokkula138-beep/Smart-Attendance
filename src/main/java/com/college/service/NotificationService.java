package com.college.service;

import com.college.dao.NotificationDAO;
import com.college.model.Notification;
import com.college.model.SubjectAttendanceSummary;

import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    public List<Notification> getStudentNotifications(int studentId) {
        return notificationDAO.getNotificationsByStudent(studentId);
    }

    public int getUnreadCount(int studentId) {
        return notificationDAO.getUnreadCount(studentId);
    }

    public boolean markAsRead(int notificationId, int studentId) {
        return notificationDAO.markAsRead(notificationId, studentId);
    }

    public boolean markAllAsRead(int studentId) {
        return notificationDAO.markAllAsRead(studentId);
    }

    public void checkAndTriggerAttendanceAlert(int studentId, SubjectAttendanceSummary summary) {
        if (summary == null) return;
        double pct = summary.getAttendancePercentage();
        double req = summary.getRequiredPercentage();

        if (pct < req - 5.0) {
            String title = "Critical Attendance Alert - " + summary.getSubjectName();
            String msg = "Your " + summary.getSubjectName() + " attendance is currently " + pct +
                         "%. You need to attend the next " + summary.getClassesRequired() + " consecutive classes to reach " + req + "%.";
            notificationDAO.createNotification(studentId, title, msg, "CRITICAL");
        } else if (pct < req) {
            String title = "Attendance Warning - " + summary.getSubjectName();
            String msg = "Your " + summary.getSubjectName() + " attendance has fallen to " + pct +
                         "%. You are below the required " + req + "%.";
            notificationDAO.createNotification(studentId, title, msg, "WARNING");
        }
    }
}
