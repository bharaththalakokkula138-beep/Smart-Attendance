<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Faculty Dashboard");
    request.setAttribute("pageSubtitle", "Course Management, Session Analytics & Class Shortage Overview");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");

    int totalStudentSubjects = stats != null && stats.get("totalStudentSubjects") != null ? (Integer) stats.get("totalStudentSubjects") : 0;
    int safeCount = stats != null && stats.get("safeCount") != null ? (Integer) stats.get("safeCount") : 0;
    int warningCount = stats != null && stats.get("warningCount") != null ? (Integer) stats.get("warningCount") : 0;
    int criticalCount = stats != null && stats.get("criticalCount") != null ? (Integer) stats.get("criticalCount") : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard - Smart Attendance</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

<div class="app-container">
    <jsp:include page="/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/common/topbar.jsp" />

        <main class="content-body">
            <!-- Faculty Stat Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card primary">
                        <div class="stat-icon primary"><i class="fa-solid fa-users"></i></div>
                        <div>
                            <div class="stat-label">Total Student Enrollments</div>
                            <div class="stat-value"><%= totalStudentSubjects %></div>
                            <div class="stat-subtext">Across assigned subjects</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card safe">
                        <div class="stat-icon safe"><i class="fa-solid fa-circle-check"></i></div>
                        <div>
                            <div class="stat-label">Safe Category</div>
                            <div class="stat-value text-success"><%= safeCount %></div>
                            <div class="stat-subtext">&gt;= <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>% Attendance</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card warning">
                        <div class="stat-icon warning"><i class="fa-solid fa-bell"></i></div>
                        <div>
                            <div class="stat-label">Warning Category</div>
                            <div class="stat-value text-warning"><%= warningCount %></div>
                            <div class="stat-subtext">Between 70% &amp; 75%</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card critical">
                        <div class="stat-icon critical"><i class="fa-solid fa-triangle-exclamation"></i></div>
                        <div>
                            <div class="stat-label">Critical Shortage</div>
                            <div class="stat-value text-danger"><%= criticalCount %></div>
                            <div class="stat-subtext">&lt; 70% Shortage Alert</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row 2: Assigned Subjects Table & Doughnut Chart -->
            <div class="row g-4 mb-4">
                <div class="col-lg-7">
                    <div class="card-modern h-100">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-book-bookmark text-primary"></i> Assigned Courses</h2>
                            <a href="${pageContext.request.contextPath}/faculty/attendance" class="btn btn-primary-modern btn-sm">
                                <i class="fa-solid fa-plus me-1"></i> Mark Attendance
                            </a>
                        </div>

                        <% if (subjects != null && !subjects.isEmpty()) { %>
                        <div class="table-responsive-clean">
                            <table class="table-modern">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Subject Name</th>
                                        <th>Dept / Sem</th>
                                        <th>Planned Classes</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Subject s : subjects) { %>
                                    <tr>
                                        <td class="fw-bold"><%= s.getSubjectCode() %></td>
                                        <td>
                                            <div class="fw-semibold text-dark"><%= s.getSubjectName() %></div>
                                        </td>
                                        <td class="small text-secondary"><%= s.getDepartmentName() %> (Sem <%= s.getSemester() %>)</td>
                                        <td class="fw-semibold"><%= s.getTotalClassesPlanned() %></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/faculty/attendance?subjectId=<%= s.getSubjectId() %>" class="btn btn-sm btn-outline-primary py-1 px-2 me-1" title="Mark Session">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/faculty/students?subjectId=<%= s.getSubjectId() %>" class="btn btn-sm btn-outline-secondary py-1 px-2" title="Student Roster">
                                                <i class="fa-solid fa-list-ol"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                            <div class="text-center py-4 text-muted">No courses assigned to your profile.</div>
                        <% } %>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="card-modern h-100">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-chart-pie text-primary"></i> Shortage Distribution</h2>
                        </div>
                        <div style="height: 260px; position: relative;">
                            <canvas id="facultyDistChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    renderDistributionDoughnut('facultyDistChart', <%= safeCount %>, <%= warningCount %>, <%= criticalCount %>);
});
</script>

</body>
</html>
