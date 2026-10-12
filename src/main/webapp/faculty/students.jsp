<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Student Shortage Roster");
    request.setAttribute("pageSubtitle", "Student-Level Shortage Analysis, Defaulters & Required Attendance Tracking");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    Integer selectedSubjId = (Integer) request.getAttribute("selectedSubjectId");
    String selectedFilter = (String) request.getAttribute("selectedFilter");
    String searchQuery = (String) request.getAttribute("searchQuery");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");
    int totalCount = request.getAttribute("totalCount") != null ? (Integer) request.getAttribute("totalCount") : 0;
    int safeCount = request.getAttribute("safeCount") != null ? (Integer) request.getAttribute("safeCount") : 0;
    int warningCount = request.getAttribute("warningCount") != null ? (Integer) request.getAttribute("warningCount") : 0;
    int criticalCount = request.getAttribute("criticalCount") != null ? (Integer) request.getAttribute("criticalCount") : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Roster & Shortage - Smart Attendance</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

<div class="app-container">
    <jsp:include page="/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/common/topbar.jsp" />

        <main class="content-body">
            <!-- Filter Bar & Subject Switcher -->
            <div class="card-modern mb-4">
                <form action="${pageContext.request.contextPath}/faculty/students" method="GET" class="row g-3 align-items-end" id="rosterForm">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Course / Subject</label>
                        <select name="subjectId" class="form-select form-control-modern" onchange="document.getElementById('rosterForm').submit()">
                            <% if (subjects != null) {
                                for (Subject s : subjects) { %>
                                <option value="<%= s.getSubjectId() %>" <%= (selectedSubjId != null && selectedSubjId == s.getSubjectId()) ? "selected" : "" %>>
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %>
                                </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-secondary">Attendance Status Filter</label>
                        <select name="filter" id="filterSelect" class="form-select form-control-modern" onchange="document.getElementById('rosterForm').submit()">
                            <option value="ALL" <%= "ALL".equalsIgnoreCase(selectedFilter) ? "selected" : "" %>>All Students</option>
                            <option value="SAFE" <%= "SAFE".equalsIgnoreCase(selectedFilter) ? "selected" : "" %>>Safe (&gt;= 75%)</option>
                            <option value="WARNING" <%= "WARNING".equalsIgnoreCase(selectedFilter) ? "selected" : "" %>>Warning (70% - 75%)</option>
                            <option value="CRITICAL" <%= "CRITICAL".equalsIgnoreCase(selectedFilter) ? "selected" : "" %>>Critical (&lt; 70%)</option>
                            <option value="BELOW_75" <%= "BELOW_75".equalsIgnoreCase(selectedFilter) ? "selected" : "" %>>All Below 75% (Shortage)</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-secondary">Search Student</label>
                        <input type="text" name="search" id="rosterSearch" class="form-control form-control-modern" placeholder="Search by name or roll..." value="<%= searchQuery %>">
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="btn btn-secondary-modern w-100 justify-content-center">
                            <i class="fa-solid fa-filter me-1"></i> Apply
                        </button>
                    </div>
                </form>
            </div>

            <!-- Student Roster Table -->
            <div class="card-modern">
                <div class="card-header-clean">
                    <div>
                        <h2><i class="fa-solid fa-users text-primary"></i> Enrolled Students</h2>
                        <div class="small text-muted">Showing <strong><%= totalCount %></strong> student(s) | Safe: <strong class="text-success"><%= safeCount %></strong>, Warning: <strong class="text-warning"><%= warningCount %></strong>, Critical: <strong class="text-danger"><%= criticalCount %></strong></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/reports?type=faculty&subjectId=<%= selectedSubjId %>" target="_blank" class="btn btn-sm btn-outline-secondary">
                        <i class="fa-solid fa-print me-1"></i> Print Roster Sheet
                    </a>
                </div>

                <% if (students != null && !students.isEmpty()) { %>
                <div class="table-responsive-clean">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Roll No</th>
                                <th>Student Name</th>
                                <th>Conducted</th>
                                <th>Attended</th>
                                <th>Absent</th>
                                <th>Attendance %</th>
                                <th>Status</th>
                                <th>Classes Required (to 75%)</th>
                                <th>Buffer (Can Miss)</th>
                            </tr>
                        </thead>
                        <tbody id="studentTableBody">
                            <% for (Map<String, Object> st : students) {
                                double pct = (Double) st.get("percentage");
                                int reqClasses = (Integer) st.get("classesRequired");
                                int canMiss = (Integer) st.get("classesCanMiss");
                                String status = (String) st.get("status");
                                String badge = (String) st.get("badgeClass");
                            %>
                            <tr>
                                <td class="fw-bold"><%= st.get("rollNo") %></td>
                                <td>
                                    <div class="fw-semibold text-dark"><%= st.get("name") %></div>
                                    <div class="small text-muted" style="font-size: 11px;"><%= st.get("email") %></div>
                                </td>
                                <td class="fw-semibold"><%= st.get("conducted") %></td>
                                <td class="fw-semibold text-success"><%= st.get("attended") %></td>
                                <td class="fw-semibold text-danger"><%= st.get("absent") %></td>
                                <td>
                                    <div class="fw-bold"><%= pct %>%</div>
                                    <div class="progress-container mt-1" style="height: 5px; width: 100px;">
                                        <div class="progress-bar-fill progress-<%= status.toLowerCase() %>" style="width: <%= Math.min(100.0, pct) %>%;"></div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge-status <%= badge %>"><%= status %></span>
                                </td>
                                <td>
                                    <% if (reqClasses > 0) { %>
                                        <span class="text-danger fw-bold"><i class="fa-solid fa-circle-exclamation me-1"></i> <%= reqClasses %> classes</span>
                                    <% } else { %>
                                        <span class="text-success small fw-semibold"><i class="fa-solid fa-check me-1"></i> Target Met</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (canMiss > 0) { %>
                                        <span class="text-success fw-semibold"><%= canMiss %> class(es)</span>
                                    <% } else { %>
                                        <span class="text-muted small">0 (No buffer)</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">No students matching the criteria.</div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    setupTableFilter('rosterSearch', 'filterSelect', 'studentTableBody');
});
</script>

</body>
</html>
