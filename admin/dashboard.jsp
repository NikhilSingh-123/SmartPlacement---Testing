<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
if(session.getAttribute("admin") == null){
    response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    return;
}
%>

<c:set var="currentPage" value="dashboard" scope="request" />
<c:set var="pageTitle" value="Dashboard" scope="request" />

<jsp:include page="/includes/admin_header.jsp" />

<c:set var="placementStats" value="${requestScope.placementStats}" />
<c:set var="statusStats" value="${requestScope.statusStats}" />
<c:set var="branchStats" value="${requestScope.branchStats}" />

<c:set var="placed" value="${placementStats[0]}" />
<c:set var="totalStudents" value="${placementStats[1]}" />
<c:set var="unplaced" value="${(totalStudents - placed) > 0 ? (totalStudents - placed) : 0}" />

<c:set var="applied" value="${not empty statusStats['APPLIED'] ? statusStats['APPLIED'] : 0}" />
<c:set var="shortlisted" value="${not empty statusStats['SHORTLISTED'] ? statusStats['SHORTLISTED'] : 0}" />
<c:set var="selected" value="${not empty statusStats['SELECTED'] ? statusStats['SELECTED'] : 0}" />

<c:set var="totalApps" value="${applied + shortlisted + selected}" />

<div class="admin-content">

    <!-- Page Header -->
    <div class="page-header animate-in">
        <h1>Welcome back, ${sessionScope.userObj.username} 👋</h1>
        <p>Here's what's happening across your Smart Placement ecosystem today.</p>
    </div>

    <!-- KPI STAT CARDS -->
    <div class="stats-grid">
        <div class="stat-card blue animate-in anim-d1">
            <div class="stat-icon"><i class="fa-solid fa-user-graduate"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Students</div>
                <div class="stat-value">${totalStudents}</div>
                <div class="stat-change"><i class="fa-solid fa-arrow-up"></i> Registered in system</div>
            </div>
        </div>
        <div class="stat-card green animate-in anim-d2">
            <div class="stat-icon"><i class="fa-solid fa-building"></i></div>
            <div class="stat-info">
                <div class="stat-label">Partner Companies</div>
                <div class="stat-value">${totalCompanies}</div>
                <div class="stat-change"><i class="fa-solid fa-arrow-up"></i> Active corporate network</div>
            </div>
        </div>
        <div class="stat-card purple animate-in anim-d3">
            <div class="stat-icon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="stat-info">
                <div class="stat-label">Active Job Drives</div>
                <div class="stat-value">${totalDrives}</div>
                <div class="stat-change"><i class="fa-solid fa-circle-dot"></i> Running now</div>
            </div>
        </div>
        <div class="stat-card orange animate-in anim-d4">
            <div class="stat-icon"><i class="fa-solid fa-file-circle-check"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Applications</div>
                <div class="stat-value">${totalApps}</div>
                <div class="stat-change"><i class="fa-solid fa-check-double"></i> Across all drives</div>
            </div>
        </div>
    </div>

    <!-- CHARTS ROW -->
    <div class="charts-grid animate-in anim-d3">
        <!-- Placement Doughnut -->
        <div class="card">
            <div class="card-header">
                <span class="card-title"><i class="fa-solid fa-chart-pie" style="color: var(--primary); margin-right: 8px;"></i>Placement Success Rate</span>
                <span class="badge badge-success">${totalStudents > 0 ? (placed * 100 / totalStudents) : 0}% Placed</span>
            </div>
            <div class="card-body">
                <div class="chart-canvas-wrapper">
                    <canvas id="placementChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Application Status Bar -->
        <div class="card">
            <div class="card-header">
                <span class="card-title"><i class="fa-solid fa-chart-bar" style="color: var(--purple); margin-right: 8px;"></i>Application Pipeline</span>
            </div>
            <div class="card-body">
                <div class="chart-canvas-wrapper">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- LOWER ROW: Branch Stats + Quick Actions -->
    <div style="display: grid; grid-template-columns: 1fr 320px; gap: 24px;" class="animate-in anim-d4">

        <!-- Branch-wise Performance -->
        <div class="card">
            <div class="card-header">
                <span class="card-title">Branch-wise Placement</span>
                <a href="applications.jsp" class="btn btn-ghost btn-sm">View All</a>
            </div>
            <div class="card-body">
                <c:forEach var="entry" items="${branchStats}">
                    <div style="margin-bottom: 18px;">
                        <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 600; margin-bottom: 6px;">
                            <span>${entry.key}</span>
                            <span style="color: var(--primary);">${entry.value} placed</span>
                        </div>
                        <div class="progress-bar-track">
                            <div class="progress-bar-fill" style="width: ${entry.value * 5}%; background: var(--primary);"></div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty branchStats}">
                    <p class="text-muted" style="font-size: 13px; text-align: center; padding: 32px 0;">No placement data available yet.</p>
                </c:if>
            </div>
        </div>

        <!-- Quick Actions Panel -->
        <div class="card" style="align-self: start;">
            <div class="card-header">
                <span class="card-title">Quick Actions</span>
            </div>
            <div class="card-body">
                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/addCompany.jsp" class="btn btn-primary" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-plus"></i> Add Company
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manage_companies.jsp" class="btn btn-outline" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-building"></i> Manage Companies
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manage_drives.jsp" class="btn btn-ghost" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-briefcase"></i> View Job Drives
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/applications.jsp" class="btn btn-ghost" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-file-lines"></i> Review Applications
                    </a>
                </div>

                <!-- System Status -->
                <div style="margin-top: 24px; border-top: 1px solid var(--border); padding-top: 16px;">
                    <p style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-muted); margin-bottom: 12px; letter-spacing: 0.06em;">System Status</p>
                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <div style="display: flex; align-items: center; gap: 8px; font-size: 12.5px;">
                            <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--success); box-shadow: 0 0 6px rgba(5,118,66,0.5);"></div>
                            <span style="flex: 1; font-weight: 600;">Auth Services</span>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px; font-size: 12.5px;">
                            <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--success); box-shadow: 0 0 6px rgba(5,118,66,0.5);"></div>
                            <span style="flex: 1; font-weight: 600;">Database</span>
                            <span class="badge badge-success">Stable</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px; font-size: 12.5px;">
                            <div style="width: 8px; height: 8px; border-radius: 50%; background: var(--success); box-shadow: 0 0 6px rgba(5,118,66,0.5);"></div>
                            <span style="flex: 1; font-weight: 600;">Notification Engine</span>
                            <span class="badge badge-success">Active</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div><!-- /.admin-content -->

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Placement Chart
    const pCtx = document.getElementById('placementChart').getContext('2d');
    new Chart(pCtx, {
        type: 'doughnut',
        data: {
            labels: ['Placed', 'Seeking Placement'],
            datasets: [{
                data: [${placed}, ${unplaced}],
                backgroundColor: ['#057642', '#e2e8f0'],
                borderWidth: 0,
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            cutout: '78%',
            plugins: {
                legend: { position: 'bottom', labels: { padding: 20, font: { size: 12, weight: '600' } } }
            }
        }
    });

    // Status bar chart
    const sCtx = document.getElementById('statusChart').getContext('2d');
    new Chart(sCtx, {
        type: 'bar',
        data: {
            labels: ['Applied', 'Shortlisted', 'Selected'],
            datasets: [{
                label: 'Candidates',
                data: [${applied}, ${shortlisted}, ${selected}],
                backgroundColor: ['#0a66c2', '#d97706', '#057642'],
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: '#f1f5f9' } }
            }
        }
    });
</script>

<jsp:include page="/includes/admin_footer.jsp" />
