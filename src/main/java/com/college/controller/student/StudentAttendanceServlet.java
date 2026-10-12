package com.college.controller.student;

import com.college.model.StudentAttendanceOverview;
import com.college.model.User;
import com.college.service.AttendanceService;
import com.college.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "StudentAttendanceServlet", urlPatterns = {"/student/attendance"})
public class StudentAttendanceServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();
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
        StudentAttendanceOverview overview = attendanceService.getStudentDashboardData(studentId);
        int unreadCount = notificationService.getUnreadCount(studentId);

        req.setAttribute("overview", overview);
        req.setAttribute("unreadCount", unreadCount);

        req.getRequestDispatcher("/student/attendance.jsp").forward(req, resp);
    }
}
