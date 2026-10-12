<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Student" %>
<%
    request.setAttribute("pageTitle", "Student Profile");
    request.setAttribute("pageSubtitle", "Personal Information & Account Credentials");
    Student student = (Student) request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile - Smart Attendance</title>
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
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert-banner success">
                    <i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card-modern text-center">
                        <div class="user-avatar mx-auto mb-3" style="width: 80px; height: 80px; font-size: 32px;">
                            <%= student != null ? student.getName().substring(0, 1).toUpperCase() : "S" %>
                        </div>
                        <h2 class="h5 fw-bold text-dark mb-1"><%= student != null ? student.getName() : "Student" %></h2>
                        <div class="badge bg-primary-subtle text-primary border border-primary-subtle mb-3">
                            <%= student != null ? student.getRollNo() : "" %>
                        </div>
                        <hr>
                        <div class="text-start small">
                            <div class="mb-2"><strong>Department:</strong> <%= student != null ? student.getDepartmentName() : "" %></div>
                            <div class="mb-2"><strong>Semester:</strong> <%= student != null ? student.getSemester() : "" %></div>
                            <div class="mb-2"><strong>Email:</strong> <%= student != null ? student.getEmail() : "" %></div>
                            <div><strong>Phone:</strong> <%= student != null && student.getPhone() != null ? student.getPhone() : "Not provided" %></div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card-modern">
                        <div class="card-header-clean">
                            <h2><i class="fa-solid fa-user-pen text-primary"></i> Edit Profile &amp; Password</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/student/profile" method="POST">
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">Full Name</label>
                                    <input type="text" class="form-control form-control-modern" value="<%= student != null ? student.getName() : "" %>" disabled>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">Roll Number</label>
                                    <input type="text" class="form-control form-control-modern" value="<%= student != null ? student.getRollNo() : "" %>" disabled>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">College Email</label>
                                    <input type="email" class="form-control form-control-modern" value="<%= student != null ? student.getEmail() : "" %>" disabled>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-secondary">Contact Phone Number</label>
                                    <input type="text" name="phone" class="form-control form-control-modern" value="<%= student != null && student.getPhone() != null ? student.getPhone() : "" %>">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-semibold text-secondary">Change Password</label>
                                <input type="password" name="password" class="form-control form-control-modern" placeholder="Leave empty to keep current password">
                            </div>

                            <button type="submit" class="btn btn-primary-modern">
                                <i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
                            </button>
                        </form>
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
