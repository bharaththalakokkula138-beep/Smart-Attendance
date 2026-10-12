<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Shortage Calculator");
    request.setAttribute("pageSubtitle", "Mathematical Shortage Recovery & Consecutive Class Computation");
    List<SubjectAttendanceSummary> subjects = (List<SubjectAttendanceSummary>) request.getAttribute("subjects");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");

    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
    String calcSubjectName = (String) request.getAttribute("calcSubjectName");
    Integer calcConducted = (Integer) request.getAttribute("calcConducted");
    Integer calcAttended = (Integer) request.getAttribute("calcAttended");
    Integer calcAbsent = (Integer) request.getAttribute("calcAbsent");
    Double calcCurrentPct = (Double) request.getAttribute("calcCurrentPct");
    Double calcRequiredPct = (Double) request.getAttribute("calcRequiredPct");
    Integer calcClassesRequired = (Integer) request.getAttribute("calcClassesRequired");
    Integer calcClassesCanMiss = (Integer) request.getAttribute("calcClassesCanMiss");
    String calcStatus = (String) request.getAttribute("calcStatus");
    String calcBadgeClass = (String) request.getAttribute("calcBadgeClass");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shortage Calculator - Smart Attendance</title>
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
                <!-- Calculator Input Panel -->
                <div class="col-lg-6">
                    <div class="calc-card">
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="brand-icon" style="background: linear-gradient(135deg, #4f46e5, #9333ea);">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="h5 fw-bold text-dark mb-0">Shortage Attendance Calculator</h2>
                                <p class="text-muted small mb-0">Compute consecutive future classes needed to reach required target</p>
                            </div>
                        </div>

                        <!-- Subject Quick Selector Tabs -->
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Select Registered Subject</label>
                            <select class="form-select form-control-modern" id="subjectPicker" onchange="onSubjectChange(this.value)">
                                <option value="custom">-- Custom Values / Simulator --</option>
                                <% if (subjects != null) {
                                    for (SubjectAttendanceSummary s : subjects) { %>
                                    <option value="<%= s.getSubjectId() %>" <%= (selectedSubjectId != null && selectedSubjectId == s.getSubjectId()) ? "selected" : "" %>>
                                        <%= s.getSubjectName() %> (<%= s.getAttendancePercentage() %>%) - Conducted: <%= s.getClassesConducted() %>, Attended: <%= s.getClassesAttended() %>
                                    </option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <form action="${pageContext.request.contextPath}/student/shortage-calculator" method="GET" id="calcForm">
                            <input type="hidden" name="subjectId" id="hiddenSubjId" value="<%= selectedSubjectId != null ? selectedSubjectId : "custom" %>">

                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold text-secondary">Classes Conducted (C)</label>
                                    <input type="number" name="conducted" id="liveConducted" class="form-control form-control-modern" value="<%= calcConducted %>" min="1" max="150" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold text-secondary">Classes Attended (A)</label>
                                    <input type="number" name="attended" id="liveAttended" class="form-control form-control-modern" value="<%= calcAttended %>" min="0" max="150" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Target Required Attendance (R %)</label>
                                <div class="input-group">
                                    <input type="number" step="0.5" name="requiredPercentage" id="liveRequired" class="form-control form-control-modern" value="<%= calcRequiredPct != null ? calcRequiredPct : 75.0 %>" min="50" max="100" required>
                                    <span class="input-group-text bg-light">%</span>
                                </div>
                                <div class="form-text small">College default policy is <strong><%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%</strong></div>
                            </div>

                            <button type="submit" class="btn btn-primary-modern w-100 justify-content-center py-2">
                                <i class="fa-solid fa-arrows-rotate me-2"></i> Recalculate Shortage
                            </button>
                        </form>

                        <!-- Mathematical Proof Formula Box -->
                        <div class="calc-formula-box mt-4">
                            <div class="text-primary fw-bold mb-2"><i class="fa-solid fa-square-root-variable me-1"></i> Mathematical Formula:</div>
                            <div>Formula: (Attended + x) / (Conducted + x) &gt;= R / 100</div>
                            <div class="text-warning mt-1">x = ceil( (R &times; Conducted - 100 &times; Attended) / (100 - R) )</div>
                            <div class="text-secondary small mt-2">Where <strong>x</strong> is the exact minimum consecutive future classes you must attend with zero absences.</div>
                        </div>
                    </div>
                </div>

                <!-- Calculator Result Panel -->
                <div class="col-lg-6">
                    <div class="card-modern h-100 d-flex flex-column">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-square-poll-vertical text-primary"></i> Computation Result</h2>
                            <span id="liveResultStatus">
                                <span class="badge-status <%= calcBadgeClass %>"><%= calcStatus %></span>
                            </span>
                        </div>

                        <!-- Current State Display -->
                        <div class="p-3 bg-light rounded-3 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-secondary small">Course Analyzed:</span>
                                <span class="fw-bold text-dark"><%= calcSubjectName %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-secondary small">Classes Conducted:</span>
                                <span class="fw-semibold"><%= calcConducted %> sessions</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-secondary small">Classes Attended:</span>
                                <span class="fw-semibold text-success"><%= calcAttended %> sessions</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-secondary small">Classes Absent:</span>
                                <span class="fw-semibold text-danger"><%= calcAbsent %> sessions</span>
                            </div>
                            <hr class="my-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-secondary small fw-bold">Current Attendance:</span>
                                <span class="fs-4 fw-bold text-primary" id="liveCurrentPctDisplay"><%= calcCurrentPct %>%</span>
                            </div>
                        </div>

                        <!-- Result Directive Callout -->
                        <div class="calc-result-box <%= calcCurrentPct >= calcRequiredPct ? "safe" : ("WARNING".equalsIgnoreCase(calcStatus) ? "warning" : "critical") %>" id="liveResultContainer">
                            <% if (calcCurrentPct >= calcRequiredPct) { %>
                                <div class="d-flex align-items-center gap-2 fs-5 fw-bold text-success">
                                    <i class="fa-solid fa-circle-check"></i> Safe Status
                                </div>
                                <div class="fs-6" id="liveResultMessage">
                                    Current attendance is <strong><%= calcCurrentPct %>%</strong>, which satisfies the required <strong><%= calcRequiredPct %>%</strong> threshold.
                                    <div class="mt-2">
                                        You can safely miss up to <strong><%= calcClassesCanMiss %></strong> class(es) while remaining above <%= calcRequiredPct %>%.
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="d-flex align-items-center gap-2 fs-5 fw-bold text-danger">
                                    <i class="fa-solid fa-triangle-exclamation"></i> Shortage Alert!
                                </div>
                                <div class="fs-6 lh-base" id="liveResultMessage">
                                    Current attendance is <strong><%= calcCurrentPct %>%</strong>, below the required <strong><%= calcRequiredPct %>%</strong>.
                                    <div class="p-3 bg-white rounded-2 border mt-3 text-dark fw-bold shadow-sm">
                                        <i class="fa-solid fa-arrow-right text-danger me-2"></i> You must attend the next <span class="text-danger fs-4"><%= calcClassesRequired %></span> classes continuously to reach <%= calcRequiredPct %>%.
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <!-- Step-by-Step Proof Details -->
                        <div class="p-3 bg-white border rounded-3 mt-4 small">
                            <div class="fw-bold text-secondary mb-2 text-uppercase" style="font-size: 11px;">Verification Equation:</div>
                            <% if (calcClassesRequired > 0) { %>
                                <div>
                                    (<%= calcAttended %> + <%= calcClassesRequired %>) / (<%= calcConducted %> + <%= calcClassesRequired %>) &times; 100 =
                                    <strong><%= calcAttended + calcClassesRequired %> / <%= calcConducted + calcClassesRequired %></strong> =
                                    <strong class="text-success"><%= com.college.util.AttendanceCalculator.calculatePercentage(calcAttended + calcClassesRequired, calcConducted + calcClassesRequired) %>%</strong> (&gt;= <%= calcRequiredPct %>%)
                                </div>
                            <% } else { %>
                                <div>Attendance is already within the permissible safe zone. Buffer margin: <%= calcClassesCanMiss %> class(es).</div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function onSubjectChange(val) {
    if (val !== 'custom') {
        window.location.href = '${pageContext.request.contextPath}/student/shortage-calculator?subjectId=' + val;
    } else {
        document.getElementById('hiddenSubjId').value = 'custom';
    }
}
</script>

</body>
</html>
