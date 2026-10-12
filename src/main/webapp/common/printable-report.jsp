<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List, java.util.Map" %>
<%
    String reportType = (String) request.getAttribute("reportType");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");
    String currentDate = (String) request.getAttribute("currentDate");
    StudentAttendanceOverview overview = (StudentAttendanceOverview) request.getAttribute("overview");
    Subject currentSubject = (Subject) request.getAttribute("currentSubject");
    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    Map<String, Object> adminStats = (Map<String, Object>) request.getAttribute("stats");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Official Attendance Report - College Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/print.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', Arial, sans-serif;
            background: #f8fafc;
            padding: 30px;
            color: #0f172a;
        }
        .report-page {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        .header-seal {
            border-bottom: 2px solid #0f172a;
            padding-bottom: 16px;
            margin-bottom: 24px;
            text-align: center;
        }
        @media print {
            body { padding: 0; background: white; }
            .report-page { box-shadow: none; border: none; padding: 20px; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

<div class="report-page">
    <div class="d-flex justify-content-between align-items-center mb-3 no-print">
        <a href="javascript:history.back()" class="btn btn-sm btn-outline-secondary">&larr; Back to Dashboard</a>
        <button onclick="window.print()" class="btn btn-sm btn-primary">Print Statement</button>
    </div>

    <!-- Official Seal -->
    <div class="header-seal">
        <h2 class="h4 fw-bold text-uppercase mb-1">College of Engineering &amp; Technology</h2>
        <h3 class="h6 text-secondary text-uppercase mb-1">Office of the Academic Registrar &amp; Controller of Examinations</h3>
        <div class="badge bg-dark px-3 py-2 text-white">OFFICIAL ATTENDANCE PROGRESS &amp; SHORTAGE STATEMENT</div>
        <div class="small text-muted mt-2">Issued on: <strong><%= currentDate %></strong> | Rule Standard: <strong><%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%</strong></div>
    </div>

    <% if ("student".equalsIgnoreCase(reportType) && overview != null) { %>
        <!-- Student Official Sheet -->
        <div class="row g-2 mb-4 p-3 bg-light rounded-2 small">
            <div class="col-6"><strong>Student Name:</strong> <%= overview.getName() %></div>
            <div class="col-6"><strong>Roll Number:</strong> <%= overview.getRollNo() %></div>
            <div class="col-6"><strong>Department:</strong> <%= overview.getDepartmentName() %></div>
            <div class="col-6"><strong>Semester:</strong> <%= overview.getSemester() %></div>
            <div class="col-6"><strong>Total Subjects:</strong> <%= overview.getTotalSubjects() %></div>
            <div class="col-6"><strong>Overall Attendance:</strong> <span class="fw-bold"><%= overview.getOverallPercentage() %>%</span> (<%= overview.getOverallStatus() %>)</div>
        </div>

        <table class="table table-bordered table-sm align-middle mb-4">
            <thead class="table-dark">
                <tr>
                    <th>Subject Code</th>
                    <th>Course Name</th>
                    <th>Faculty</th>
                    <th class="text-center">Conducted</th>
                    <th class="text-center">Attended</th>
                    <th class="text-center">Attendance %</th>
                    <th class="text-center">Status</th>
                    <th class="text-center">Eligibility</th>
                </tr>
            </thead>
            <tbody>
                <% for (SubjectAttendanceSummary s : overview.getSubjectSummaries()) { %>
                <tr>
                    <td class="fw-bold"><%= s.getSubjectCode() %></td>
                    <td><%= s.getSubjectName() %></td>
                    <td class="small"><%= s.getFacultyName() %></td>
                    <td class="text-center"><%= s.getClassesConducted() %></td>
                    <td class="text-center fw-bold"><%= s.getClassesAttended() %></td>
                    <td class="text-center fw-bold"><%= s.getAttendancePercentage() %>%</td>
                    <td class="text-center"><%= s.getStatus() %></td>
                    <td class="text-center">
                        <% if (s.getAttendancePercentage() >= (rule != null ? rule.getMinimumPercentage() : 75.0)) { %>
                            <span class="text-success fw-bold">Eligible</span>
                        <% } else { %>
                            <span class="text-danger fw-bold">Shortage (<%= s.getClassesRequired() %> needed)</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else if ("faculty".equalsIgnoreCase(reportType) && students != null) { %>
        <!-- Faculty Course Sheet -->
        <div class="row g-2 mb-4 p-3 bg-light rounded-2 small">
            <div class="col-6"><strong>Course:</strong> <%= currentSubject != null ? currentSubject.getSubjectCode() + " - " + currentSubject.getSubjectName() : "" %></div>
            <div class="col-6"><strong>Department:</strong> <%= currentSubject != null ? currentSubject.getDepartmentName() : "" %></div>
            <div class="col-6"><strong>Faculty In-Charge:</strong> <%= currentSubject != null ? currentSubject.getFacultyName() : "" %></div>
            <div class="col-6"><strong>Total Students:</strong> <%= students.size() %></div>
        </div>

        <table class="table table-bordered table-sm align-middle mb-4">
            <thead class="table-dark">
                <tr>
                    <th>Roll No</th>
                    <th>Student Name</th>
                    <th class="text-center">Conducted</th>
                    <th class="text-center">Attended</th>
                    <th class="text-center">Absent</th>
                    <th class="text-center">Percentage</th>
                    <th class="text-center">Status</th>
                    <th class="text-center">Shortage Action</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> st : students) {
                    double pct = (Double) st.get("percentage");
                    int reqClasses = (Integer) st.get("classesRequired");
                %>
                <tr>
                    <td class="fw-bold"><%= st.get("rollNo") %></td>
                    <td><%= st.get("name") %></td>
                    <td class="text-center"><%= st.get("conducted") %></td>
                    <td class="text-center"><%= st.get("attended") %></td>
                    <td class="text-center"><%= st.get("absent") %></td>
                    <td class="text-center fw-bold"><%= pct %>%</td>
                    <td class="text-center"><%= st.get("status") %></td>
                    <td class="text-center">
                        <% if (reqClasses > 0) { %>
                            <span class="text-danger fw-bold">Needs <%= reqClasses %> classes</span>
                        <% } else { %>
                            <span class="text-success">Met Target</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else if ("admin".equalsIgnoreCase(reportType) && adminStats != null) { %>
        <!-- Admin College Sheet -->
        <div class="p-3 bg-light rounded-2 mb-4">
            <h4 class="h6 fw-bold mb-2">Institutional Attendance Distribution</h4>
            <div class="row text-center">
                <div class="col-4">Above 75%: <strong><%= adminStats.get("above75") %></strong></div>
                <div class="col-4">65% – 75%: <strong><%= adminStats.get("between65And75") %></strong></div>
                <div class="col-4">Below 65%: <strong><%= adminStats.get("below65") %></strong></div>
            </div>
        </div>
    <% } %>

    <!-- Signatures -->
    <div class="row mt-5 pt-4 text-center small text-secondary">
        <div class="col-4">
            <div class="border-top pt-2">Class Coordinator / Faculty</div>
        </div>
        <div class="col-4">
            <div class="border-top pt-2">Head of Department</div>
        </div>
        <div class="col-4">
            <div class="border-top pt-2">Controller of Examinations</div>
        </div>
    </div>
</div>

</body>
</html>
