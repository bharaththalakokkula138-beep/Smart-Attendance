package com.college.controller.admin;

import com.college.dao.DepartmentDAO;
import com.college.dao.StudentDAO;
import com.college.model.Department;
import com.college.model.Student;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentManagementServlet", urlPatterns = {"/admin/students"})
public class StudentManagementServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String search = req.getParameter("search");
        List<Student> students;
        if (search != null && !search.trim().isEmpty()) {
            students = studentDAO.searchStudents(search.trim());
        } else {
            students = studentDAO.getAllStudents();
        }

        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("students", students);
        req.setAttribute("departments", departments);
        req.setAttribute("searchQuery", search != null ? search : "");

        req.getRequestDispatcher("/admin/students.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            Student s = new Student();
            s.setRollNo(req.getParameter("rollNo"));
            s.setName(req.getParameter("name"));
            s.setEmail(req.getParameter("email"));
            s.setPassword(req.getParameter("password"));
            s.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            s.setSemester(Integer.parseInt(req.getParameter("semester")));
            s.setPhone(req.getParameter("phone"));

            boolean ok = studentDAO.addStudent(s);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/students?msg=Student added successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/students?error=Failed to add student. Roll No or Email might exist.");
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            Student s = new Student();
            s.setStudentId(Integer.parseInt(req.getParameter("studentId")));
            s.setRollNo(req.getParameter("rollNo"));
            s.setName(req.getParameter("name"));
            s.setEmail(req.getParameter("email"));
            s.setPassword(req.getParameter("password"));
            s.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            s.setSemester(Integer.parseInt(req.getParameter("semester")));
            s.setPhone(req.getParameter("phone"));

            boolean ok = studentDAO.updateStudent(s);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/students?msg=Student updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/students?error=Failed to update student.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int studentId = Integer.parseInt(req.getParameter("studentId"));
            boolean ok = studentDAO.deleteStudent(studentId);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/students?msg=Student deleted successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/students?error=Failed to delete student.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/students");
        }
    }
}
