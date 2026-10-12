package com.college.dao;

import com.college.model.Student;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student authenticate(String identifier, String password) {
        String sql = "SELECT s.*, d.department_name FROM students s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE (s.email = ? OR s.roll_no = ?) AND s.password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier.trim().toLowerCase());
            ps.setString(2, identifier.trim().toUpperCase());
            ps.setString(3, password.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, d.department_name FROM students s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "ORDER BY s.roll_no ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStudent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Student getStudentById(int studentId) {
        String sql = "SELECT s.*, d.department_name FROM students s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Student> getStudentsBySubject(int subjectId) {
        // Enrolled students in the same department and semester as the subject
        String sql = "SELECT s.*, d.department_name FROM students s " +
                     "JOIN subjects sub ON s.department_id = sub.department_id AND s.semester = sub.semester " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE sub.subject_id = ? " +
                     "ORDER BY s.roll_no ASC";
        List<Student> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Student> searchStudents(String keyword) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, d.department_name FROM students s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.roll_no LIKE ? OR s.name LIKE ? OR s.email LIKE ? OR d.department_name LIKE ? " +
                     "ORDER BY s.roll_no ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword.trim() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (roll_no, name, email, password, department_id, semester, phone) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getRollNo().trim().toUpperCase());
            ps.setString(2, student.getName().trim());
            ps.setString(3, student.getEmail().trim().toLowerCase());
            ps.setString(4, student.getPassword().trim());
            ps.setInt(5, student.getDepartmentId());
            ps.setInt(6, student.getSemester());
            ps.setString(7, student.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStudent(Student student) {
        String sql;
        boolean updatePass = student.getPassword() != null && !student.getPassword().trim().isEmpty();
        if (updatePass) {
            sql = "UPDATE students SET roll_no = ?, name = ?, email = ?, password = ?, department_id = ?, semester = ?, phone = ? WHERE student_id = ?";
        } else {
            sql = "UPDATE students SET roll_no = ?, name = ?, email = ?, department_id = ?, semester = ?, phone = ? WHERE student_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, student.getRollNo().trim().toUpperCase());
            ps.setString(idx++, student.getName().trim());
            ps.setString(idx++, student.getEmail().trim().toLowerCase());
            if (updatePass) {
                ps.setString(idx++, student.getPassword().trim());
            }
            ps.setInt(idx++, student.getDepartmentId());
            ps.setInt(idx++, student.getSemester());
            ps.setString(idx++, student.getPhone());
            ps.setInt(idx++, student.getStudentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteStudent(int studentId) {
        String sql = "DELETE FROM students WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countStudents() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setRollNo(rs.getString("roll_no"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setDepartmentId(rs.getInt("department_id"));
        s.setDepartmentName(rs.getString("department_name"));
        s.setSemester(rs.getInt("semester"));
        s.setPhone(rs.getString("phone"));
        return s;
    }
}
