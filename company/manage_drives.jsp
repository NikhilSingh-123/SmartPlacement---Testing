<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.JobDriveDAO, com.smartplacement.model.*, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'company'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "drives");
    request.setAttribute("pageTitle", "Manage Drives");

    Company company = (Company) session.getAttribute("userObj");
    JobDriveDAO driveDao = new JobDriveDAO();
    List<JobDrive> myDrives = driveDao.getDrivesByCompany(company.getId());
    request.setAttribute("myDrives", myDrives);
%>

<jsp:include page="/includes/company_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">My Job Drives</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                You have posted <%= myDrives.size() %> recruitment drive<%= myDrives.size() != 1 ? "s" : "" %>.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/company/post_job.jsp" class="btn btn-primary">
            <i class="fa-solid fa-plus"></i> Post New Drive
        </a>
    </div>

    <div class="table-wrapper animate-in anim-d1">
        <div class="table-toolbar">
            <div class="table-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="driveSearch" placeholder="Search by role or location...">
            </div>
            <span style="font-size: 13px; color: var(--text-muted);"><%= myDrives.size() %> drives found</span>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Job Role</th>
                    <th>Package</th>
                    <th>Min CGPA</th>
                    <th>Location</th>
                    <th>Drive Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="driveBody">
                <c:forEach var="d" items="${myDrives}" varStatus="s">
                    <tr class="drive-row">
                        <td class="text-muted" style="font-size: 12px;">${s.count}</td>
                        <td>
                            <div class="table-cell-with-logo">
                                <div class="table-company-logo" style="background: var(--primary-light); color: var(--primary);">
                                    <i class="fa-solid fa-briefcase" style="font-size: 13px;"></i>
                                </div>
                                <div>
                                    <div class="table-name-label drive-role">${d.jobRole}</div>
                                    <div class="table-sub-label">${d.location}</div>
                                </div>
                            </div>
                        </td>
                        <td><span class="badge badge-success">${d.salaryPackage}</span></td>
                        <td><span class="badge badge-warning">${d.eligibilityCgpa}+</span></td>
                        <td class="text-muted drive-location">${d.location}</td>
                        <td class="text-muted">${d.driveDate}</td>
                        <td><span class="badge badge-primary">Active</span></td>
                        <td>
                            <div style="display: flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/company/applications.jsp?driveId=${d.id}"
                                   class="btn btn-ghost btn-sm">
                                    <i class="fa-solid fa-users"></i> Applicants
                                </a>
                                <a href="${pageContext.request.contextPath}/companyAction?action=deleteDrive&id=${d.id}"
                                   class="btn btn-danger-ghost btn-sm"
                                   onclick="return confirm('Delete this drive? All applications will be removed.')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty myDrives}">
            <div class="empty-state">
                <i class="fa-solid fa-briefcase"></i>
                <h3>No Drives Posted Yet</h3>
                <p>Post your first recruitment drive to start attracting qualified candidates.</p>
                <a href="${pageContext.request.contextPath}/company/post_job.jsp" class="btn btn-primary" style="margin-top: 16px;">
                    <i class="fa-solid fa-plus"></i> Post a Drive
                </a>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.getElementById('driveSearch').addEventListener('keyup', function () {
        const filter = this.value.toUpperCase();
        document.querySelectorAll('.drive-row').forEach(row => {
            const role = row.querySelector('.drive-role')?.innerText.toUpperCase() || '';
            const loc  = row.querySelector('.drive-location')?.innerText.toUpperCase() || '';
            row.style.display = (role.includes(filter) || loc.includes(filter)) ? '' : 'none';
        });
    });
</script>

<jsp:include page="/includes/company_footer.jsp" />
