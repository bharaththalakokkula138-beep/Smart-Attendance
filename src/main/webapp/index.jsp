<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.college.model.User user = (session != null) ? (com.college.model.User) session.getAttribute("loggedUser") : null;
    if (user != null) {
        if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        } else if ("FACULTY".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
        } else if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
%>
