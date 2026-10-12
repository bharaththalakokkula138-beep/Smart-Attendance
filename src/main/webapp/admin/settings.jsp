<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.AttendanceRule" %>
<%
    request.setAttribute("pageTitle", "Policy Rules & Settings");
    request.setAttribute("pageSubtitle", "Configure Institutional Minimum Attendance Percentages & Shortage Thresholds");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Policy Settings - Smart Attendance</title>
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
            <% if (request.getParameter("msg") != null) { %>
                <div class="alert-banner success"><i class="fa-solid fa-circle-check"></i> <%= request.getParameter("msg") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert-banner error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getParameter("error") %></div>
            <% } %>

            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-sliders text-primary"></i> Attendance Policy Configuration</h2>
                        </div>

                        <form action="${pageContext.request.contextPath}/admin/settings" method="POST">
                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Minimum Mandatory Percentage (Required Target)</label>
                                <div class="input-group">
                                    <input type="number" step="0.5" name="minimumPercentage" class="form-control form-control-modern" value="<%= rule != null ? rule.getMinimumPercentage() : 75.0 %>" min="50" max="100" required>
                                    <span class="input-group-text bg-light">%</span>
                                </div>
                                <div class="form-text small">Default institutional requirement is <strong>75%</strong>. All students below this are classified as shortage.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Warning Threshold Boundary</label>
                                <div class="input-group">
                                    <input type="number" step="0.5" name="warningThreshold" class="form-control form-control-modern" value="<%= rule != null ? rule.getWarningThreshold() : 70.0 %>" min="40" max="95" required>
                                    <span class="input-group-text bg-light">%</span>
                                </div>
                                <div class="form-text small">Students between Warning Threshold and Minimum % are marked with a <strong>Warning</strong> status.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Critical Threshold Boundary</label>
                                <div class="input-group">
                                    <input type="number" step="0.5" name="criticalThreshold" class="form-control form-control-modern" value="<%= rule != null ? rule.getCriticalThreshold() : 65.0 %>" min="30" max="90" required>
                                    <span class="input-group-text bg-light">%</span>
                                </div>
                                <div class="form-text small">Students below this percentage receive immediate <strong>Critical Shortage Alerts</strong>.</div>
                            </div>

                            <button type="submit" class="btn btn-primary-modern py-2 px-4">
                                <i class="fa-solid fa-floppy-disk me-2"></i> Save Policy Settings
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-circle-info text-primary"></i> Business Logic Classification Rule</h2>
                        </div>

                        <div class="p-3 mb-3 rounded-2" style="background: var(--success-light); border: 1px solid var(--success-border);">
                            <div class="fw-bold text-success mb-1"><i class="fa-solid fa-circle-check me-1"></i> SAFE STATUS</div>
                            <div class="small text-secondary">Attendance &gt;= Required Target (<%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%)</div>
                            <div class="small text-muted mt-1">Student has sufficient attendance and is permitted to appear for examinations.</div>
                        </div>

                        <div class="p-3 mb-3 rounded-2" style="background: var(--warning-light); border: 1px solid var(--warning-border);">
                            <div class="fw-bold text-warning mb-1"><i class="fa-solid fa-bell me-1"></i> WARNING STATUS</div>
                            <div class="small text-secondary"><%= rule != null ? rule.getWarningThreshold() : 70.0 %>% &lt;= Attendance &lt; <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>%</div>
                            <div class="small text-muted mt-1">Student is in the danger zone and should avoid any further leaves.</div>
                        </div>

                        <div class="p-3 rounded-2" style="background: var(--danger-light); border: 1px solid var(--danger-border);">
                            <div class="fw-bold text-danger mb-1"><i class="fa-solid fa-triangle-exclamation me-1"></i> CRITICAL STATUS</div>
                            <div class="small text-secondary">Attendance &lt; <%= rule != null ? rule.getWarningThreshold() : 70.0 %>%</div>
                            <div class="small text-muted mt-1">Severe shortage. Consecutive attendance recovery is urgently mandatory to avoid detention.</div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
