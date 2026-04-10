<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.model.*, java.util.*" %>

<%
    if (session.getAttribute("student") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<jsp:include page="/includes/header.jsp" />

<c:set var="student" value="${sessionScope.student}" />
<c:set var="applied" value="${requestScope.stats['APPLIED'] != null ? requestScope.stats['APPLIED'] : 0}" />
<c:set var="shortlisted" value="${requestScope.stats['SHORTLISTED'] != null ? requestScope.stats['SHORTLISTED'] : 0}" />
<c:set var="selected" value="${requestScope.stats['SELECTED'] != null ? requestScope.stats['SELECTED'] : 0}" />
<c:set var="rejected" value="${requestScope.stats['REJECTED'] != null ? requestScope.stats['REJECTED'] : 0}" />

<div style="max-width: 1280px; margin: 80px auto 32px; display: grid; grid-template-columns: 250px 1fr 300px; gap: 24px; padding: 0 16px; align-items: start;">
    
    <!-- LEFT PANEL: IDENTITY HUB -->
    <div class="reveal reveal-delay-1">
        <jsp:include page="/includes/student_sidebar.jsp" />
    </div>

    <!-- CENTER PANEL: OPPORTUNITY FEED -->
    <main class="reveal reveal-delay-2">
        <!-- 1. LinkedIn Elite Identity Hub -->
        <div class="card" style="margin-bottom: 24px; overflow: hidden;">
            <div class="cover-photo">
                <img src="<%=request.getContextPath()%>/images/cover_default.png" alt="Cover">
                <div class="profile-overlap">
                    <c:choose>
                        <c:when test="${not empty student.profilePhoto}">
                            <img src="<%=request.getContextPath()%>/${student.profilePhoto}" alt="Profile">
                        </c:when>
                        <c:otherwise>
                            <img src="<%=request.getContextPath()%>/images/default.png" alt="Profile">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="identity-content">
                <div style="display: flex; justify-content: space-between; align-items: start;">
                    <div>
                        <h1 style="font-size: 24px; font-weight: 800; margin: 0; color: var(--text-main); font-family: var(--font-heading);">${student.name}</h1>
                        <p style="font-size: 15px; color: var(--text-muted); margin-top: 4px;">Candidate at SmartPlacement | ${student.branch} Engineering</p>
                        <div style="margin-top: 12px; display: flex; gap: 8px;">
                            <span class="badge badge-primary">${student.collegeName}</span>
                            <span class="badge badge-success">${student.cgpa} CGPA</span>
                        </div>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <a href="<%=request.getContextPath()%>/student/profile.jsp" class="btn btn-primary" style="padding: 8px 24px;">Edit Profile</a>
                        <a href="<%=request.getContextPath()%>/student/jobs.jsp" class="btn btn-outline" style="padding: 8px 24px;">Job Feed</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. Dynamic Recruitment Hub -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <h2 style="font-size: 18px; font-weight: 800; color: var(--text-main); margin: 0;">Recommended For You</h2>
            <div style="display: flex; gap: 8px;">
                <span class="badge badge-primary">Skill Match</span>
                <span class="badge badge-success">High Probability</span>
            </div>
        </div>

        <c:if test="${empty requestScope.drives}">
             <div class="card" style="padding: 60px 40px; text-align: center;">
                <i class="fa-solid fa-bolt-lightning" style="font-size: 48px; color: var(--border); margin-bottom: 16px;"></i>
                <h3 style="color: var(--text-muted); font-weight: 700;">Scanning Ecosystem...</h3>
                <p style="font-size: 14px; color: var(--text-muted);">We are analyzing new recruitment pulses. Check back shortly.</p>
            </div>
        </c:if>

        <c:forEach var="drive" items="${requestScope.drives}">
            <div class="card" style="padding: 24px; margin-bottom: 16px; border-left: 5px solid var(--primary); transition: transform 0.2s;">
                <div style="display: flex; gap: 20px;">
                    <div style="width: 64px; height: 64px; border-radius: 8px; border: 1px solid var(--border); background: var(--primary-light); display: flex; align-items: center; justify-content: center; overflow: hidden;">
                         <i class="fa-solid fa-building" style="font-size: 28px; color: var(--primary);"></i>
                    </div>
                    <div style="flex: 1;">
                        <span style="font-size: 11px; font-weight: 800; color: var(--primary); text-transform: uppercase; letter-spacing: 0.02em;">Verified Opportunity</span>
                        <h3 style="font-size: 20px; font-weight: 800; margin: 4px 0 8px; color: var(--text-main);">${drive.companyName} | ${drive.jobRole}</h3>
                        <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 14px; color: var(--text-muted);">
                            <span><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> ${drive.location}</span>
                            <span><i class="fa-solid fa-indian-rupee-sign" style="color: var(--success);"></i> ${drive.salaryPackage}</span>
                            <span><i class="fa-solid fa-graduation-cap" style="color: var(--warning);"></i> ${drive.eligibilityCgpa} CGPA</span>
                        </div>
                        <p style="margin-top: 16px; font-size: 15px; color: var(--text-muted); line-height: 1.6;">${drive.description}</p>
                        
                        <div style="margin-top: 24px;">
                            <c:choose>
                                <c:when test="${student.cgpa >= drive.eligibilityCgpa}">
                                    <c:choose>
                                        <c:when test="${drive.applied}">
                                            <button class="btn btn-primary" style="background: var(--success); border: none; cursor: default;" disabled>
                                                <i class="fa-solid fa-circle-check"></i> Applied Successfully
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<%=request.getContextPath()%>/studentAction?action=applyJob&driveId=${drive.id}" class="btn btn-primary">Apply Now</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-outline" disabled style="color: var(--danger); border-color: var(--danger); opacity: 0.6;">
                                        <i class="fa-solid fa-lock"></i> Low Eligibility (${drive.eligibilityCgpa})
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </main>

    <!-- RIGHT PANEL: ANALYTICS & HUB -->
    <div class="reveal reveal-delay-3">
        <!-- 1. Stats Insight Card -->
        <div class="card" style="padding: 20px; margin-bottom: 24px;">
            <h3 style="font-size: 16px; font-weight: 800; border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 16px;">Placement Performance</h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                <div style="background: var(--primary-light); padding: 12px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: var(--primary);">${applied}</div>
                    <div style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Applied</div>
                </div>
                <div style="background: #f0fdf4; padding: 12px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: var(--success);">${selected}</div>
                    <div style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Selected</div>
                </div>
                <div style="background: #fefce8; padding: 12px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: var(--warning);">${shortlisted}</div>
                    <div style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Interview</div>
                </div>
                <div style="background: #fef2f2; padding: 12px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 24px; font-weight: 800; color: var(--danger);">${rejected}</div>
                    <div style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Rejected</div>
                </div>
            </div>
        </div>

        <!-- 2. Recent Recruitment Pulses -->
        <div class="card" style="padding: 20px;">
            <h3 style="font-size: 16px; font-weight: 800; border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 16px;">Recruitment Pulse</h3>
            <div style="display: flex; flex-direction: column; gap: 16px;">
                 <c:if test="${empty requestScope.notifications}">
                    <div style="text-align: center; padding: 20px 0; color: var(--text-muted); font-size: 13px;">
                        <i class="fa-solid fa-moon" style="font-size: 24px; margin-bottom: 8px; opacity: 0.3;"></i>
                        <p>No new notifications today.</p>
                    </div>
                 </c:if>
                 <c:forEach var="note" items="${requestScope.notifications}">
                    <div style="display: flex; gap: 12px;">
                        <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--primary); margin-top: 6px;"></div>
                        <div>
                            <div style="font-size: 14px; font-weight: 700; color: var(--text-main);">${note.title}</div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">${note.message}</div>
                        </div>
                    </div>
                 </c:forEach>
            </div>
            <a href="<%=request.getContextPath()%>/student/notifications.jsp" style="display: block; margin-top: 20px; text-align: center; font-size: 13px; font-weight: 700; color: var(--primary); text-decoration: none;">View All Alerts</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />