package com.college.model;

import java.io.Serializable;

public class Department implements Serializable {
    private static final long serialVersionUID = 1L;

    private int departmentId;
    private String departmentCode;
    private String departmentName;

    public Department() {}

    public Department(int departmentId, String departmentCode, String departmentName) {
        this.departmentId = departmentId;
        this.departmentCode = departmentCode;
        this.departmentName = departmentName;
    }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentCode() { return departmentCode; }
    public void setDepartmentCode(String departmentCode) { this.departmentCode = departmentCode; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
}
