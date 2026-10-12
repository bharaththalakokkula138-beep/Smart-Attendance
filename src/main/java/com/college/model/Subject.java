package com.college.model;

import java.io.Serializable;

public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int departmentId;
    private String departmentName;
    private int semester;
    private Integer facultyId;
    private String facultyName;
    private int totalClassesPlanned;

    public Subject() {}

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public Integer getFacultyId() { return facultyId; }
    public void setFacultyId(Integer facultyId) { this.facultyId = facultyId; }

    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }

    public int getTotalClassesPlanned() { return totalClassesPlanned; }
    public void setTotalClassesPlanned(int totalClassesPlanned) { this.totalClassesPlanned = totalClassesPlanned; }
}
