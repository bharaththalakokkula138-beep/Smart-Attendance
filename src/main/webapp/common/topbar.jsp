<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.college.model.User loggedUserTop = (session != null) ? (com.college.model.User) session.getAttribute("loggedUser") : null;
    Integer unreadAlerts = (Integer) request.getAttribute("unreadCount");
    if (unreadAlerts == null) unreadAlerts = 0;
    String topTitle = (String) request.getAttribute("pageTitle");
    if (topTitle == null) topTitle = "Dashboard";
    String topSub = (String) request.getAttribute("pageSubtitle");
    if (topSub == null) topSub = "Smart Attendance Monitoring System";
%>
<header class="top-header">
    <div class="d-flex align-items-center gap-3">
        <button class="btn btn-sm btn-light d-lg-none" id="mobileSidebarToggle">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="page-breadcrumb">
            <h1><%= topTitle %></h1>
            <div class="breadcrumb-sub"><%= topSub %></div>
        </div>
    </div>

    <div class="header-actions">
        <% if (loggedUserTop != null && "STUDENT".equalsIgnoreCase(loggedUserTop.getRole())) { %>
            <a href="${pageContext.request.contextPath}/student/notifications" class="header-btn" title="View Notifications">
                <i class="fa-regular fa-bell"></i>
                <% if (unreadAlerts > 0) { %>
                    <span class="notif-badge"><%= unreadAlerts %></span>
                <% } %>
            </a>
        <% } %>

        <a href="${pageContext.request.contextPath}/reports?type=<%= loggedUserTop != null ? loggedUserTop.getRole().toLowerCase() : "student" %>" class="btn btn-secondary-modern btn-sm" target="_blank" title="Print Official Attendance Report">
            <i class="fa-solid fa-print"></i> <span class="d-none d-md-inline">Print Report</span>
        </a>

        <% if (loggedUserTop != null) { %>
            <div class="d-none d-sm-flex align-items-center gap-2 border-start ps-3">
                <div class="text-end">
                    <div class="small fw-bold text-dark"><%= loggedUserTop.getName() %></div>
                    <div class="small text-muted" style="font-size: 11px;"><%= loggedUserTop.getCodeOrRoll() != null ? loggedUserTop.getCodeOrRoll() : loggedUserTop.getRole() %></div>
                </div>
            </div>
        <% } %>
    </div>
</header>
