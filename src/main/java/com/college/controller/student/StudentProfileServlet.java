package com.college.controller.student;

import com.college.dao.StudentDAO;
import com.college.model.Student;
import com.college.model.User;
import com.college.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "StudentProfileServlet", urlPatterns = {"/student/profile"})
public class StudentProfileServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Student student = studentDAO.getStudentById(user.getId());
        int unreadCount = notificationService.getUnreadCount(user.getId());

        req.setAttribute("student", student);
        req.setAttribute("unreadCount", unreadCount);

        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Student student = studentDAO.getStudentById(user.getId());
        if (student != null) {
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            if (phone != null && !phone.trim().isEmpty()) {
                student.setPhone(phone.trim());
            }
            if (password != null && !password.trim().isEmpty()) {
                student.setPassword(password.trim());
            }
            boolean success = studentDAO.updateStudent(student);
            if (success) {
                req.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                req.setAttribute("errorMessage", "Failed to update profile.");
            }
        }

        doGet(req, resp);
    }
}
