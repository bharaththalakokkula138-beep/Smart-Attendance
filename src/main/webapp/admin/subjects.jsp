<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Subject Management");
    request.setAttribute("pageSubtitle", "Curriculum Courses, Faculty Mapping & Academic Semester Allocation");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Subjects - Smart Attendance</title>
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

            <div class="card-modern mb-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="h5 fw-bold mb-1">Academic Courses &amp; Curriculum</h2>
                        <p class="text-muted small mb-0">Total Courses: <%= subjects != null ? subjects.size() : 0 %></p>
                    </div>
                    <button type="button" class="btn btn-primary-modern" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                        <i class="fa-solid fa-plus me-1"></i> Add Subject
                    </button>
                </div>
            </div>

            <div class="card-modern">
                <% if (subjects != null && !subjects.isEmpty()) { %>
                <div class="table-responsive-clean">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Department</th>
                                <th>Semester</th>
                                <th>Assigned Faculty</th>
                                <th>Planned Classes</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Subject s : subjects) { %>
                            <tr>
                                <td class="fw-bold"><%= s.getSubjectCode() %></td>
                                <td>
                                    <div class="fw-semibold text-dark"><%= s.getSubjectName() %></div>
                                </td>
                                <td><%= s.getDepartmentName() %></td>
                                <td>Sem <%= s.getSemester() %></td>
                                <td class="text-primary fw-medium">
                                    <i class="fa-solid fa-chalkboard-user me-1"></i>
                                    <%= s.getFacultyName() != null ? s.getFacultyName() : "Not Assigned" %>
                                </td>
                                <td><%= s.getTotalClassesPlanned() %></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary py-1 px-2 me-1"
                                            onclick="openEditSubjectModal(<%= s.getSubjectId() %>, '<%= s.getSubjectCode() %>', '<%= s.getSubjectName() %>', <%= s.getDepartmentId() %>, <%= s.getSemester() %>, <%= s.getFacultyId() != null ? s.getFacultyId() : "''" %>, <%= s.getTotalClassesPlanned() %>)">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/subjects" method="POST" class="d-inline" onsubmit="return confirm('Delete subject <%= s.getSubjectName() %>?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="subjectId" value="<%= s.getSubjectId() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">No subject records found.</div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Add Subject -->
<div class="modal fade" id="addSubjectModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-2 mb-3">
                        <div class="col-4">
                            <label class="form-label small fw-semibold">Subject Code</label>
                            <input type="text" name="subjectCode" class="form-control form-control-modern" placeholder="e.g. CS506" required>
                        </div>
                        <div class="col-8">
                            <label class="form-label small fw-semibold">Subject Name</label>
                            <input type="text" name="subjectName" class="form-control form-control-modern" placeholder="e.g. Cloud Computing" required>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-8">
                            <label class="form-label small fw-semibold">Department</label>
                            <select name="departmentId" class="form-select form-control-modern" required>
                                <% if (departments != null) {
                                    for (Department d : departments) { %>
                                    <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        <div class="col-4">
                            <label class="form-label small fw-semibold">Semester</label>
                            <input type="number" name="semester" class="form-control form-control-modern" value="5" min="1" max="8" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Assign Faculty In-Charge</label>
                        <select name="facultyId" class="form-select form-control-modern">
                            <option value="">-- None / Unassigned --</option>
                            <% if (facultyList != null) {
                                for (Faculty f : facultyList) { %>
                                <option value="<%= f.getFacultyId() %>"><%= f.getName() %> (<%= f.getDepartmentName() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Planned Classes in Semester</label>
                        <input type="number" name="totalClassesPlanned" class="form-control form-control-modern" value="50" min="10" max="150" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Create Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Subject -->
<div class="modal fade" id="editSubjectModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="subjectId" id="editSubjectId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-2 mb-3">
                        <div class="col-4">
                            <label class="form-label small fw-semibold">Subject Code</label>
                            <input type="text" name="subjectCode" id="editSubjectCode" class="form-control form-control-modern" required>
                        </div>
                        <div class="col-8">
                            <label class="form-label small fw-semibold">Subject Name</label>
                            <input type="text" name="subjectName" id="editSubjectName" class="form-control form-control-modern" required>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-8">
                            <label class="form-label small fw-semibold">Department</label>
                            <select name="departmentId" id="editSubjectDeptId" class="form-select form-control-modern" required>
                                <% if (departments != null) {
                                    for (Department d : departments) { %>
                                    <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        <div class="col-4">
                            <label class="form-label small fw-semibold">Semester</label>
                            <input type="number" name="semester" id="editSubjectSemester" class="form-control form-control-modern" min="1" max="8" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Assign Faculty In-Charge</label>
                        <select name="facultyId" id="editSubjectFacultyId" class="form-select form-control-modern">
                            <option value="">-- None / Unassigned --</option>
                            <% if (facultyList != null) {
                                for (Faculty f : facultyList) { %>
                                <option value="<%= f.getFacultyId() %>"><%= f.getName() %> (<%= f.getDepartmentName() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Planned Classes in Semester</label>
                        <input type="number" name="totalClassesPlanned" id="editSubjectPlanned" class="form-control form-control-modern" min="10" max="150" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Update Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function openEditSubjectModal(id, code, name, deptId, sem, facultyId, planned) {
    document.getElementById('editSubjectId').value = id;
    document.getElementById('editSubjectCode').value = code;
    document.getElementById('editSubjectName').value = name;
    document.getElementById('editSubjectDeptId').value = deptId;
    document.getElementById('editSubjectSemester').value = sem;
    document.getElementById('editSubjectFacultyId').value = facultyId ? facultyId : '';
    document.getElementById('editSubjectPlanned').value = planned;
    new bootstrap.Modal(document.getElementById('editSubjectModal')).show();
}
</script>

</body>
</html>
