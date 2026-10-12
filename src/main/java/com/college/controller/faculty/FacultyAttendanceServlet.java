package com.college.controller.faculty;

import com.college.dao.AttendanceDAO;
import com.college.dao.StudentDAO;
import com.college.dao.SubjectDAO;
import com.college.model.Student;
import com.college.model.Subject;
import com.college.model.User;
import com.college.service.AttendanceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@WebServlet(name = "FacultyAttendanceServlet", urlPatterns = {"/faculty/attendance"})
public class FacultyAttendanceServlet extends HttpServlet {

    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final AttendanceService attendanceService = new AttendanceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int facultyId = user.getId();
        List<Subject> subjects = subjectDAO.getSubjectsByFaculty(facultyId);

        String subjectIdStr = req.getParameter("subjectId");
        String dateStr = req.getParameter("date");

        int selectedSubjectId = (subjects != null && !subjects.isEmpty()) ? subjects.get(0).getSubjectId() : 0;
        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
            try {
                selectedSubjectId = Integer.parseInt(subjectIdStr);
            } catch (NumberFormatException ignored) {}
        }

        LocalDate localDate = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : LocalDate.now();
        Date sqlDate = Date.valueOf(localDate);

        List<Student> students = new ArrayList<>();
        Map<Integer, String> existingStatusMap = new HashMap<>();

        if (selectedSubjectId > 0) {
            students = studentDAO.getStudentsBySubject(selectedSubjectId);
            existingStatusMap = attendanceDAO.getSubjectAttendanceForDate(selectedSubjectId, sqlDate);
        }

        req.setAttribute("subjects", subjects);
        req.setAttribute("selectedSubjectId", selectedSubjectId);
        req.setAttribute("selectedDate", localDate.toString());
        req.setAttribute("students", students);
        req.setAttribute("existingStatusMap", existingStatusMap);

        req.getRequestDispatcher("/faculty/attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int facultyId = user.getId();
        int subjectId = Integer.parseInt(req.getParameter("subjectId"));
        String dateStr = req.getParameter("date");
        Date date = Date.valueOf(dateStr);

        // Fetch students enrolled in this subject
        List<Student> students = studentDAO.getStudentsBySubject(subjectId);
        Map<Integer, String> statusMap = new HashMap<>();

        for (Student s : students) {
            String paramVal = req.getParameter("status_" + s.getStudentId());
            // If checkbox checked, status is "PRESENT", otherwise if radio or checkbox
            if ("PRESENT".equalsIgnoreCase(paramVal) || "on".equalsIgnoreCase(paramVal)) {
                statusMap.put(s.getStudentId(), "PRESENT");
            } else {
                statusMap.put(s.getStudentId(), "ABSENT");
            }
        }

        boolean ok = attendanceService.markAttendanceBatch(subjectId, date, statusMap, facultyId);

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/faculty/attendance?subjectId=" + subjectId + "&date=" + dateStr + "&msg=Attendance saved successfully for " + students.size() + " students.");
        } else {
            resp.sendRedirect(req.getContextPath() + "/faculty/attendance?subjectId=" + subjectId + "&date=" + dateStr + "&error=Failed to save attendance.");
        }
    }
}
