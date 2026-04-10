<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="elite-sidebar card" style="overflow: hidden;">
    <div class="cover-photo" style="height: 84px;">
        <img src="<%=request.getContextPath()%>/images/cover_default.png" alt="Cover">
    </div>
    <div style="padding: 0 16px 16px; text-align: center; border-bottom: 1px solid var(--border); position: relative; margin-top: -36px;">
        <div class="profile-avatar-wrapper" style="margin: 0 auto 12px; border: 4px solid var(--surface); width: 72px; height: 72px; border-radius: 50%; overflow: hidden; background: var(--surface); display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-sm); z-index: 5; position: relative;">
            <c:choose>
                <c:when test="${not empty sessionScope.student.profilePhoto}">
                    <img src="<%=request.getContextPath()%>/${sessionScope.student.profilePhoto}" style="width: 100%; height: 100%; object-fit: cover;" alt="Profile">
                </c:when>
                <c:otherwise>
                    <img src="<%=request.getContextPath()%>/images/default.png" style="width: 100%; height: 100%; object-fit: cover;" alt="Profile">
                </c:otherwise>
            </c:choose>
        </div>
        <h3 style="font-size: 16px; margin: 0; font-weight: 700; color: var(--text-main);">${sessionScope.student.name}</h3>
        <p style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">${sessionScope.student.branch} Engineering</p>
    </div>
    
    <ul class="sidebar-menu">
        <li class="${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
            <a href="<%=request.getContextPath()%>/student/dashboard.jsp" class="active">
                <i class="fa-solid fa-gauge-high"></i> Dashboard
            </a>
        </li>
        <li class="${pageContext.request.requestURI.contains('profile') ? 'active' : ''}">
            <a href="<%=request.getContextPath()%>/student/profile.jsp">
                <i class="fa-solid fa-user-circle"></i> View Profile
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/student/profile.jsp#resume">
                <i class="fa-solid fa-file-pdf"></i> Upload Resume
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/student/jobs.jsp">
                <i class="fa-solid fa-building"></i> Top Companies
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/student/my_applications.jsp">
                <i class="fa-solid fa-clock-rotate-left"></i> Applied Jobs
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/student/results.jsp">
                <i class="fa-solid fa-square-poll-vertical"></i> Placement Status
            </a>
        </li>
        <li>
            <a href="<%=request.getContextPath()%>/student/feedback.jsp">
                <i class="fa-solid fa-comment-dots"></i> Feedback hub
            </a>
        </li>
        <li style="margin-top: 20px; border-top: 1px solid var(--border);">
            <a href="<%=request.getContextPath()%>/LogoutServlet" style="color: var(--danger);">
                <i class="fa-solid fa-power-off"></i> Sign Out
            </a>
        </li>
    </ul>
</aside>
