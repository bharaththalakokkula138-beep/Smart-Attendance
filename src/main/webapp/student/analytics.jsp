<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.Map, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Trend & Attendance Risk AI");
    request.setAttribute("pageSubtitle", "Predictive Analytics, Temporal Progression & Intelligent Risk Classification");
    StudentAttendanceOverview overview = (StudentAttendanceOverview) request.getAttribute("overview");
    Map<Integer, RiskPrediction> subjectRiskMap = (Map<Integer, RiskPrediction>) request.getAttribute("subjectRiskMap");
    String monthlyTrendJson = (String) request.getAttribute("monthlyTrendJson");
    String cumulativeTrendJson = (String) request.getAttribute("cumulativeTrendJson");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trend & Risk AI - Smart Attendance</title>
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
            <!-- Attendance Trend Graph Section -->
            <div class="card-modern mb-4">
                <div class="card-header-clean">
                    <div>
                        <h2><i class="fa-solid fa-chart-line text-primary"></i> Attendance Progression Trend</h2>
                        <p class="text-muted small mb-0 mt-1">Chronological attendance trajectory against the mandatory <strong><%= overview != null ? overview.getRequiredPercentage() : 75.0 %>%</strong> baseline threshold</p>
                    </div>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 fw-semibold">
                        <i class="fa-solid fa-signal me-1"></i> Semester Timeline
                    </span>
                </div>

                <div style="height: 340px; position: relative;">
                    <canvas id="studentTrendChart"></canvas>
                </div>
            </div>

            <!-- Attendance Risk Prediction Section -->
            <div class="card-header-clean mt-4 mb-3 border-0 pb-0">
                <div>
                    <h2 class="h4 fw-bold mb-1"><i class="fa-solid fa-brain text-primary me-2"></i> Attendance Risk Prediction Engine</h2>
                    <p class="text-muted small mb-0">Multi-factor intelligent diagnostic analysis evaluating current pace, recent absence velocity, and semester recovery runway</p>
                </div>
            </div>

            <% if (overview != null && overview.getSubjectSummaries() != null) { %>
            <div class="row g-4">
                <% for (SubjectAttendanceSummary s : overview.getSubjectSummaries()) {
                    RiskPrediction pred = subjectRiskMap != null ? subjectRiskMap.get(s.getSubjectId()) : null;
                %>
                <div class="col-lg-6">
                    <div class="card-modern h-100" style="border-left: 5px solid <%= pred != null ? pred.getRiskColor() : "#6366f1" %>;">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <span class="badge bg-light text-dark border mb-1" style="font-size: 11px;"><%= s.getSubjectCode() %></span>
                                <h3 class="h5 fw-bold text-dark mb-0"><%= s.getSubjectName() %></h3>
                                <div class="small text-muted"><%= s.getFacultyName() %></div>
                            </div>
                            <% if (pred != null) { %>
                                <span class="badge-status <%= pred.getRiskBadgeClass() %> fs-6 px-3 py-1">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> <%= pred.getRiskLevel() %>
                                </span>
                            <% } %>
                        </div>

                        <!-- Metrics Snapshot -->
                        <div class="row g-2 text-center small mb-3">
                            <div class="col-3">
                                <div class="p-2 border rounded-2 bg-light">
                                    <div class="text-muted" style="font-size: 10px;">Current %</div>
                                    <div class="fw-bold fs-6"><%= s.getAttendancePercentage() %>%</div>
                                </div>
                            </div>
                            <div class="col-3">
                                <div class="p-2 border rounded-2 bg-light">
                                    <div class="text-muted" style="font-size: 10px;">Classes Left</div>
                                    <div class="fw-bold fs-6 text-primary">~<%= pred != null ? pred.getEstimatedRemainingClasses() : 10 %></div>
                                </div>
                            </div>
                            <div class="col-3">
                                <div class="p-2 border rounded-2 bg-light">
                                    <div class="text-muted" style="font-size: 10px;">Recent Absence</div>
                                    <div class="fw-bold fs-6 text-warning"><%= pred != null ? pred.getRecentAbsenceRate() : 0 %>%</div>
                                </div>
                            </div>
                            <div class="col-3">
                                <div class="p-2 border rounded-2 bg-light">
                                    <div class="text-muted" style="font-size: 10px;">Max Attainable</div>
                                    <div class="fw-bold fs-6 text-success"><%= pred != null ? pred.getMaxPossiblePercentage() : 100 %>%</div>
                                </div>
                            </div>
                        </div>

                        <!-- Diagnostic Reasons -->
                        <div class="mb-3">
                            <div class="small fw-bold text-secondary text-uppercase mb-2" style="font-size: 11px; letter-spacing: 0.5px;">
                                <i class="fa-solid fa-magnifying-glass-chart me-1"></i> Diagnostic Assessment:
                            </div>
                            <ul class="list-unstyled mb-0 small">
                                <% if (pred != null && pred.getReasons() != null) {
                                    for (String reason : pred.getReasons()) { %>
                                    <li class="d-flex align-items-baseline gap-2 mb-1 text-secondary">
                                        <i class="fa-solid fa-circle text-primary" style="font-size: 6px;"></i>
                                        <span><%= reason %></span>
                                    </li>
                                <%  }
                                } %>
                            </ul>
                        </div>

                        <!-- Action Recommendation Box -->
                        <div class="p-3 rounded-2 mt-auto" style="background: <%= pred != null && "HIGH RISK".equalsIgnoreCase(pred.getRiskLevel()) ? "#fef2f2" : (pred != null && "MEDIUM RISK".equalsIgnoreCase(pred.getRiskLevel()) ? "#fffbeb" : "#ecfdf5") %>; border: 1px solid <%= pred != null && "HIGH RISK".equalsIgnoreCase(pred.getRiskLevel()) ? "#fecaca" : (pred != null && "MEDIUM RISK".equalsIgnoreCase(pred.getRiskLevel()) ? "#fde68a" : "#a7f3d0") %>;">
                            <div class="small fw-bold text-uppercase mb-1" style="font-size: 11px; color: <%= pred != null ? pred.getRiskColor() : "#10b981" %>;">
                                <i class="fa-solid fa-lightbulb me-1"></i> Personalized Action Plan:
                            </div>
                            <div class="small fw-medium" style="color: #1e293b;">
                                <%= pred != null ? pred.getRecommendation() : "Maintain your regular schedule." %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const rawTrend = <%= monthlyTrendJson != null ? monthlyTrendJson : "{}" %>;
    const labels = Object.keys(rawTrend);
    const values = Object.values(rawTrend);

    // Fallback or full semester month progression
    const finalLabels = labels.length > 0 ? labels : ['August 2026', 'September 2026', 'October 2026'];
    const finalValues = values.length > 0 ? values : [82.0, 79.5, <%= overview != null ? overview.getOverallPercentage() : 77.5 %>];

    renderStudentAttendanceTrendChart('studentTrendChart', finalLabels, finalValues, <%= overview != null ? overview.getRequiredPercentage() : 75.0 %>);
});
</script>

</body>
</html>
