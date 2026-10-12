package com.college.controller.admin;

import com.college.dao.DepartmentDAO;
import com.college.dao.FacultyDAO;
import com.college.model.Department;
import com.college.model.Faculty;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FacultyManagementServlet", urlPatterns = {"/admin/faculty"})
public class FacultyManagementServlet extends HttpServlet {

    private final FacultyDAO facultyDAO = new FacultyDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Faculty> facultyList = facultyDAO.getAllFaculty();
        List<Department> departments = departmentDAO.getAllDepartments();

        req.setAttribute("facultyList", facultyList);
        req.setAttribute("departments", departments);

        req.getRequestDispatcher("/admin/faculty.jsp").forward(req, resp);
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
            Faculty f = new Faculty();
            f.setFacultyCode(req.getParameter("facultyCode"));
            f.setName(req.getParameter("name"));
            f.setEmail(req.getParameter("email"));
            f.setPassword(req.getParameter("password"));
            f.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            f.setPhone(req.getParameter("phone"));
            f.setDesignation(req.getParameter("designation"));

            boolean ok = facultyDAO.addFaculty(f);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?msg=Faculty member added successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?error=Failed to add faculty. Code or Email might exist.");
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            Faculty f = new Faculty();
            f.setFacultyId(Integer.parseInt(req.getParameter("facultyId")));
            f.setFacultyCode(req.getParameter("facultyCode"));
            f.setName(req.getParameter("name"));
            f.setEmail(req.getParameter("email"));
            f.setPassword(req.getParameter("password"));
            f.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            f.setPhone(req.getParameter("phone"));
            f.setDesignation(req.getParameter("designation"));

            boolean ok = facultyDAO.updateFaculty(f);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?msg=Faculty updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?error=Failed to update faculty.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int facultyId = Integer.parseInt(req.getParameter("facultyId"));
            boolean ok = facultyDAO.deleteFaculty(facultyId);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?msg=Faculty deleted successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/faculty?error=Failed to delete faculty.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/faculty");
        }
    }
}
