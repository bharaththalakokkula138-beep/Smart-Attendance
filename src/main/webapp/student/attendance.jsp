<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Subject-Wise Attendance");
    request.setAttribute("pageSubtitle", "Detailed Academic Course Attendance & Shortage Analysis");
    StudentAttendanceOverview overview = (StudentAttendanceOverview) request.getAttribute("overview");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject-Wise Attendance - Smart Attendance</title>
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
            <!-- Header Summary Row -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h2 class="h4 fw-bold mb-1">Academic Subjects Overview</h2>
                    <p class="text-muted small mb-0">College Attendance Policy: Mandatory minimum <strong><%= overview != null ? overview.getRequiredPercentage() : 75.0 %>%</strong> per course</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/student/shortage-calculator" class="btn btn-primary-modern btn-sm">
                        <i class="fa-solid fa-calculator"></i> Shortage Calculator
                    </a>
                    <a href="${pageContext.request.contextPath}/student/leave-calculator" class="btn btn-secondary-modern btn-sm">
                        <i class="fa-solid fa-calendar-check"></i> Can I Take Leave?
                    </a>
                </div>
            </div>

            <!-- Subject Cards Grid View -->
            <% if (overview != null && overview.getSubjectSummaries() != null) { %>
            <div class="row g-4 mb-4">
                <% for (SubjectAttendanceSummary s : overview.getSubjectSummaries()) { %>
                <div class="col-md-6 col-xl-4">
                    <div class="card-modern h-100 position-relative" style="border-top: 4px solid <%= "SAFE".equalsIgnoreCase(s.getStatus()) ? "#10b981" : ("WARNING".equalsIgnoreCase(s.getStatus()) ? "#f59e0b" : "#ef4444") %>;">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <span class="badge bg-light text-dark border mb-1" style="font-size: 11px;"><%= s.getSubjectCode() %></span>
                                <h3 class="h5 fw-bold text-dark mb-0"><%= s.getSubjectName() %></h3>
                                <div class="small text-muted"><i class="fa-solid fa-chalkboard-user me-1"></i> <%= s.getFacultyName() %></div>
                            </div>
                            <span class="badge-status <%= s.getBadgeClass() %>">
                                <%= s.getStatus() %>
                            </span>
                        </div>

                        <!-- Big Percentage Metric -->
                        <div class="bg-light p-3 rounded-3 mb-3">
                            <div class="d-flex justify-content-between align-items-baseline mb-1">
                                <span class="text-secondary small fw-semibold">Current Attendance:</span>
                                <span class="fs-4 fw-bold <%= "SAFE".equalsIgnoreCase(s.getStatus()) ? "text-success" : ("WARNING".equalsIgnoreCase(s.getStatus()) ? "text-warning" : "text-danger") %>">
                                    <%= s.getAttendancePercentage() %>%
                                </span>
                            </div>
                            <div class="progress-container position-relative">
                                <div class="progress-bar-fill progress-<%= s.getStatus().toLowerCase() %>" style="width: <%= Math.min(100.0, s.getAttendancePercentage()) %>%;"></div>
                                <div class="progress-threshold-line" title="Mandatory <%= s.getRequiredPercentage() %>% Threshold"></div>
                            </div>
                            <div class="d-flex justify-content-between small text-muted mt-1" style="font-size: 11px;">
                                <span>0%</span>
                                <span class="fw-bold text-dark"><%= s.getRequiredPercentage() %>% Required</span>
                                <span>100%</span>
                            </div>
                        </div>

                        <!-- Class Breakdown Counts -->
                        <div class="row g-2 text-center small mb-3">
                            <div class="col-4">
                                <div class="p-2 border rounded-2 bg-white">
                                    <div class="text-muted" style="font-size: 11px;">Conducted</div>
                                    <div class="fw-bold text-dark fs-6"><%= s.getClassesConducted() %></div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-2 border rounded-2 bg-white">
                                    <div class="text-muted" style="font-size: 11px;">Attended</div>
                                    <div class="fw-bold text-success fs-6"><%= s.getClassesAttended() %></div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-2 border rounded-2 bg-white">
                                    <div class="text-muted" style="font-size: 11px;">Absent</div>
                                    <div class="fw-bold text-danger fs-6"><%= s.getClassesAbsent() %></div>
                                </div>
                            </div>
                        </div>

                        <!-- Dynamic Action Recommendation Callout -->
                        <div class="p-2 rounded-2 mt-auto" style="background: <%= "SAFE".equalsIgnoreCase(s.getStatus()) ? "#ecfdf5" : ("WARNING".equalsIgnoreCase(s.getStatus()) ? "#fffbeb" : "#fef2f2") %>; font-size: 12px;">
                            <% if (s.getAttendancePercentage() >= s.getRequiredPercentage()) { %>
                                <div class="text-success fw-semibold">
                                    <i class="fa-solid fa-circle-check me-1"></i> You can miss: <strong><%= s.getClassesCanMiss() %> more class<%= s.getClassesCanMiss() == 1 ? "" : "es" %></strong> while remaining above <%= s.getRequiredPercentage() %>%.
                                </div>
                            <% } else { %>
                                <div class="text-danger fw-semibold">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> You must attend the next <strong><%= s.getClassesRequired() %> consecutive class<%= s.getClassesRequired() == 1 ? "" : "es" %></strong> to reach <%= s.getRequiredPercentage() %>%.
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Master Table Representation -->
            <div class="card-modern">
                <div class="card-header-clean">
                    <h2><i class="fa-solid fa-table text-primary"></i> Comprehensive Subject Breakdown</h2>
                </div>
                <div class="table-responsive-clean">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Subject Code &amp; Name</th>
                                <th>Faculty In-Charge</th>
                                <th>Conducted</th>
                                <th>Attended</th>
                                <th>Absent</th>
                                <th>Attendance %</th>
                                <th>Required %</th>
                                <th>Status</th>
                                <th>Shortage / Buffer Action</th>
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
                                <td class="fw-semibold text-danger"><%= s.getClassesAbsent() %></td>
                                <td>
                                    <span class="fw-bold"><%= s.getAttendancePercentage() %>%</span>
                                </td>
                                <td class="text-muted"><%= s.getRequiredPercentage() %>%</td>
                                <td>
                                    <span class="badge-status <%= s.getBadgeClass() %>"><%= s.getStatus() %></span>
                                </td>
                                <td>
                                    <% if (s.getAttendancePercentage() >= s.getRequiredPercentage()) { %>
                                        <span class="text-success small fw-semibold">Can miss <strong><%= s.getClassesCanMiss() %></strong> class(es)</span>
                                    <% } else { %>
                                        <span class="text-danger small fw-semibold">Must attend <strong><%= s.getClassesRequired() %></strong> consecutively</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
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
