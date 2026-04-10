<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "dashboard";
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Admin Panel";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | SmartPlacement Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="admin-shell">

    <!-- SIDEBAR -->
    <aside class="admin-sidebar">
        <!-- Brand -->
        <div class="sidebar-brand">
            <div class="sidebar-brand-icon"><i class="fa-solid fa-chart-column"></i></div>
            <div class="sidebar-brand-text">Smart<span>Placement</span></div>
        </div>

        <!-- Navigation -->
        <nav class="sidebar-nav">
            <p class="sidebar-section-label">Main Menu</p>

            <a href="${pageContext.request.contextPath}/adminDashboard"
               class="sidebar-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-gauge-high"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/manage_companies.jsp"
               class="sidebar-link <%= "companies".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-building"></i>
                <span>Manage Companies</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/manage_drives.jsp"
               class="sidebar-link <%= "drives".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-briefcase"></i>
                <span>Job Drives</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/applications.jsp"
               class="sidebar-link <%= "applications".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-file-lines"></i>
                <span>Applications</span>
            </a>

            <p class="sidebar-section-label">Analytics</p>

            <a href="${pageContext.request.contextPath}/adminDashboard#analytics"
               class="sidebar-link <%= "analytics".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-chart-bar"></i>
                <span>Reports</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/feedback.jsp"
               class="sidebar-link">
                <i class="fa-solid fa-comments"></i>
                <span>Feedback</span>
                <span class="sidebar-badge">!</span>
            </a>

            <p class="sidebar-section-label">System</p>

            <a href="<%=request.getContextPath()%>/LogoutServlet" class="sidebar-link"
               onclick="return confirm('Log out of Admin Panel?')">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </nav>

        <!-- Admin card -->
        <div class="sidebar-footer">
            <div class="sidebar-admin-card">
                <div class="sidebar-admin-avatar">
                    ${not empty sessionScope.userObj.username ? sessionScope.userObj.username.substring(0,1).toUpperCase() : 'A'}
                </div>
                <div class="sidebar-admin-info">
                    <div class="sidebar-admin-name">${sessionScope.userObj.username}</div>
                    <div class="sidebar-admin-role">System Administrator</div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN AREA -->
    <div class="admin-main">
        <!-- TOP BAR -->
        <header class="admin-topbar">
            <div>
                <div class="topbar-page-title"><%= pageTitle %></div>
                <div class="topbar-breadcrumb">SmartPlacement Admin / <%= pageTitle %></div>
            </div>

            <div class="topbar-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search anything...">
            </div>

            <div class="topbar-actions">
                <button class="topbar-icon-btn" title="Notifications">
                    <i class="fa-solid fa-bell"></i>
                    <span class="topbar-notif-dot"></span>
                </button>
                <button class="topbar-icon-btn" title="Settings">
                    <i class="fa-solid fa-gear"></i>
                </button>
                <div class="topbar-avatar-btn" title="${sessionScope.userObj.username}">
                    ${not empty sessionScope.userObj.username ? sessionScope.userObj.username.substring(0,1).toUpperCase() : 'A'}
                </div>
            </div>
        </header>

        <!-- Alerts from session -->
        <div style="padding: 0 28px;">
            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-success" style="margin-top: 16px;">
                    <i class="fa-solid fa-circle-check"></i> ${sessionScope.msg}
                </div>
                <c:remove var="msg" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger" style="margin-top: 16px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
        </div>

        <!-- PAGE CONTENT GOES BELOW -->
