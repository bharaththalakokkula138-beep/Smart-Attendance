package com.college.model;

import java.io.Serializable;

public class Faculty implements Serializable {
    private static final long serialVersionUID = 1L;

    private int facultyId;
    private String facultyCode;
    private String name;
    private String email;
    private String password;
    private int departmentId;
    private String departmentName;
    private String phone;
    private String designation;

    public Faculty() {}

    public int getFacultyId() { return facultyId; }
    public void setFacultyId(int facultyId) { this.facultyId = facultyId; }

    public String getFacultyCode() { return facultyCode; }
    public void setFacultyCode(String facultyCode) { this.facultyCode = facultyCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }
}
