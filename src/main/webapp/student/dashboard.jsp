<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Student Dashboard");
    request.setAttribute("pageSubtitle", "Attendance Overview & Academic Status");
    StudentAttendanceOverview overview = (StudentAttendanceOverview) request.getAttribute("overview");
    List<Attendance> recentList = (List<Attendance>) request.getAttribute("recentAttendance");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Smart Attendance</title>
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
            <% if (overview != null) { %>
            <!-- Student Header Profile Banner -->
            <div class="card-modern mb-4" style="background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); color: white; border: none;">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center gap-3">
                            <div class="user-avatar" style="width: 60px; height: 60px; font-size: 24px; background: rgba(255,255,255,0.2);">
                                <%= overview.getName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <h2 class="h4 fw-bold mb-1" style="color: white;"><%= overview.getName() %></h2>
                                <div class="d-flex flex-wrap gap-3 small text-light opacity-75">
                                    <span><i class="fa-solid fa-id-card me-1"></i> Roll No: <strong><%= overview.getRollNo() %></strong></span>
                                    <span><i class="fa-solid fa-building-columns me-1"></i> Dept: <strong><%= overview.getDepartmentName() %></strong></span>
                                    <span><i class="fa-solid fa-layer-group me-1"></i> Semester: <strong><%= overview.getSemester() %></strong></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-md-end mt-3 mt-md-0">
                        <span class="badge-status <%= overview.getRiskBadgeClass() %> p-2 px-3 fs-6">
                            <i class="fa-solid fa-shield-halved me-1"></i> Risk Level: <%= overview.getRiskLevel() %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Stats Metric Cards Grid -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card <%= overview.getOverallStatus().toLowerCase() %>">
                        <div class="stat-icon <%= overview.getOverallStatus().toLowerCase() %>">
                            <i class="fa-solid fa-percent"></i>
                        </div>
                        <div>
                            <div class="stat-label">Overall Attendance</div>
                            <div class="stat-value"><%= overview.getOverallPercentage() %>%</div>
                            <div class="stat-subtext">Required: <strong><%= overview.getRequiredPercentage() %>%</strong></div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card primary">
                        <div class="stat-icon primary">
                            <i class="fa-solid fa-book-bookmark"></i>
                        </div>
                        <div>
                            <div class="stat-label">Enrolled Subjects</div>
                            <div class="stat-value"><%= overview.getTotalSubjects() %></div>
                            <div class="stat-subtext">Classes Held: <strong><%= overview.getTotalConducted() %></strong></div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card <%= overview.getSubjectsBelowRequired() > 0 ? "critical" : "safe" %>">
                        <div class="stat-icon <%= overview.getSubjectsBelowRequired() > 0 ? "critical" : "safe" %>">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                        <div>
                            <div class="stat-label">Below Threshold</div>
                            <div class="stat-value"><%= overview.getSubjectsBelowRequired() %></div>
                            <div class="stat-subtext">Subjects below <%= overview.getRequiredPercentage() %>%</div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card safe">
                        <div class="stat-icon safe">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="stat-label">Classes Attended</div>
                            <div class="stat-value"><%= overview.getTotalAttended() %> / <%= overview.getTotalConducted() %></div>
                            <div class="stat-subtext">Absences: <strong><%= overview.getTotalAbsent() %></strong></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Subject-Wise Attendance Breakdown Table -->
                <div class="col-lg-8">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-list-check text-primary"></i> Subject-Wise Status</h2>
                            <a href="${pageContext.request.contextPath}/student/attendance" class="btn btn-sm btn-link text-decoration-none">View Details <i class="fa-solid fa-arrow-right"></i></a>
                        </div>

                        <div class="table-responsive-clean">
                            <table class="table-modern">
                                <thead>
                                    <tr>
                                        <th>Subject</th>
                                        <th>Faculty</th>
                                        <th>Conducted</th>
                                        <th>Attended</th>
                                        <th>Attendance %</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (SubjectAttendanceSummary s : overview.getSubjectSummaries()) { %>
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark"><%= s.getSubjectName() %></div>
                                            <div class="small text-muted"><%= s.getSubjectCode() %></div>
                                        </td>
                                        <td class="text-secondary small"><%= s.getFacultyName() %></td>
                                        <td class="fw-semibold"><%= s.getClassesConducted() %></td>
                                        <td class="fw-semibold text-success"><%= s.getClassesAttended() %></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="fw-bold"><%= s.getAttendancePercentage() %>%</span>
                                            </div>
                                            <div class="progress-container mt-1" style="height: 6px;">
                                                <div class="progress-bar-fill progress-<%= s.getStatus().toLowerCase() %>" style="width: <%= Math.min(100.0, s.getAttendancePercentage()) %>%;"></div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge-status <%= s.getBadgeClass() %>">
                                                <%= s.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Quick Predictor Action Tools -->
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="card-modern p-3" style="border-left: 4px solid var(--primary);">
                                <h3 class="h6 fw-bold mb-1"><i class="fa-solid fa-calculator text-primary me-2"></i> Shortage Calculator</h3>
                                <p class="small text-muted mb-3">Calculate exact consecutive classes needed to cross the 75% boundary.</p>
                                <a href="${pageContext.request.contextPath}/student/shortage-calculator" class="btn btn-primary-modern btn-sm">Launch Calculator</a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card-modern p-3" style="border-left: 4px solid var(--success);">
                                <h3 class="h6 fw-bold mb-1"><i class="fa-solid fa-calendar-check text-success me-2"></i> Can I Take Leave?</h3>
                                <p class="small text-muted mb-3">Simulate future absences and predict safe attendance margins instantly.</p>
                                <a href="${pageContext.request.contextPath}/student/leave-calculator" class="btn btn-secondary-modern btn-sm">Simulate Leave</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Attendance Activity & Quick Alerts -->
                <div class="col-lg-4">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-clock-rotate-left text-primary"></i> Recent Classes</h2>
                        </div>
                        <% if (recentList != null && !recentList.isEmpty()) { %>
                            <div class="d-flex flex-column gap-2">
                                <% for (Attendance a : recentList) { %>
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-2 border" style="background: #fafafa;">
                                    <div>
                                        <div class="fw-semibold small"><%= a.getSubjectName() %></div>
                                        <div class="text-muted" style="font-size: 11px;"><%= a.getDate() %></div>
                                    </div>
                                    <span class="badge-status <%= "PRESENT".equalsIgnoreCase(a.getStatus()) ? "badge-safe" : "badge-critical" %>" style="padding: 3px 8px; font-size: 11px;">
                                        <%= a.getStatus() %>
                                    </span>
                                </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="text-muted small text-center py-4">No recent attendance records.</div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
