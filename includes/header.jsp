<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
   response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
   response.setHeader("Pragma", "no-cache");
   response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Placement | Professional Career Portal</title>
    
    <!-- Design Foundation -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Motion Engine (AOS) -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <script>
        (function() {
            const theme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', theme);
        })();
    </script>
</head>
<body>

<!-- Page Loader (Micro-interaction) -->
<div id="page-loader" style="position: fixed; top: 0; left: 0; width: 0; height: 3px; background: var(--primary); z-index: 2000; transition: width 0.4s ease-out; box-shadow: 0 0 10px var(--primary-glow);"></div>

<nav class="navbar">
    <div class="nav-container">
        <!-- Brand Identity -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
            <i class="fa-solid fa-square-poll-vertical"></i>
            <span>SmartPlacement</span>
        </a>

        <!-- Universal Search Hub -->
        <div class="nav-search">
            <div class="search-wrapper" style="position: relative;">
                <i class="fa-solid fa-magnifying-glass"></i>
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="text" name="query" class="search-input" placeholder="Search jobs, recruiters..." value="${searchQuery}" autocomplete="off">
                </form>
            </div>
        </div>

        <!-- Semantic Navigation Hub (LinkedIn Horizontal Style) -->
        <div class="nav-links" style="display: flex; align-items: center; gap: 4px;">
            <c:set var="user" value="${not empty sessionScope.student ? sessionScope.student : (not empty sessionScope.company ? sessionScope.company : sessionScope.admin)}" />
            <c:choose>
                <c:when test="${not empty user}">
                    <!-- Dynamic Dashboard Redirect -->
                    <c:set var="dashUrl" value="${pageContext.request.contextPath}/${sessionScope.role}Dashboard" />
                    
                    <a href="${dashUrl}" class="nav-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                        <i class="fa-solid fa-house"></i>
                        <span>Home</span>
                    </a>

                    <c:if test="${sessionScope.role == 'student'}">
                        <a href="${pageContext.request.contextPath}/student/jobs.jsp" class="nav-item">
                            <i class="fa-solid fa-briefcase"></i>
                            <span>Jobs</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/notifications.jsp" class="nav-item">
                            <i class="fa-solid fa-bell"></i>
                            <span class="nav-badge" style="position: absolute; top: 8px; right: 24px; background: var(--danger); color: white; border-radius: 50%; width: 14px; height: 14px; font-size: 8px; display: flex; align-items: center; justify-content: center; border: 1.5px solid white;">3</span>
                            <span>Alerts</span>
                        </a>
                    </c:if>

                    <!-- Profile Dropdown Component -->
                    <div class="nav-item" style="cursor: pointer;" onclick="document.getElementById('profileMenu').classList.toggle('show')">
                        <div style="width: 24px; height: 24px; border-radius: 50%; overflow: hidden; border: 1.5px solid var(--border); margin-bottom: 2px;">
                            <c:choose>
                                <c:when test="${not empty user.profilePhoto}">
                                    <img src="<%=request.getContextPath()%>/${user.profilePhoto}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width: 100%; height: 100%; background: var(--primary-light); color: var(--primary); font-size: 10px; font-weight: 800; display: flex; align-items: center; justify-content: center;">
                                        ${not empty user.name ? user.name.substring(0,1).toUpperCase() : 'U'}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <span style="display: flex; align-items: center; gap: 2px;">Me <i class="fa-solid fa-caret-down" style="font-size: 10px;"></i></span>
                        <div id="profileMenu" class="card" style="position: absolute; top: 56px; right: 0; width: 280px; display: none; z-index: 1001; text-align: left; box-shadow: var(--shadow-lg);">
                            <!-- Dropdown Content as before -->
                             <div style="padding: 16px; border-bottom: 1px solid var(--border); display: flex; gap: 12px; align-items: center;">
                                <div style="font-weight: 700;">${user.name}</div>
                            </div>
                            <div style="padding: 8px 0;">
                                <a href="${pageContext.request.contextPath}/${sessionScope.role}/profile.jsp" style="display: block; padding: 8px 16px; color: var(--text-main); font-weight: 600; font-size: 13px; text-decoration: none;">View Profile</a>
                                <a href="<%=request.getContextPath()%>/LogoutServlet" style="display: block; padding: 8px 16px; color: var(--danger); font-size: 13px; text-decoration: none;">Sign Out</a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; gap: 12px; margin-left: 24px;">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline" style="padding: 6px 16px; border-radius: 4px;">Sign in</a>
                        <a href="${pageContext.request.contextPath}/student/register.jsp" class="btn btn-primary" style="padding: 6px 16px; border-radius: 4px;">Join now</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- System Messaging Hub -->
<div style="max-width: 1128px; margin: 72px auto 0; padding: 0 16px;">
    <c:if test="${not empty sessionScope.msg || not empty sessionScope.succMsg}">
        <div class="badge badge-success reveal" style="width: 100%; padding: 12px; text-align: center; margin-bottom: 8px;">
            <i class="fa-solid fa-circle-check"></i> ${sessionScope.msg}${sessionScope.succMsg}
        </div>
        <c:remove var="msg" scope="session"/><c:remove var="succMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error || not empty sessionScope.errorMsg}">
        <div class="badge badge-error reveal" style="width: 100%; padding: 12px; text-align: center; margin-bottom: 8px; background: #fee2e2; color: #dc2626;">
            <i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.error}${sessionScope.errorMsg}
        </div>
        <c:remove var="error" scope="session"/><c:remove var="errorMsg" scope="session"/>
    </c:if>
</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    // Initialize Animations
    AOS.init({ duration: 800, once: true, easing: 'ease-out-quad' });
    
    // Page load progress bar simulation
    window.addEventListener('load', () => {
        const loader = document.getElementById('page-loader');
        loader.style.width = '100%';
        setTimeout(() => { loader.style.opacity = '0'; }, 300);
    });

    // Close dropdowns on outside click
    window.onclick = function(event) {
        if (!event.target.closest('.nav-item')) {
            const dropdown = document.getElementById('profileMenu');
            if (dropdown) dropdown.classList.remove('show');
        }
    }
</script>

<style>
    #profileMenu.show { display: block !important; }
</style>
