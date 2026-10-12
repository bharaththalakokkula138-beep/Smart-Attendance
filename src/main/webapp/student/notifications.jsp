<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Notifications & Alerts");
    request.setAttribute("pageSubtitle", "Attendance Warning Alerts, Critical Shortage Notices & Updates");
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Smart Attendance</title>
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="h4 fw-bold mb-1">Attendance Notification Center</h2>
                    <p class="text-muted small mb-0">System alerts and automatic notices triggered by attendance fluctuations</p>
                </div>
                <% if (notifications != null && !notifications.isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/student/notifications?action=readAll" class="btn btn-secondary-modern btn-sm">
                        <i class="fa-solid fa-envelope-open-text me-1"></i> Mark All as Read
                    </a>
                <% } %>
            </div>

            <div class="card-modern">
                <% if (notifications != null && !notifications.isEmpty()) { %>
                    <div>
                        <% for (Notification n : notifications) { %>
                        <div class="notif-item <%= !n.isRead() ? "unread" : "" %> <%= n.getType() != null ? n.getType().toLowerCase() : "" %>">
                            <div class="notif-icon <%= n.getType() %>">
                                <% if ("CRITICAL".equalsIgnoreCase(n.getType())) { %>
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                <% } else if ("WARNING".equalsIgnoreCase(n.getType())) { %>
                                    <i class="fa-solid fa-bell"></i>
                                <% } else if ("SUCCESS".equalsIgnoreCase(n.getType())) { %>
                                    <i class="fa-solid fa-circle-check"></i>
                                <% } else { %>
                                    <i class="fa-solid fa-circle-info"></i>
                                <% } %>
                            </div>

                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-baseline mb-1">
                                    <h3 class="h6 fw-bold mb-0 text-dark">
                                        <%= n.getTitle() %>
                                        <% if (!n.isRead()) { %>
                                            <span class="badge bg-primary ms-2" style="font-size: 10px;">New</span>
                                        <% } %>
                                    </h3>
                                    <span class="text-muted small" style="font-size: 11px;">
                                        <%= n.getCreatedAt() %>
                                    </span>
                                </div>
                                <div class="text-secondary small mb-2"><%= n.getMessage() %></div>
                                <% if (!n.isRead()) { %>
                                    <a href="${pageContext.request.contextPath}/student/notifications?action=read&id=<%= n.getNotificationId() %>" class="btn btn-sm btn-link p-0 text-decoration-none small">
                                        Mark as read
                                    </a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <div class="text-muted fs-1 mb-3"><i class="fa-regular fa-bell-slash"></i></div>
                        <h4 class="h6 text-muted">No notifications at this time</h4>
                        <p class="small text-muted">All your attendance records are currently stable.</p>
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
