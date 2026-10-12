package com.college.dao;

import com.college.model.User;
import com.college.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public User authenticate(String usernameOrEmail, String password) {
        String sql = "SELECT * FROM admins WHERE (username = ? OR email = ?) AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail.trim());
            ps.setString(2, usernameOrEmail.trim().toLowerCase());
            ps.setString(3, password.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("admin_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        "ADMIN",
                        rs.getString("username")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
