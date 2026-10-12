package com.college.dao;

import com.college.model.Faculty;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {

    public Faculty authenticate(String email, String password) {
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "JOIN departments d ON f.department_id = d.department_id " +
                     "WHERE f.email = ? AND f.password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, password.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFaculty(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Faculty> getAllFaculty() {
        List<Faculty> list = new ArrayList<>();
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "JOIN departments d ON f.department_id = d.department_id " +
                     "ORDER BY f.faculty_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapFaculty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Faculty getFacultyById(int facultyId) {
        String sql = "SELECT f.*, d.department_name FROM faculty f " +
                     "JOIN departments d ON f.department_id = d.department_id " +
                     "WHERE f.faculty_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFaculty(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addFaculty(Faculty faculty) {
        String sql = "INSERT INTO faculty (faculty_code, name, email, password, department_id, phone, designation) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, faculty.getFacultyCode().trim());
            ps.setString(2, faculty.getName().trim());
            ps.setString(3, faculty.getEmail().trim().toLowerCase());
            ps.setString(4, faculty.getPassword().trim());
            ps.setInt(5, faculty.getDepartmentId());
            ps.setString(6, faculty.getPhone());
            ps.setString(7, faculty.getDesignation() != null ? faculty.getDesignation() : "Assistant Professor");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateFaculty(Faculty faculty) {
        String sql;
        boolean updatePass = faculty.getPassword() != null && !faculty.getPassword().trim().isEmpty();
        if (updatePass) {
            sql = "UPDATE faculty SET faculty_code = ?, name = ?, email = ?, password = ?, department_id = ?, phone = ?, designation = ? WHERE faculty_id = ?";
        } else {
            sql = "UPDATE faculty SET faculty_code = ?, name = ?, email = ?, department_id = ?, phone = ?, designation = ? WHERE faculty_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, faculty.getFacultyCode().trim());
            ps.setString(idx++, faculty.getName().trim());
            ps.setString(idx++, faculty.getEmail().trim().toLowerCase());
            if (updatePass) {
                ps.setString(idx++, faculty.getPassword().trim());
            }
            ps.setInt(idx++, faculty.getDepartmentId());
            ps.setString(idx++, faculty.getPhone());
            ps.setString(idx++, faculty.getDesignation());
            ps.setInt(idx++, faculty.getFacultyId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFaculty(int facultyId) {
        String sql = "DELETE FROM faculty WHERE faculty_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countFaculty() {
        String sql = "SELECT COUNT(*) FROM faculty";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Faculty mapFaculty(ResultSet rs) throws SQLException {
        Faculty f = new Faculty();
        f.setFacultyId(rs.getInt("faculty_id"));
        f.setFacultyCode(rs.getString("faculty_code"));
        f.setName(rs.getString("name"));
        f.setEmail(rs.getString("email"));
        f.setPassword(rs.getString("password"));
        f.setDepartmentId(rs.getInt("department_id"));
        f.setDepartmentName(rs.getString("department_name"));
        f.setPhone(rs.getString("phone"));
        f.setDesignation(rs.getString("designation"));
        return f;
    }
}
