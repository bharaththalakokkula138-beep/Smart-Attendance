<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Departments");
    request.setAttribute("pageSubtitle", "Academic Departments & Departmental Codes Management");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Departments - Smart Attendance</title>
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
                <div class="col-md-5">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-plus text-primary"></i> Add Department</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/departments" method="POST">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Department Code</label>
                                <input type="text" name="departmentCode" class="form-control form-control-modern" placeholder="e.g. MECH or AIDS" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-semibold">Department Name</label>
                                <input type="text" name="departmentName" class="form-control form-control-modern" placeholder="e.g. Mechanical Engineering" required>
                            </div>
                            <button type="submit" class="btn btn-primary-modern w-100 justify-content-center">
                                Save Department
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-md-7">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-building-columns text-primary"></i> Department Directory</h2>
                        </div>
                        <% if (departments != null && !departments.isEmpty()) { %>
                        <div class="table-responsive-clean">
                            <table class="table-modern">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Department Name</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Department d : departments) { %>
                                    <tr>
                                        <td class="fw-bold"><span class="badge bg-light text-dark border"><%= d.getDepartmentCode() %></span></td>
                                        <td class="fw-semibold text-dark"><%= d.getDepartmentName() %></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/departments" method="POST" class="d-inline" onsubmit="return confirm('Delete department <%= d.getDepartmentCode() %>?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="departmentId" value="<%= d.getDepartmentId() %>">
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
                            <div class="text-center py-4 text-muted">No departments created.</div>
                        <% } %>
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
