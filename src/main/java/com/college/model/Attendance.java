package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Attendance implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attendanceId;
    private int studentId;
    private String studentName;
    private String rollNo;
    private int subjectId;
    private String subjectName;
    private Date date;
    private String status; // "PRESENT", "ABSENT"
    private Integer markedBy;
    private String markedByName;
    private Timestamp markedAt;

    public Attendance() {}

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getRollNo() { return rollNo; }
    public void setRollNo(String rollNo) { this.rollNo = rollNo; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getMarkedBy() { return markedBy; }
    public void setMarkedBy(Integer markedBy) { this.markedBy = markedBy; }

    public String getMarkedByName() { return markedByName; }
    public void setMarkedByName(String markedByName) { this.markedByName = markedByName; }

    public Timestamp getMarkedAt() { return markedAt; }
    public void setMarkedAt(Timestamp markedAt) { this.markedAt = markedAt; }
}
