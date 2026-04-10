<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.JobDriveDAO, com.smartplacement.model.JobDrive, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'admin'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "drives");
    request.setAttribute("pageTitle", "Job Drives");
    JobDriveDAO jDao = new JobDriveDAO();
    List<JobDrive> drives = jDao.getAllDrives();
    request.setAttribute("drives", drives);
%>

<jsp:include page="/includes/admin_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Job Drives</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                Monitor and manage all <%= drives.size() %> active recruitment drives across the platform.
            </p>
        </div>
    </div>

    <!-- Mini Stats Row -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin: 20px 0;" class="animate-in anim-d1">
        <div class="stat-card purple" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-briefcase"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Drives</div>
                <div class="stat-value" style="font-size: 22px;"><%= drives.size() %></div>
            </div>
        </div>
        <div class="stat-card green" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-circle-dot"></i></div>
            <div class="stat-info">
                <div class="stat-label">Active Now</div>
                <div class="stat-value" style="font-size: 22px;"><%= drives.size() %></div>
            </div>
        </div>
        <div class="stat-card orange" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-calendar-day"></i></div>
            <div class="stat-info">
                <div class="stat-label">This Week</div>
                <div class="stat-value" style="font-size: 22px;">—</div>
            </div>
        </div>
    </div>

    <!-- Drives Table -->
    <div class="table-wrapper animate-in anim-d2">
        <div class="table-toolbar">
            <div class="table-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="driveSearch" placeholder="Search by role or company...">
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 13px; color: var(--text-muted);"><%= drives.size() %> drives found</span>
            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Job Role</th>
                    <th>Company</th>
                    <th>Location</th>
                    <th>Package</th>
                    <th>Min CGPA</th>
                    <th>Drive Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="driveBody">
                <c:forEach var="d" items="${drives}" varStatus="s">
                    <tr class="drive-row">
                        <td class="text-muted" style="font-size: 12px;">${s.count}</td>
                        <td>
                            <div class="drive-role" style="font-weight: 700; color: var(--text-main);">${d.jobRole}</div>
                        </td>
                        <td>
                            <div class="table-cell-with-logo">
                                <div class="table-company-logo" style="background: var(--purple-bg); color: var(--purple);">
                                    ${d.companyName.substring(0,1).toUpperCase()}
                                </div>
                                <span class="font-bold drive-company">${d.companyName}</span>
                            </div>
                        </td>
                        <td><span class="text-muted">${d.location}</span></td>
                        <td><span class="badge badge-success">${d.salaryPackage}</span></td>
                        <td><span class="badge badge-warning">${d.eligibilityCgpa}+</span></td>
                        <td><span class="text-muted">${d.driveDate}</span></td>
                        <td><span class="badge badge-primary">Active</span></td>
                        <td>
                            <div style="display: flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/admin/applications.jsp?driveId=${d.id}"
                                   class="btn btn-ghost btn-sm" title="View applicants">
                                    <i class="fa-solid fa-users"></i> Applicants
                                </a>
                                <a href="${pageContext.request.contextPath}/adminAction?action=deleteDrive&id=${d.id}"
                                   class="btn btn-danger-ghost btn-sm"
                                   onclick="return confirm('Delete drive for ${d.jobRole}? All applications will be removed.')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty drives}">
            <div class="empty-state">
                <i class="fa-solid fa-briefcase"></i>
                <h3>No Active Drives</h3>
                <p>Collaborate with partner companies to launch new recruitment drives.</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.getElementById('driveSearch').addEventListener('keyup', function () {
        const filter = this.value.toUpperCase();
        document.querySelectorAll('.drive-row').forEach(row => {
            const role    = row.querySelector('.drive-role')?.innerText.toUpperCase() || '';
            const company = row.querySelector('.drive-company')?.innerText.toUpperCase() || '';
            row.style.display = (role.includes(filter) || company.includes(filter)) ? '' : 'none';
        });
    });
</script>

<jsp:include page="/includes/admin_footer.jsp" />
