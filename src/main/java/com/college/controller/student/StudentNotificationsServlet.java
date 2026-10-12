package com.college.controller.student;

import com.college.model.Notification;
import com.college.model.User;
import com.college.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentNotificationsServlet", urlPatterns = {"/student/notifications"})
public class StudentNotificationsServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = user.getId();
        String action = req.getParameter("action");

        if ("read".equalsIgnoreCase(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int notifId = Integer.parseInt(idStr);
                    notificationService.markAsRead(notifId, studentId);
                } catch (NumberFormatException ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/student/notifications");
            return;
        } else if ("readAll".equalsIgnoreCase(action)) {
            notificationService.markAllAsRead(studentId);
            resp.sendRedirect(req.getContextPath() + "/student/notifications");
            return;
        }

        List<Notification> notifications = notificationService.getStudentNotifications(studentId);
        int unreadCount = notificationService.getUnreadCount(studentId);

        req.setAttribute("notifications", notifications);
        req.setAttribute("unreadCount", unreadCount);

        req.getRequestDispatcher("/student/notifications.jsp").forward(req, resp);
    }
}
