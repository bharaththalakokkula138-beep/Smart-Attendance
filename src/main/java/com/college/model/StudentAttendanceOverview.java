package com.college.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class StudentAttendanceOverview implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private String rollNo;
    private String name;
    private String departmentName;
    private int semester;
    private int totalSubjects;
    private int totalConducted;
    private int totalAttended;
    private int totalAbsent;
    private double overallPercentage;
    private double requiredPercentage;
    private String overallStatus; // SAFE, WARNING, CRITICAL
    private String overallBadgeClass;
    private int subjectsBelowRequired;
    private String riskLevel; // LOW, MEDIUM, HIGH
    private String riskBadgeClass;
    private List<SubjectAttendanceSummary> subjectSummaries = new ArrayList<>();

    public StudentAttendanceOverview() {}

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getRollNo() { return rollNo; }
    public void setRollNo(String rollNo) { this.rollNo = rollNo; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public int getTotalSubjects() { return totalSubjects; }
    public void setTotalSubjects(int totalSubjects) { this.totalSubjects = totalSubjects; }

    public int getTotalConducted() { return totalConducted; }
    public void setTotalConducted(int totalConducted) { this.totalConducted = totalConducted; }

    public int getTotalAttended() { return totalAttended; }
    public void setTotalAttended(int totalAttended) { this.totalAttended = totalAttended; }

    public int getTotalAbsent() { return totalAbsent; }
    public void setTotalAbsent(int totalAbsent) { this.totalAbsent = totalAbsent; }

    public double getOverallPercentage() { return overallPercentage; }
    public void setOverallPercentage(double overallPercentage) { this.overallPercentage = overallPercentage; }

    public double getRequiredPercentage() { return requiredPercentage; }
    public void setRequiredPercentage(double requiredPercentage) { this.requiredPercentage = requiredPercentage; }

    public String getOverallStatus() { return overallStatus; }
    public void setOverallStatus(String overallStatus) { this.overallStatus = overallStatus; }

    public String getOverallBadgeClass() { return overallBadgeClass; }
    public void setOverallBadgeClass(String overallBadgeClass) { this.overallBadgeClass = overallBadgeClass; }

    public int getSubjectsBelowRequired() { return subjectsBelowRequired; }
    public void setSubjectsBelowRequired(int subjectsBelowRequired) { this.subjectsBelowRequired = subjectsBelowRequired; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getRiskBadgeClass() { return riskBadgeClass; }
    public void setRiskBadgeClass(String riskBadgeClass) { this.riskBadgeClass = riskBadgeClass; }

    public List<SubjectAttendanceSummary> getSubjectSummaries() { return subjectSummaries; }
    public void setSubjectSummaries(List<SubjectAttendanceSummary> subjectSummaries) { this.subjectSummaries = subjectSummaries; }
}
