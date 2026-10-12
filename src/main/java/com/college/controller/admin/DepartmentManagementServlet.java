package com.college.controller.admin;

import com.college.dao.DepartmentDAO;
import com.college.model.Department;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DepartmentManagementServlet", urlPatterns = {"/admin/departments"})
public class DepartmentManagementServlet extends HttpServlet {

    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Department> departments = departmentDAO.getAllDepartments();
        req.setAttribute("departments", departments);

        req.getRequestDispatcher("/admin/departments.jsp").forward(req, resp);
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
            Department d = new Department();
            d.setDepartmentCode(req.getParameter("departmentCode"));
            d.setDepartmentName(req.getParameter("departmentName"));

            boolean ok = departmentDAO.addDepartment(d);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?msg=Department added successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?error=Failed to add department. Code might exist.");
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            Department d = new Department();
            d.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            d.setDepartmentCode(req.getParameter("departmentCode"));
            d.setDepartmentName(req.getParameter("departmentName"));

            boolean ok = departmentDAO.updateDepartment(d);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?msg=Department updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?error=Failed to update department.");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int deptId = Integer.parseInt(req.getParameter("departmentId"));
            boolean ok = departmentDAO.deleteDepartment(deptId);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?msg=Department deleted successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/departments?error=Failed to delete department. Remove associated students and subjects first.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/departments");
        }
    }
}
