<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Mark Attendance");
    request.setAttribute("pageSubtitle", "Session Attendance Recording & Automatic Percentage Update");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Student> students = (List<Student>) request.getAttribute("students");
    Map<Integer, String> existingMap = (Map<Integer, String>) request.getAttribute("existingStatusMap");
    Integer selectedSubjId = (Integer) request.getAttribute("selectedSubjectId");
    String selectedDate = (String) request.getAttribute("selectedDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance - Smart Attendance</title>
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
                <div class="alert-banner success">
                    <i class="fa-solid fa-circle-check"></i> <%= request.getParameter("msg") %>
                </div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert-banner error">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <!-- Filter / Selector Bar -->
            <div class="card-modern mb-4">
                <form action="${pageContext.request.contextPath}/faculty/attendance" method="GET" class="row g-3 align-items-end" id="filterForm">
                    <div class="col-md-5">
                        <label class="form-label small fw-semibold text-secondary">Select Course / Subject</label>
                        <select name="subjectId" class="form-select form-control-modern" onchange="document.getElementById('filterForm').submit()">
                            <% if (subjects != null) {
                                for (Subject s : subjects) { %>
                                <option value="<%= s.getSubjectId() %>" <%= (selectedSubjId != null && selectedSubjId == s.getSubjectId()) ? "selected" : "" %>>
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %> (<%= s.getDepartmentName() %>, Sem <%= s.getSemester() %>)
                                </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Session Date</label>
                        <input type="date" name="date" class="form-control form-control-modern" value="<%= selectedDate %>" onchange="document.getElementById('filterForm').submit()">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-secondary-modern w-100 justify-content-center">
                            <i class="fa-solid fa-arrows-rotate me-1"></i> Load Session
                        </button>
                    </div>
                </form>
            </div>

            <!-- Attendance Entry Roster Card -->
            <div class="card-modern">
                <div class="card-header-clean">
                    <div>
                        <h2><i class="fa-solid fa-clipboard-user text-primary"></i> Attendance Sheet</h2>
                        <div class="small text-muted">Session Date: <strong><%= selectedDate %></strong> | Enrolled Students: <strong><%= students != null ? students.size() : 0 %></strong></div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-success btn-sm" onclick="markAll(true)">
                            <i class="fa-solid fa-check-double me-1"></i> All Present
                        </button>
                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="markAll(false)">
                            <i class="fa-solid fa-xmark me-1"></i> All Absent
                        </button>
                    </div>
                </div>

                <% if (students != null && !students.isEmpty()) { %>
                <form action="${pageContext.request.contextPath}/faculty/attendance" method="POST">
                    <input type="hidden" name="subjectId" value="<%= selectedSubjId %>">
                    <input type="hidden" name="date" value="<%= selectedDate %>">

                    <div class="table-responsive-clean mb-4">
                        <table class="table-modern">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Roll No</th>
                                    <th style="width: 45%;">Student Name</th>
                                    <th style="width: 25%;">College Email</th>
                                    <th style="width: 15%; text-align: center;">Present Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Student s : students) {
                                    String currentStatus = existingMap != null ? existingMap.get(s.getStudentId()) : null;
                                    boolean isPresent = (currentStatus == null) || "PRESENT".equalsIgnoreCase(currentStatus);
                                %>
                                <tr>
                                    <td class="fw-bold"><%= s.getRollNo() %></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= s.getName() %></div>
                                    </td>
                                    <td class="small text-muted"><%= s.getEmail() %></td>
                                    <td style="text-align: center;">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input att-switch" type="checkbox" name="status_<%= s.getStudentId() %>" value="PRESENT" <%= isPresent ? "checked" : "" %> style="cursor: pointer; width: 44px; height: 22px;">
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-end gap-3">
                        <a href="${pageContext.request.contextPath}/faculty/dashboard" class="btn btn-secondary-modern">Cancel</a>
                        <button type="submit" class="btn btn-primary-modern px-4 py-2">
                            <i class="fa-solid fa-check me-2"></i> Submit Attendance
                        </button>
                    </div>
                </form>
                <% } else { %>
                    <div class="text-center py-5 text-muted">No students enrolled in this course for the selected department/semester.</div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function markAll(status) {
    document.querySelectorAll('.att-switch').forEach(function(sw) {
        sw.checked = status;
    });
}
</script>

</body>
</html>
