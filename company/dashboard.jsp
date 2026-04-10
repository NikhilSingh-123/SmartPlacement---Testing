<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (session.getAttribute("company") == null || !"company".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<c:set var="currentPage" value="dashboard" scope="request" />
<c:set var="pageTitle" value="Recruiter Dashboard" scope="request" />

<jsp:include page="/includes/company_header.jsp" />

<c:set var="company" value="${sessionScope.userObj}" />
<c:set var="applied" value="${not empty funnel['APPLIED'] ? funnel['APPLIED'] : 0}" />
<c:set var="shortlisted" value="${not empty funnel['SHORTLISTED'] ? funnel['SHORTLISTED'] : 0}" />
<c:set var="selected" value="${not empty funnel['SELECTED'] ? funnel['SELECTED'] : 0}" />
<c:set var="totalApps" value="${applied + shortlisted + selected}" />

<div class="admin-content">

    <!-- Welcome Banner -->
    <div style="background: linear-gradient(135deg, #0f2744, #1d4ed8); border-radius: 16px; padding: 28px 32px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between;" class="animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800; color: white;">Welcome back, ${company.companyName} 🎯</h1>
            <p style="color: rgba(255,255,255,0.75); margin-top: 6px; font-size: 14px;">Your recruitment pipeline is active. Review your talent funnel below.</p>
        </div>
        <a href="${pageContext.request.contextPath}/company/post_job.jsp"
           class="btn" style="background: white; color: #0f2744; font-weight: 800; padding: 12px 24px; border-radius: 10px; white-space: nowrap;">
            <i class="fa-solid fa-plus"></i> Post New Drive
        </a>
    </div>

    <!-- KPI Cards -->
    <div class="stats-grid animate-in anim-d1">
        <div class="stat-card blue">
            <div class="stat-icon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="stat-info">
                <div class="stat-label">Active Drives</div>
                <div class="stat-value">${myDrives.size()}</div>
                <div class="stat-change"><i class="fa-solid fa-circle-dot"></i> Posted by you</div>
            </div>
        </div>
        <div class="stat-card purple">
            <div class="stat-icon"><i class="fa-solid fa-file-lines"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Applicants</div>
                <div class="stat-value">${totalApps}</div>
                <div class="stat-change"><i class="fa-solid fa-arrow-up"></i> All drives combined</div>
            </div>
        </div>
        <div class="stat-card orange">
            <div class="stat-icon"><i class="fa-solid fa-user-check"></i></div>
            <div class="stat-info">
                <div class="stat-label">Shortlisted</div>
                <div class="stat-value">${shortlisted}</div>
                <div class="stat-change"><i class="fa-solid fa-hourglass-half"></i> Awaiting review</div>
            </div>
        </div>
        <div class="stat-card green">
            <div class="stat-icon"><i class="fa-solid fa-trophy"></i></div>
            <div class="stat-info">
                <div class="stat-label">Final Selections</div>
                <div class="stat-value">${selected}</div>
                <div class="stat-change"><i class="fa-solid fa-check-double"></i> Offers extended</div>
            </div>
        </div>
    </div>

    <!-- Charts + Drives -->
    <div style="display: grid; grid-template-columns: 1fr 340px; gap: 24px;" class="animate-in anim-d2">

        <!-- Active Drives List -->
        <div class="card">
            <div class="card-header">
                <span class="card-title"><i class="fa-solid fa-list-check" style="color: var(--primary); margin-right: 8px;"></i>Your Active Drives</span>
                <a href="${pageContext.request.contextPath}/company/manage_drives.jsp" class="btn btn-ghost btn-sm">View All</a>
            </div>

            <c:if test="${empty myDrives}">
                <div class="empty-state">
                    <i class="fa-solid fa-briefcase"></i>
                    <h3>No Drives Posted Yet</h3>
                    <p>Post your first job drive to start attracting top talent.</p>
                    <a href="${pageContext.request.contextPath}/company/post_job.jsp" class="btn btn-primary" style="margin-top: 16px;">
                        <i class="fa-solid fa-plus"></i> Post a Drive
                    </a>
                </div>
            </c:if>

            <c:forEach var="drive" items="${myDrives}">
                <div style="padding: 16px 24px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 16px; transition: background 0.2s;"
                     onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                    <div style="width: 44px; height: 44px; background: var(--primary-light); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <i class="fa-solid fa-briefcase" style="color: var(--primary);"></i>
                    </div>
                    <div style="flex: 1; min-width: 0;">
                        <div style="font-weight: 700; color: var(--text-main);">${drive.jobRole}</div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                            <i class="fa-solid fa-location-dot"></i> ${drive.location} &bull;
                            <i class="fa-solid fa-calendar"></i> ${drive.driveDate}
                        </div>
                    </div>
                    <div style="display: flex; gap: 8px; align-items: center;">
                        <span class="badge badge-success">${drive.salaryPackage}</span>
                        <a href="${pageContext.request.contextPath}/company/applications.jsp?driveId=${drive.id}"
                           class="btn btn-ghost btn-sm">
                            <i class="fa-solid fa-eye"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Funnel Chart -->
        <div>
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Recruitment Funnel</span>
                    <i class="fa-solid fa-chart-pie" style="color: var(--primary);"></i>
                </div>
                <div class="card-body">
                    <div style="height: 200px; display: flex; align-items: center; justify-content: center;">
                        <canvas id="funnelChart"></canvas>
                    </div>
                    <div style="margin-top: 16px; border-top: 1px solid var(--border); padding-top: 16px; display: flex; flex-direction: column; gap: 10px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 13px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 10px; height: 10px; border-radius: 2px; background: var(--primary);"></div>
                                <span>Applied</span>
                            </div>
                            <strong>${applied}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 13px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 10px; height: 10px; border-radius: 2px; background: #f59e0b;"></div>
                                <span>Shortlisted</span>
                            </div>
                            <strong>${shortlisted}</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 13px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 10px; height: 10px; border-radius: 2px; background: var(--success);"></div>
                                <span>Selected</span>
                            </div>
                            <strong>${selected}</strong>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/company/applications.jsp"
                       class="btn btn-outline" style="width: 100%; margin-top: 16px; justify-content: center;">
                        View All Applicants
                    </a>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card" style="margin-top: 16px;">
                <div class="card-header"><span class="card-title">Quick Actions</span></div>
                <div class="card-body">
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <a href="${pageContext.request.contextPath}/company/post_job.jsp"
                           class="btn btn-primary" style="justify-content: center;">
                            <i class="fa-solid fa-plus"></i> Post New Drive
                        </a>
                        <a href="${pageContext.request.contextPath}/company/applications.jsp"
                           class="btn btn-outline" style="justify-content: center;">
                            <i class="fa-solid fa-users"></i> Review Applicants
                        </a>
                        <a href="${pageContext.request.contextPath}/company/results.jsp"
                           class="btn btn-ghost" style="justify-content: center;">
                            <i class="fa-solid fa-trophy"></i> Publish Results
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Initialize Funnel Chart
    const ctx = document.getElementById('funnelChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Applied', 'Shortlisted', 'Selected'],
            datasets: [{
                label: 'Candidates',
                data: [${applied}, ${shortlisted}, ${selected}],
                backgroundColor: [
                    'rgba(10, 102, 194, 0.8)',
                    'rgba(245, 158, 11, 0.8)',
                    'rgba(16, 185, 129, 0.8)'
                ],
                borderRadius: 4
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            plugins: {
                legend: { display: false }
            }
        }
    });
</script>

<jsp:include page="/includes/company_footer.jsp" />
