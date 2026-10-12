package com.college.dao;

import com.college.model.Subject;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.*, d.department_name, f.name AS faculty_name FROM subjects s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id " +
                     "ORDER BY s.subject_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapSubject(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Subject getSubjectById(int subjectId) {
        String sql = "SELECT s.*, d.department_name, f.name AS faculty_name FROM subjects s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id " +
                     "WHERE s.subject_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSubject(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Subject> getSubjectsByFaculty(int facultyId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.*, d.department_name, f.name AS faculty_name FROM subjects s " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id " +
                     "WHERE s.faculty_id = ? " +
                     "ORDER BY s.subject_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubject(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Subject> getSubjectsByStudent(int studentId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.*, d.department_name, f.name AS faculty_name FROM subjects s " +
                     "JOIN students st ON s.department_id = st.department_id AND s.semester = st.semester " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id " +
                     "WHERE st.student_id = ? " +
                     "ORDER BY s.subject_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubject(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addSubject(Subject subject) {
        String sql = "INSERT INTO subjects (subject_code, subject_name, department_id, semester, faculty_id, total_classes_planned) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subject.getSubjectCode().trim().toUpperCase());
            ps.setString(2, subject.getSubjectName().trim());
            ps.setInt(3, subject.getDepartmentId());
            ps.setInt(4, subject.getSemester());
            if (subject.getFacultyId() != null && subject.getFacultyId() > 0) {
                ps.setInt(5, subject.getFacultyId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, subject.getTotalClassesPlanned() > 0 ? subject.getTotalClassesPlanned() : 50);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSubject(Subject subject) {
        String sql = "UPDATE subjects SET subject_code = ?, subject_name = ?, department_id = ?, semester = ?, faculty_id = ?, total_classes_planned = ? " +
                     "WHERE subject_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subject.getSubjectCode().trim().toUpperCase());
            ps.setString(2, subject.getSubjectName().trim());
            ps.setInt(3, subject.getDepartmentId());
            ps.setInt(4, subject.getSemester());
            if (subject.getFacultyId() != null && subject.getFacultyId() > 0) {
                ps.setInt(5, subject.getFacultyId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, subject.getTotalClassesPlanned() > 0 ? subject.getTotalClassesPlanned() : 50);
            ps.setInt(7, subject.getSubjectId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSubject(int subjectId) {
        String sql = "DELETE FROM subjects WHERE subject_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countSubjects() {
        String sql = "SELECT COUNT(*) FROM subjects";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Subject mapSubject(ResultSet rs) throws SQLException {
        Subject s = new Subject();
        s.setSubjectId(rs.getInt("subject_id"));
        s.setSubjectCode(rs.getString("subject_code"));
        s.setSubjectName(rs.getString("subject_name"));
        s.setDepartmentId(rs.getInt("department_id"));
        s.setDepartmentName(rs.getString("department_name"));
        s.setSemester(rs.getInt("semester"));
        int fId = rs.getInt("faculty_id");
        if (!rs.wasNull()) {
            s.setFacultyId(fId);
        }
        s.setFacultyName(rs.getString("faculty_name"));
        s.setTotalClassesPlanned(rs.getInt("total_classes_planned"));
        return s;
    }
}
