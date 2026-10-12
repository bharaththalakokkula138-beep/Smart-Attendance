<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.college.model.User loggedUser = (session != null) ? (com.college.model.User) session.getAttribute("loggedUser") : null;
    String currentPath = request.getRequestURI();
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";
%>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="brand-icon">
            <i class="fa-solid fa-graduation-cap"></i>
        </div>
        <div>
            <div class="brand-title">Smart Attendance</div>
            <div class="brand-subtitle">Prediction &amp; Risk AI</div>
        </div>
    </div>

    <% if (loggedUser != null) { %>
    <div class="sidebar-user">
        <div class="user-avatar">
            <%= loggedUser.getName() != null && !loggedUser.getName().isEmpty() ? loggedUser.getName().substring(0, 1).toUpperCase() : "U" %>
        </div>
        <div class="user-info">
            <div class="user-name"><%= loggedUser.getName() %></div>
            <span class="user-role-badge badge-role-<%= loggedUser.getRole().toLowerCase() %>">
                <%= loggedUser.getRole() %>
            </span>
        </div>
    </div>
    <% } %>

    <ul class="sidebar-nav">
        <% if (loggedUser != null && "STUDENT".equalsIgnoreCase(loggedUser.getRole())) { %>
            <li class="nav-section-title">Student Portal</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link <%= currentPath.contains("/student/dashboard") ? "active" : "" %>">
                    <i class="fa-solid fa-chart-pie"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/attendance" class="nav-link <%= currentPath.contains("/student/attendance") ? "active" : "" %>">
                    <i class="fa-solid fa-table-list"></i> Subject Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/analytics" class="nav-link <%= currentPath.contains("/student/analytics") ? "active" : "" %>">
                    <i class="fa-solid fa-chart-line"></i> Trend &amp; Risk AI
                </a>
            </li>
            <li class="nav-section-title">Calculators &amp; Tools</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/shortage-calculator" class="nav-link <%= currentPath.contains("/student/shortage-calculator") ? "active" : "" %>">
                    <i class="fa-solid fa-calculator"></i> Shortage Calculator
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/leave-calculator" class="nav-link <%= currentPath.contains("/student/leave-calculator") ? "active" : "" %>">
                    <i class="fa-solid fa-calendar-check"></i> Can I Take Leave?
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/notifications" class="nav-link <%= currentPath.contains("/student/notifications") ? "active" : "" %>">
                    <i class="fa-solid fa-bell"></i> Alerts &amp; Warnings
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/student/profile" class="nav-link <%= currentPath.contains("/student/profile") ? "active" : "" %>">
                    <i class="fa-solid fa-user-circle"></i> Student Profile
                </a>
            </li>
        <% } else if (loggedUser != null && "FACULTY".equalsIgnoreCase(loggedUser.getRole())) { %>
            <li class="nav-section-title">Faculty Portal</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/faculty/dashboard" class="nav-link <%= currentPath.contains("/faculty/dashboard") ? "active" : "" %>">
                    <i class="fa-solid fa-gauge-high"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/faculty/attendance" class="nav-link <%= currentPath.contains("/faculty/attendance") ? "active" : "" %>">
                    <i class="fa-solid fa-clipboard-user"></i> Mark Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/faculty/students" class="nav-link <%= currentPath.contains("/faculty/students") ? "active" : "" %>">
                    <i class="fa-solid fa-users"></i> Student Shortage Roster
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/faculty/reports" class="nav-link <%= currentPath.contains("/faculty/reports") ? "active" : "" %>">
                    <i class="fa-solid fa-file-invoice"></i> Attendance Reports
                </a>
            </li>
        <% } else if (loggedUser != null && "ADMIN".equalsIgnoreCase(loggedUser.getRole())) { %>
            <li class="nav-section-title">Admin Management</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link <%= currentPath.contains("/admin/dashboard") ? "active" : "" %>">
                    <i class="fa-solid fa-gauge"></i> Overview Analytics
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/students" class="nav-link <%= currentPath.contains("/admin/students") ? "active" : "" %>">
                    <i class="fa-solid fa-user-graduate"></i> Manage Students
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/faculty" class="nav-link <%= currentPath.contains("/admin/faculty") ? "active" : "" %>">
                    <i class="fa-solid fa-chalkboard-user"></i> Manage Faculty
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/subjects" class="nav-link <%= currentPath.contains("/admin/subjects") ? "active" : "" %>">
                    <i class="fa-solid fa-book-open"></i> Manage Subjects
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/departments" class="nav-link <%= currentPath.contains("/admin/departments") ? "active" : "" %>">
                    <i class="fa-solid fa-building-columns"></i> Departments
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link <%= currentPath.contains("/admin/settings") ? "active" : "" %>">
                    <i class="fa-solid fa-sliders"></i> Policy &amp; Rules
                </a>
            </li>
        <% } %>
    </ul>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Sign Out
        </a>
    </div>
</aside>
