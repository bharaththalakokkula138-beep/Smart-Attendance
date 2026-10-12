<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Attendance Reports");
    request.setAttribute("pageSubtitle", "Official Subject Attendance Reports & Defaulter Statements");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    Subject currentSubject = (Subject) request.getAttribute("currentSubject");
    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    Integer selectedSubjId = (Integer) request.getAttribute("selectedSubjectId");
    AttendanceRule rule = (AttendanceRule) request.getAttribute("rule");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Reports - Smart Attendance</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/print.css" rel="stylesheet" media="print">
</head>
<body>

<div class="app-container">
    <jsp:include page="/common/sidebar.jsp" />

    <div class="main-wrapper">
        <jsp:include page="/common/topbar.jsp" />

        <main class="content-body">
            <div class="card-modern no-print mb-4">
                <form action="${pageContext.request.contextPath}/faculty/reports" method="GET" class="row g-3 align-items-end" id="repForm">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Select Course for Report</label>
                        <select name="subjectId" class="form-select form-control-modern" onchange="document.getElementById('repForm').submit()">
                            <% if (subjects != null) {
                                for (Subject s : subjects) { %>
                                <option value="<%= s.getSubjectId() %>" <%= (selectedSubjId != null && selectedSubjId == s.getSubjectId()) ? "selected" : "" %>>
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %> (<%= s.getDepartmentName() %>)
                                </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-primary-modern" onclick="window.print()">
                            <i class="fa-solid fa-print me-2"></i> Print Official Report
                        </button>
                    </div>
                </form>
            </div>

            <!-- Official Report Sheet -->
            <div class="card-modern p-4">
                <div class="text-center pb-3 mb-4 border-bottom">
                    <h2 class="h4 fw-bold text-dark text-uppercase mb-1">College of Engineering &amp; Technology</h2>
                    <h3 class="h6 text-muted mb-2">Department of <%= currentSubject != null ? currentSubject.getDepartmentName() : "Academic Department" %></h3>
                    <div class="badge bg-dark px-3 py-2 text-white">SUBJECT ATTENDANCE &amp; SHORTAGE STATEMENT</div>
                </div>

                <div class="row g-3 mb-4 small bg-light p-3 rounded-2">
                    <div class="col-md-4">
                        <strong>Course Code &amp; Name:</strong> <%= currentSubject != null ? currentSubject.getSubjectCode() + " - " + currentSubject.getSubjectName() : "N/A" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Faculty In-Charge:</strong> <%= currentSubject != null ? currentSubject.getFacultyName() : "N/A" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Mandatory Policy:</strong> <%= rule != null ? rule.getMinimumPercentage() : 75.0 %>% Minimum
                    </div>
                </div>

                <% if (students != null && !students.isEmpty()) { %>
                <div class="table-responsive-clean mb-4">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Sl. No</th>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Held</th>
                                <th>Attended</th>
                                <th>Absent</th>
                                <th>Attendance %</th>
                                <th>Status</th>
                                <th>Shortage Eligibility</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int idx = 1;
                            for (Map<String, Object> st : students) {
                                double pct = (Double) st.get("percentage");
                                String status = (String) st.get("status");
                                String badge = (String) st.get("badgeClass");
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td class="fw-bold"><%= st.get("rollNo") %></td>
                                <td><%= st.get("name") %></td>
                                <td><%= st.get("conducted") %></td>
                                <td class="text-success fw-bold"><%= st.get("attended") %></td>
                                <td class="text-danger"><%= st.get("absent") %></td>
                                <td class="fw-bold"><%= pct %>%</td>
                                <td>
                                    <span class="badge-status <%= badge %>"><%= status %></span>
                                </td>
                                <td>
                                    <% if (pct >= (rule != null ? rule.getMinimumPercentage() : 75.0)) { %>
                                        <span class="text-success small fw-semibold">ELIGIBLE</span>
                                    <% } else { %>
                                        <span class="text-danger small fw-bold">DEFICIT / SHORTAGE</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="row mt-5 pt-4 text-center small text-secondary">
                    <div class="col-4">
                        <div class="border-top pt-2">Course Faculty Signature</div>
                    </div>
                    <div class="col-4">
                        <div class="border-top pt-2">Head of Department</div>
                    </div>
                    <div class="col-4">
                        <div class="border-top pt-2">Dean / Principal</div>
                    </div>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
