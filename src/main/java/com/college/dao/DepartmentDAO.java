package com.college.dao;

import com.college.model.Department;
import com.college.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getInt("department_id"));
                dept.setDepartmentCode(rs.getString("department_code"));
                dept.setDepartmentName(rs.getString("department_name"));
                list.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Department getDepartmentById(int id) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Department dept = new Department();
                    dept.setDepartmentId(rs.getInt("department_id"));
                    dept.setDepartmentCode(rs.getString("department_code"));
                    dept.setDepartmentName(rs.getString("department_name"));
                    return dept;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addDepartment(Department dept) {
        String sql = "INSERT INTO departments (department_code, department_name) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getDepartmentCode().trim().toUpperCase());
            ps.setString(2, dept.getDepartmentName().trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDepartment(Department dept) {
        String sql = "UPDATE departments SET department_code = ?, department_name = ? WHERE department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dept.getDepartmentCode().trim().toUpperCase());
            ps.setString(2, dept.getDepartmentName().trim());
            ps.setInt(3, dept.getDepartmentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteDepartment(int departmentId) {
        String sql = "DELETE FROM departments WHERE department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
