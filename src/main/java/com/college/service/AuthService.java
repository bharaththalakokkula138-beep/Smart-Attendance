package com.college.service;

import com.college.dao.AdminDAO;
import com.college.dao.FacultyDAO;
import com.college.dao.StudentDAO;
import com.college.model.Faculty;
import com.college.model.Student;
import com.college.model.User;

public class AuthService {

    private final StudentDAO studentDAO = new StudentDAO();
    private final FacultyDAO facultyDAO = new FacultyDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    public User login(String identifier, String password, String requestedRole) {
        if (identifier == null || password == null) return null;
        identifier = identifier.trim();
        password = password.trim();

        if (requestedRole != null && !requestedRole.isEmpty()) {
            switch (requestedRole.toUpperCase()) {
                case "ADMIN":
                    return adminDAO.authenticate(identifier, password);
                case "FACULTY":
                    Faculty f = facultyDAO.authenticate(identifier, password);
                    if (f != null) {
                        return new User(f.getFacultyId(), f.getName(), f.getEmail(), "FACULTY", f.getFacultyCode());
                    }
                    return null;
                case "STUDENT":
                    Student s = studentDAO.authenticate(identifier, password);
                    if (s != null) {
                        return new User(s.getStudentId(), s.getName(), s.getEmail(), "STUDENT", s.getRollNo());
                    }
                    return null;
            }
        }

        // Auto-detect role if not explicitly specified
        // 1. Try Admin
        User admin = adminDAO.authenticate(identifier, password);
        if (admin != null) return admin;

        // 2. Try Faculty
        Faculty faculty = facultyDAO.authenticate(identifier, password);
        if (faculty != null) {
            return new User(faculty.getFacultyId(), faculty.getName(), faculty.getEmail(), "FACULTY", faculty.getFacultyCode());
        }

        // 3. Try Student
        Student student = studentDAO.authenticate(identifier, password);
        if (student != null) {
            return new User(student.getStudentId(), student.getName(), student.getEmail(), "STUDENT", student.getRollNo());
        }

        return null;
    }
}
