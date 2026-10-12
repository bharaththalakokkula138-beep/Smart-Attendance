<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Can I Take Leave?");
    request.setAttribute("pageSubtitle", "Predictive Future Leave Simulation & Safety Buffer Estimator");
    List<SubjectAttendanceSummary> subjects = (List<SubjectAttendanceSummary>) request.getAttribute("subjects");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");
    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
    Integer upcomingClasses = (Integer) request.getAttribute("upcomingClasses");
    Integer classesToMiss = (Integer) request.getAttribute("classesToMiss");
    LeavePredictionResult leaveResult = (LeavePredictionResult) request.getAttribute("leaveResult");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Can I Take Leave? - Smart Attendance</title>
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
            <div class="row g-4">
                <!-- Leave Simulator Form -->
                <div class="col-lg-6">
                    <div class="calc-card" style="border-color: #a7f3d0;">
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="brand-icon" style="background: linear-gradient(135deg, #10b981, #06b6d4);">
                                <i class="fa-solid fa-plane-departure"></i>
                            </div>
                            <div>
                                <h2 class="h5 fw-bold text-dark mb-0">"Can I Take Leave?" Simulator</h2>
                                <p class="text-muted small mb-0">Simulate future absences and determine if attendance remains safe</p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/student/leave-calculator" method="GET" id="leaveForm">
                            <!-- Course Selection -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-secondary">Select Course / Subject</label>
                                <select name="subjectId" id="subjSelect" class="form-select form-control-modern" onchange="document.getElementById('leaveForm').submit()">
                                    <% if (subjects != null) {
                                        for (SubjectAttendanceSummary s : subjects) { %>
                                        <option value="<%= s.getSubjectId() %>" <%= (selectedSubjectId != null && selectedSubjectId == s.getSubjectId()) ? "selected" : "" %>>
                                            <%= s.getSubjectName() %> (Current: <%= s.getAttendancePercentage() %>%)
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>

                            <!-- Upcoming Classes -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-secondary">Total Upcoming Scheduled Classes</label>
                                <input type="number" name="upcomingClasses" id="upcomingInput" class="form-control form-control-modern" value="<%= upcomingClasses != null ? upcomingClasses : 2 %>" min="1" max="25" required onchange="adjustMissInput()">
                                <div class="form-text small">e.g. Next week's sessions (default: 2 classes)</div>
                            </div>

                            <!-- Classes Planned to Miss -->
                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Number of Classes You Plan to Miss</label>
                                <input type="number" name="classesToMiss" id="missInput" class="form-control form-control-modern" value="<%= classesToMiss != null ? classesToMiss : 2 %>" min="0" max="<%= upcomingClasses != null ? upcomingClasses : 2 %>" required>
                                <div class="form-text small">Cannot exceed total upcoming classes</div>
                            </div>

                            <button type="submit" class="btn btn-primary-modern w-100 justify-content-center py-2" style="background: #059669;">
                                <i class="fa-solid fa-wand-magic-sparkles me-2"></i> Predict Result
                            </button>
                        </form>

                        <div class="calc-formula-box mt-4">
                            <div class="text-info fw-bold mb-2"><i class="fa-solid fa-calculator me-1"></i> Prediction Logic:</div>
                            <div>Predicted Attended = Current Attended + (Upcoming - Missed)</div>
                            <div>Predicted Conducted = Current Conducted + Upcoming</div>
                            <div class="text-warning mt-1">Predicted % = (Predicted Attended / Predicted Conducted) &times; 100</div>
                        </div>
                    </div>
                </div>

                <!-- Simulation Result Outcome Panel -->
                <div class="col-lg-6">
                    <% if (leaveResult != null) { %>
                    <div class="card-modern h-100 d-flex flex-column">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-clipboard-check text-primary"></i> Simulation Outcome</h2>
                            <span class="badge-status <%= leaveResult.getBadgeClass() %>">
                                <%= leaveResult.getStatus() %>
                            </span>
                        </div>

                        <!-- Before vs After Comparison Card -->
                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <div class="p-3 bg-light rounded-3 text-center border">
                                    <div class="text-muted small" style="font-size: 11px;">Current Attendance</div>
                                    <div class="fs-4 fw-bold text-dark my-1"><%= leaveResult.getCurrentPercentage() %>%</div>
                                    <div class="small text-muted"><%= leaveResult.getCurrentAttended() %> / <%= leaveResult.getCurrentConducted() %> classes</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-3 bg-light rounded-3 text-center border" style="border-color: <%= leaveResult.isSafe() ? "#a7f3d0" : "#fecaca" %> !important;">
                                    <div class="text-muted small" style="font-size: 11px;">Predicted Attendance</div>
                                    <div class="fs-4 fw-bold <%= leaveResult.isSafe() ? "text-success" : "text-danger" %> my-1">
                                        <%= leaveResult.getPredictedPercentage() %>%
                                    </div>
                                    <div class="small text-muted"><%= leaveResult.getPredictedAttended() %> / <%= leaveResult.getPredictedConducted() %> classes</div>
                                </div>
                            </div>
                        </div>

                        <!-- Progress Bar Comparison -->
                        <div class="p-3 bg-white border rounded-3 mb-4">
                            <div class="d-flex justify-content-between small fw-semibold text-secondary mb-1">
                                <span>Target Requirement: <strong><%= leaveResult.getRequiredPercentage() %>%</strong></span>
                                <span class="<%= leaveResult.isSafe() ? "text-success" : "text-danger" %>">
                                    <%= leaveResult.getPredictedPercentage() >= leaveResult.getRequiredPercentage() ? "+" : "" %><%= com.college.util.AttendanceCalculator.round(leaveResult.getPredictedPercentage() - leaveResult.getRequiredPercentage(), 1) %>% margin
                                </span>
                            </div>
                            <div class="progress-container position-relative">
                                <div class="progress-bar-fill progress-<%= leaveResult.getStatus().toLowerCase() %>" style="width: <%= Math.min(100.0, leaveResult.getPredictedPercentage()) %>%;"></div>
                                <div class="progress-threshold-line" title="Threshold <%= leaveResult.getRequiredPercentage() %>%"></div>
                            </div>
                        </div>

                        <!-- Directive Callout Result Box -->
                        <div class="calc-result-box <%= leaveResult.isSafe() ? "safe" : ("WARNING".equalsIgnoreCase(leaveResult.getStatus()) ? "warning" : "critical") %>">
                            <div class="d-flex align-items-center gap-2 fs-5 fw-bold">
                                <% if (leaveResult.isSafe()) { %>
                                    <i class="fa-solid fa-circle-check text-success"></i> Leave Permissible
                                <% } else { %>
                                    <i class="fa-solid fa-triangle-exclamation text-danger"></i> High Shortage Risk
                                <% } %>
                            </div>
                            <div class="fs-6 fw-medium">
                                <%= leaveResult.getMessage() %>
                            </div>
                            <div class="p-3 bg-white rounded-2 border text-dark mt-2 small shadow-sm">
                                <strong><i class="fa-solid fa-lightbulb text-warning me-1"></i> Advisory:</strong>
                                <%= leaveResult.getRecommendation() %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function adjustMissInput() {
    const up = parseInt(document.getElementById('upcomingInput').value) || 1;
    const miss = document.getElementById('missInput');
    miss.max = up;
    if (parseInt(miss.value) > up) {
        miss.value = up;
    }
}
</script>

</body>
</html>
