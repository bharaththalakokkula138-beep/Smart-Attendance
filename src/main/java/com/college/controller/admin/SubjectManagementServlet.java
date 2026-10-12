package com.college.controller.admin;

import com.college.dao.DepartmentDAO;
import com.college.dao.FacultyDAO;
import com.college.dao.SubjectDAO;
import com.college.model.Department;
import com.college.model.Faculty;
import com.college.model.Subject;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubjectManagementServlet", urlPatterns = {"/admin/subjects"})
public class SubjectManagementServlet extends HttpServlet {

    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final FacultyDAO facultyDAO = new FacultyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Department> departments = departmentDAO.getAllDepartments();
        List<Faculty> facultyList = facultyDAO.getAllFaculty();

        req.setAttribute("subjects", subjects);
        req.setAttribute("departments", departments);
        req.setAttribute("facultyList", facultyList);

        req.getRequestDispatcher("/admin/subjects.jsp").forward(req, resp);
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
            Subject s = new Subject();
            s.setSubjectCode(req.getParameter("subjectCode"));
            s.setSubjectName(req.getParameter("subjectName"));
            s.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            s.setSemester(Integer.parseInt(req.getParameter("semester")));
            String fId = req.getParameter("facultyId");
            if (fId != null && !fId.isEmpty()) {
                s.setFacultyId(Integer.parseInt(fId));
            }
            String planned = req.getParameter("totalClassesPlanned");
            s.setTotalClassesPlanned(planned != null && !planned.isEmpty() ? Integer.parseInt(planned) : 50);

            boolean ok = subjectDAO.addSubject(s);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=Subject added successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=Failed to add subject. Code might already exist.");
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            Subject s = new Subject();
            s.setSubjectId(Integer.parseInt(req.getParameter("subjectId")));
            s.setSubjectCode(req.getParameter("subjectCode"));
            s.setSubjectName(req.getParameter("subjectName"));
            s.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            s.setSemester(Integer.parseInt(req.getParameter("semester")));
            String fId = req.getParameter("facultyId");
            if (fId != null && !fId.isEmpty()) {
                s.setFacultyId(Integer.parseInt(fId));
            }
            String planned = req.getParameter("totalClassesPlanned");
            s.setTotalClassesPlanned(planned != null && !planned.isEmpty() ? Integer.parseInt(planned) : 50);

            boolean ok = subjectDAO.updateSubject(s);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=Subject updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=Failed to update subject.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int subjectId = Integer.parseInt(req.getParameter("subjectId"));
            boolean ok = subjectDAO.deleteSubject(subjectId);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=Subject deleted successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=Failed to delete subject.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/subjects");
        }
    }
}
