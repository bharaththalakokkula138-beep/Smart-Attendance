<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Institutional Analytics");
    request.setAttribute("pageSubtitle", "College-Wide Attendance Monitoring, Departmental Benchmarks & Shortage Metrics");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer totalFaculty = (Integer) request.getAttribute("totalFaculty");
    Integer totalSubjects = (Integer) request.getAttribute("totalSubjects");
    Map<String, Object> adminStats = (Map<String, Object>) request.getAttribute("adminStats");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");

    int above75 = adminStats != null && adminStats.get("above75") != null ? (Integer) adminStats.get("above75") : 0;
    int between65And75 = adminStats != null && adminStats.get("between65And75") != null ? (Integer) adminStats.get("between65And75") : 0;
    int below65 = adminStats != null && adminStats.get("below65") != null ? (Integer) adminStats.get("below65") : 0;
    String deptAveragesJson = (String) request.getAttribute("deptAveragesJson");
    String subjAveragesJson = (String) request.getAttribute("subjAveragesJson");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Attendance</title>
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
            <!-- Row 1: Institutional Core Stats -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card primary">
                        <div class="stat-icon primary"><i class="fa-solid fa-user-graduate"></i></div>
                        <div>
                            <div class="stat-label">Total Registered Students</div>
                            <div class="stat-value"><%= totalStudents != null ? totalStudents : 0 %></div>
                            <div class="stat-subtext">Across all academic programs</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card safe">
                        <div class="stat-icon safe"><i class="fa-solid fa-chalkboard-user"></i></div>
                        <div>
                            <div class="stat-label">Total Faculty Staff</div>
                            <div class="stat-value"><%= totalFaculty != null ? totalFaculty : 0 %></div>
                            <div class="stat-subtext">Active teaching faculty</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card warning">
                        <div class="stat-icon warning"><i class="fa-solid fa-book"></i></div>
                        <div>
                            <div class="stat-label">Total Active Courses</div>
                            <div class="stat-value"><%= totalSubjects != null ? totalSubjects : 0 %></div>
                            <div class="stat-subtext">Semester subjects configured</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row 2: Attendance Shortage Distribution Bracket -->
            <div class="card-modern mb-4">
                <div class="card-header-clean">
                    <h2><i class="fa-solid fa-chart-simple text-primary"></i> Student Attendance Distribution Brackets</h2>
                    <span class="badge bg-light text-dark border">Rule Threshold: <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%</span>
                </div>

                <div class="row g-3 text-center">
                    <div class="col-md-4">
                        <div class="p-3 rounded-3" style="background: var(--success-light); border: 1px solid var(--success-border);">
                            <div class="text-success fw-bold fs-2"><%= above75 %></div>
                            <div class="fw-semibold text-dark">Above <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%</div>
                            <div class="small text-muted">Eligible for examinations (Safe zone)</div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="p-3 rounded-3" style="background: var(--warning-light); border: 1px solid var(--warning-border);">
                            <div class="text-warning fw-bold fs-2"><%= between65And75 %></div>
                            <div class="fw-semibold text-dark">Between 65% – 75%</div>
                            <div class="small text-muted">Condonation / Warning bracket</div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="p-3 rounded-3" style="background: var(--danger-light); border: 1px solid var(--danger-border);">
                            <div class="text-danger fw-bold fs-2"><%= below65 %></div>
                            <div class="fw-semibold text-dark">Below 65%</div>
                            <div class="small text-muted">Severe shortage / Ineligible</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row 3: Department-wise and Subject-wise Analytics Charts -->
            <div class="row g-4 mb-4">
                <div class="col-lg-6">
                    <div class="card-modern h-100">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-building-columns text-primary"></i> Department-Wise Attendance</h2>
                        </div>
                        <div style="height: 300px; position: relative;">
                            <canvas id="deptChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card-modern h-100">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-chart-bar text-primary"></i> Subject-Wise Average Attendance</h2>
                        </div>
                        <div style="height: 300px; position: relative;">
                            <canvas id="subjectChart"></canvas>
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
    const deptData = <%= deptAveragesJson != null ? deptAveragesJson : "{}" %>;
    const deptLabels = Object.keys(deptData);
    const deptVals = Object.values(deptData);
    renderDepartmentBarChart('deptChart', deptLabels, deptVals);

    const subjData = <%= subjAveragesJson != null ? subjAveragesJson : "{}" %>;
    const subjLabels = Object.keys(subjData);
    const subjVals = Object.values(subjData);
    renderSubjectBarChart('subjectChart', subjLabels, subjVals, <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>);
});
</script>

</body>
</html>
