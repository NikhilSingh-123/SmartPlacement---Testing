<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "dashboard";
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Recruiter Panel";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | SmartPlacement Recruiter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Company-specific color overrides */
        :root {
            --sidebar-bg: #0f2744;
            --sidebar-active-bg: rgba(59, 130, 246, 0.2);
        }
        .sidebar-brand-icon { background: #1d4ed8; }
    </style>
</head>
<body>
<div class="admin-shell">

    <!-- SIDEBAR -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-brand-icon"><i class="fa-solid fa-handshake"></i></div>
            <div class="sidebar-brand-text">Smart<span>Recruiter</span></div>
        </div>

        <nav class="sidebar-nav">
            <p class="sidebar-section-label">Recruiter Hub</p>

            <a href="${pageContext.request.contextPath}/companyDashboard"
               class="sidebar-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-gauge-high"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/company/post_job.jsp"
               class="sidebar-link <%= "postjob".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-plus-circle"></i>
                <span>Post Job Drive</span>
            </a>

            <a href="${pageContext.request.contextPath}/company/manage_drives.jsp"
               class="sidebar-link <%= "drives".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-list-check"></i>
                <span>Manage Drives</span>
            </a>

            <a href="${pageContext.request.contextPath}/company/applications.jsp"
               class="sidebar-link <%= "applicants".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-users"></i>
                <span>View Applicants</span>
                <span class="sidebar-badge">New</span>
            </a>

            <a href="${pageContext.request.contextPath}/company/results.jsp"
               class="sidebar-link <%= "results".equals(currentPage) ? "active" : "" %>">
                <i class="fa-solid fa-trophy"></i>
                <span>Results</span>
            </a>

            <p class="sidebar-section-label">Company</p>

            <a href="<%=request.getContextPath()%>/LogoutServlet" class="sidebar-link"
               onclick="return confirm('Sign out of the Recruiter Panel?')">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </nav>

        <!-- Company card -->
        <div class="sidebar-footer">
            <div class="sidebar-admin-card">
                <div class="sidebar-admin-avatar" style="background: linear-gradient(135deg, #1d4ed8, #60a5fa); border-radius: 8px;">
                    <i class="fa-solid fa-building" style="font-size: 16px;"></i>
                </div>
                <div class="sidebar-admin-info">
                    <div class="sidebar-admin-name">${sessionScope.userObj.companyName}</div>
                    <div class="sidebar-admin-role">Recruiting Partner</div>
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
                <div class="topbar-breadcrumb">SmartPlacement / <%= pageTitle %></div>
            </div>

            <div class="topbar-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search drives, candidates...">
            </div>

            <div class="topbar-actions">
                <button class="topbar-icon-btn" title="Post a New Drive" onclick="window.location='${pageContext.request.contextPath}/company/post_job.jsp'">
                    <i class="fa-solid fa-plus"></i>
                </button>
                <button class="topbar-icon-btn" title="Notifications">
                    <i class="fa-solid fa-bell"></i>
                    <span class="topbar-notif-dot"></span>
                </button>
                <a href="<%=request.getContextPath()%>/LogoutServlet" class="topbar-icon-btn" title="Logout"
                   onclick="return confirm('Sign out?')" style="color: inherit;">
                    <i class="fa-solid fa-right-from-bracket"></i>
                </a>
                <div class="topbar-avatar-btn" style="background: linear-gradient(135deg, #1d4ed8, #60a5fa);">
                    ${not empty sessionScope.userObj.companyName ? sessionScope.userObj.companyName.substring(0,1).toUpperCase() : 'C'}
                </div>
            </div>
        </header>

        <!-- Alerts -->
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
        <!-- PAGE CONTENT BELOW -->
