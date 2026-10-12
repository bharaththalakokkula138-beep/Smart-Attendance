package com.college.model;

import java.io.Serializable;

public class SubjectAttendanceSummary implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private String facultyName;
    private int classesConducted;
    private int classesAttended;
    private int classesAbsent;
    private double attendancePercentage;
    private double requiredPercentage;
    private String status; // SAFE, WARNING, CRITICAL
    private String badgeClass; // badge-safe, badge-warning, badge-critical
    private int classesRequired; // consecutive classes to reach required %
    private int classesCanMiss; // classes that can be missed while remaining >= required %

    public SubjectAttendanceSummary() {}

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }

    public int getClassesConducted() { return classesConducted; }
    public void setClassesConducted(int classesConducted) { this.classesConducted = classesConducted; }

    public int getClassesAttended() { return classesAttended; }
    public void setClassesAttended(int classesAttended) { this.classesAttended = classesAttended; }

    public int getClassesAbsent() { return classesAbsent; }
    public void setClassesAbsent(int classesAbsent) { this.classesAbsent = classesAbsent; }

    public double getAttendancePercentage() { return attendancePercentage; }
    public void setAttendancePercentage(double attendancePercentage) { this.attendancePercentage = attendancePercentage; }

    public double getRequiredPercentage() { return requiredPercentage; }
    public void setRequiredPercentage(double requiredPercentage) { this.requiredPercentage = requiredPercentage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBadgeClass() { return badgeClass; }
    public void setBadgeClass(String badgeClass) { this.badgeClass = badgeClass; }

    public int getClassesRequired() { return classesRequired; }
    public void setClassesRequired(int classesRequired) { this.classesRequired = classesRequired; }

    public int getClassesCanMiss() { return classesCanMiss; }
    public void setClassesCanMiss(int classesCanMiss) { this.classesCanMiss = classesCanMiss; }
}
