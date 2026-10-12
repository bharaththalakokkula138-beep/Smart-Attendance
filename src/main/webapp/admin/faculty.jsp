<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Faculty Management");
    request.setAttribute("pageSubtitle", "Faculty Staff Directory, Department Affiliation & Designations");
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Faculty - Smart Attendance</title>
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
                        <h2 class="h5 fw-bold mb-1">Faculty Staff Directory</h2>
                        <p class="text-muted small mb-0">Total Faculty Members: <%= facultyList != null ? facultyList.size() : 0 %></p>
                    </div>
                    <button type="button" class="btn btn-primary-modern" data-bs-toggle="modal" data-bs-target="#addFacultyModal">
                        <i class="fa-solid fa-plus me-1"></i> Add Faculty
                    </button>
                </div>
            </div>

            <div class="card-modern">
                <% if (facultyList != null && !facultyList.isEmpty()) { %>
                <div class="table-responsive-clean">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Faculty Name</th>
                                <th>Designation</th>
                                <th>Department</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Faculty f : facultyList) { %>
                            <tr>
                                <td class="fw-bold"><%= f.getFacultyCode() %></td>
                                <td>
                                    <div class="fw-semibold text-dark"><%= f.getName() %></div>
                                </td>
                                <td><span class="badge bg-light text-dark border"><%= f.getDesignation() %></span></td>
                                <td><%= f.getDepartmentName() %></td>
                                <td class="small text-muted"><%= f.getEmail() %></td>
                                <td class="small text-muted"><%= f.getPhone() != null ? f.getPhone() : "-" %></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary py-1 px-2 me-1"
                                            onclick="openEditFacultyModal(<%= f.getFacultyId() %>, '<%= f.getFacultyCode() %>', '<%= f.getName() %>', '<%= f.getEmail() %>', <%= f.getDepartmentId() %>, '<%= f.getDesignation() %>', '<%= f.getPhone() != null ? f.getPhone() : "" %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/faculty" method="POST" class="d-inline" onsubmit="return confirm('Delete faculty <%= f.getName() %>?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="facultyId" value="<%= f.getFacultyId() %>">
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
                    <div class="text-center py-5 text-muted">No faculty members found.</div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Add Faculty -->
<div class="modal fade" id="addFacultyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/faculty" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add Faculty Member</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Faculty Code</label>
                        <input type="text" name="facultyCode" class="form-control form-control-modern" placeholder="e.g. FAC006" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Full Name</label>
                        <input type="text" name="name" class="form-control form-control-modern" placeholder="e.g. Dr. Jane Doe" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email Address</label>
                        <input type="email" name="email" class="form-control form-control-modern" placeholder="faculty@college.edu" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Password</label>
                        <input type="password" name="password" class="form-control form-control-modern" value="faculty123" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Department</label>
                        <select name="departmentId" class="form-select form-control-modern" required>
                            <% if (departments != null) {
                                for (Department d : departments) { %>
                                <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Designation</label>
                            <input type="text" name="designation" class="form-control form-control-modern" value="Assistant Professor">
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Phone</label>
                            <input type="text" name="phone" class="form-control form-control-modern" placeholder="Contact number">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Save Faculty</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Faculty -->
<div class="modal fade" id="editFacultyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/faculty" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="facultyId" id="editFacultyId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Faculty Member</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Faculty Code</label>
                        <input type="text" name="facultyCode" id="editFacultyCode" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Full Name</label>
                        <input type="text" name="name" id="editFacultyName" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email Address</label>
                        <input type="email" name="email" id="editFacultyEmail" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Reset Password (Optional)</label>
                        <input type="password" name="password" class="form-control form-control-modern" placeholder="Leave empty to retain current">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Department</label>
                        <select name="departmentId" id="editFacultyDeptId" class="form-select form-control-modern" required>
                            <% if (departments != null) {
                                for (Department d : departments) { %>
                                <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Designation</label>
                            <input type="text" name="designation" id="editFacultyDesignation" class="form-control form-control-modern">
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Phone</label>
                            <input type="text" name="phone" id="editFacultyPhone" class="form-control form-control-modern">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Update Faculty</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function openEditFacultyModal(id, code, name, email, deptId, designation, phone) {
    document.getElementById('editFacultyId').value = id;
    document.getElementById('editFacultyCode').value = code;
    document.getElementById('editFacultyName').value = name;
    document.getElementById('editFacultyEmail').value = email;
    document.getElementById('editFacultyDeptId').value = deptId;
    document.getElementById('editFacultyDesignation').value = designation;
    document.getElementById('editFacultyPhone').value = phone;
    new bootstrap.Modal(document.getElementById('editFacultyModal')).show();
}
</script>

</body>
</html>
