<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Student Management");
    request.setAttribute("pageSubtitle", "Student Registry, Department Allocations & Academic Enrolment");
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String searchQuery = (String) request.getAttribute("searchQuery");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students - Smart Attendance</title>
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
                <div class="row g-3 align-items-center">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/students" method="GET" class="d-flex gap-2">
                            <input type="text" name="search" class="form-control form-control-modern" placeholder="Search by name, roll no, department..." value="<%= searchQuery != null ? searchQuery : "" %>">
                            <button type="submit" class="btn btn-secondary-modern">Search</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <button type="button" class="btn btn-primary-modern" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                            <i class="fa-solid fa-user-plus me-1"></i> Add New Student
                        </button>
                    </div>
                </div>
            </div>

            <div class="card-modern">
                <div class="card-header-clean">
                    <h2><i class="fa-solid fa-users-gear text-primary"></i> Registered Students (<%= students != null ? students.size() : 0 %>)</h2>
                </div>

                <% if (students != null && !students.isEmpty()) { %>
                <div class="table-responsive-clean">
                    <table class="table-modern">
                        <thead>
                            <tr>
                                <th>Roll No</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Department</th>
                                <th>Sem</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Student s : students) { %>
                            <tr>
                                <td class="fw-bold"><%= s.getRollNo() %></td>
                                <td class="fw-semibold text-dark"><%= s.getName() %></td>
                                <td class="small text-muted"><%= s.getEmail() %></td>
                                <td><%= s.getDepartmentName() %></td>
                                <td><%= s.getSemester() %></td>
                                <td class="small text-muted"><%= s.getPhone() != null ? s.getPhone() : "-" %></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary py-1 px-2 me-1" 
                                            onclick="openEditModal(<%= s.getStudentId() %>, '<%= s.getRollNo() %>', '<%= s.getName() %>', '<%= s.getEmail() %>', <%= s.getDepartmentId() %>, <%= s.getSemester() %>, '<%= s.getPhone() != null ? s.getPhone() : "" %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/students" method="POST" class="d-inline" onsubmit="return confirm('Delete student <%= s.getName() %>?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="studentId" value="<%= s.getStudentId() %>">
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
                    <div class="text-center py-5 text-muted">No student records found.</div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Add Student -->
<div class="modal fade" id="addStudentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/students" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Roll Number</label>
                        <input type="text" name="rollNo" class="form-control form-control-modern" placeholder="e.g. 21A16" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Student Name</label>
                        <input type="text" name="name" class="form-control form-control-modern" placeholder="Full name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">College Email</label>
                        <input type="email" name="email" class="form-control form-control-modern" placeholder="student@college.edu" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Initial Password</label>
                        <input type="password" name="password" class="form-control form-control-modern" value="student123" required>
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
                        <label class="form-label small fw-semibold">Phone Number</label>
                        <input type="text" name="phone" class="form-control form-control-modern" placeholder="Optional phone">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Create Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Student -->
<div class="modal fade" id="editStudentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/students" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="studentId" id="editStudentId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Roll Number</label>
                        <input type="text" name="rollNo" id="editRollNo" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Student Name</label>
                        <input type="text" name="name" id="editName" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">College Email</label>
                        <input type="email" name="email" id="editEmail" class="form-control form-control-modern" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Reset Password (Optional)</label>
                        <input type="password" name="password" class="form-control form-control-modern" placeholder="Leave empty to retain current">
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-8">
                            <label class="form-label small fw-semibold">Department</label>
                            <select name="departmentId" id="editDeptId" class="form-select form-control-modern" required>
                                <% if (departments != null) {
                                    for (Department d : departments) { %>
                                    <option value="<%= d.getDepartmentId() %>"><%= d.getDepartmentName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        <div class="col-4">
                            <label class="form-label small fw-semibold">Semester</label>
                            <input type="number" name="semester" id="editSemester" class="form-control form-control-modern" min="1" max="8" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Phone Number</label>
                        <input type="text" name="phone" id="editPhone" class="form-control form-control-modern">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary-modern" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary-modern">Update Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function openEditModal(id, roll, name, email, deptId, sem, phone) {
    document.getElementById('editStudentId').value = id;
    document.getElementById('editRollNo').value = roll;
    document.getElementById('editName').value = name;
    document.getElementById('editEmail').value = email;
    document.getElementById('editDeptId').value = deptId;
    document.getElementById('editSemester').value = sem;
    document.getElementById('editPhone').value = phone;
    new bootstrap.Modal(document.getElementById('editStudentModal')).show();
}
</script>

</body>
</html>
