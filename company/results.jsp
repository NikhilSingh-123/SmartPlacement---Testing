<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.*, com.smartplacement.model.*, java.util.*" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'company'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "results");
    request.setAttribute("pageTitle", "Results");

    Company company = (Company) session.getAttribute("userObj");
    StudentDAO sDao = new StudentDAO();
    JobDriveDAO jDao = new JobDriveDAO();

    List<JobDrive> myDrives = jDao.getDrivesByCompany(company.getId());

    // Collect selected students across all company drives
    List<Student> selectedStudents = new ArrayList<>();
    List<Student> shortlistedStudents = new ArrayList<>();
    for (JobDrive drive : myDrives) {
        List<Student> driveStudents = sDao.getStudentsByDrive(drive.getId());
        for (Student s : driveStudents) {
            if ("SELECTED".equalsIgnoreCase(s.getStatus())) selectedStudents.add(s);
            else if ("SHORTLISTED".equalsIgnoreCase(s.getStatus())) shortlistedStudents.add(s);
        }
    }
    request.setAttribute("selectedStudents", selectedStudents);
    request.setAttribute("shortlistedStudents", shortlistedStudents);
    request.setAttribute("myDrives", myDrives);
%>

<jsp:include page="/includes/company_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Placement Results</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                Publish final selections and manage your placement outcomes.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/company/applications.jsp" class="btn btn-ghost">
            <i class="fa-solid fa-arrow-left"></i> Back to Applicants
        </a>
    </div>

    <!-- Outcome Stats -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 28px;" class="animate-in anim-d1">
        <div class="stat-card green">
            <div class="stat-icon"><i class="fa-solid fa-trophy"></i></div>
            <div class="stat-info">
                <div class="stat-label">Final Selections</div>
                <div class="stat-value"><%= selectedStudents.size() %></div>
                <div class="stat-change"><i class="fa-solid fa-check-double"></i> Offers confirmed</div>
            </div>
        </div>
        <div class="stat-card orange">
            <div class="stat-icon"><i class="fa-solid fa-hourglass-half"></i></div>
            <div class="stat-info">
                <div class="stat-label">Shortlisted</div>
                <div class="stat-value"><%= shortlistedStudents.size() %></div>
                <div class="stat-change"><i class="fa-solid fa-clock"></i> Awaiting final call</div>
            </div>
        </div>
        <div class="stat-card blue">
            <div class="stat-icon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="stat-info">
                <div class="stat-label">Active Drives</div>
                <div class="stat-value"><%= myDrives.size() %></div>
                <div class="stat-change"><i class="fa-solid fa-circle-dot"></i> Drives evaluated</div>
            </div>
        </div>
    </div>

    <!-- Publish Results Banner -->
    <div style="background: linear-gradient(135deg, #064e3b, #059669); border-radius: 16px; padding: 24px 32px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between;" class="animate-in anim-d1">
        <div>
            <div style="font-size: 18px; font-weight: 800; color: white;">
                <i class="fa-solid fa-bullhorn" style="margin-right: 10px;"></i>
                Ready to publish final results?
            </div>
            <p style="color: rgba(255,255,255,0.8); margin-top: 6px; font-size: 14px;">
                Publishing notifies all selected and shortlisted students instantly via their dashboards.
            </p>
        </div>
        <button class="btn" style="background: white; color: #064e3b; font-weight: 800; padding: 12px 24px; border-radius: 10px; white-space: nowrap;"
                onclick="publishResults()">
            <i class="fa-solid fa-paper-plane"></i> Publish Results
        </button>
    </div>

    <!-- Two-column: Selected + Shortlisted -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;" class="animate-in anim-d2">

        <!-- SELECTED -->
        <div class="card">
            <div class="card-header" style="background: var(--success-bg);">
                <span class="card-title" style="color: var(--success);">
                    <i class="fa-solid fa-trophy"></i> Final Selections
                </span>
                <span class="badge badge-success"><%= selectedStudents.size() %> Students</span>
            </div>

            <c:if test="${empty selectedStudents}">
                <div class="empty-state" style="padding: 40px;">
                    <i class="fa-solid fa-trophy" style="font-size: 36px;"></i>
                    <h3 style="font-size: 16px;">No Selections Yet</h3>
                    <p style="font-size: 13px;">Approve applicants from the View Applicants page.</p>
                </div>
            </c:if>

            <c:forEach var="s" items="${selectedStudents}" varStatus="idx">
                <div style="padding: 16px 20px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 14px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--success-bg); color: var(--success); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 16px; flex-shrink: 0;">
                        ${s.name.substring(0,1).toUpperCase()}
                    </div>
                    <div style="flex: 1; min-width: 0;">
                        <div style="font-weight: 700;">${s.name}</div>
                        <div class="text-muted" style="font-size: 12px;">${s.branch} &bull; CGPA: ${s.cgpa}</div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <span class="badge badge-success">Selected</span>
                        <a href="mailto:${s.email}" class="btn btn-ghost btn-sm" title="Email">
                            <i class="fa-solid fa-envelope"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- SHORTLISTED -->
        <div class="card">
            <div class="card-header" style="background: var(--warning-bg);">
                <span class="card-title" style="color: var(--warning);">
                    <i class="fa-solid fa-hourglass-half"></i> Shortlisted
                </span>
                <span class="badge badge-warning"><%= shortlistedStudents.size() %> Students</span>
            </div>

            <c:if test="${empty shortlistedStudents}">
                <div class="empty-state" style="padding: 40px;">
                    <i class="fa-solid fa-hourglass-start" style="font-size: 36px;"></i>
                    <h3 style="font-size: 16px;">No Shortlisted Candidates</h3>
                    <p style="font-size: 13px;">Shortlist candidates from the Applicants page.</p>
                </div>
            </c:if>

            <c:forEach var="s" items="${shortlistedStudents}" varStatus="idx">
                <div style="padding: 16px 20px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 14px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--warning-bg); color: var(--warning); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 16px; flex-shrink: 0;">
                        ${s.name.substring(0,1).toUpperCase()}
                    </div>
                    <div style="flex: 1; min-width: 0;">
                        <div style="font-weight: 700;">${s.name}</div>
                        <div class="text-muted" style="font-size: 12px;">${s.branch} &bull; CGPA: ${s.cgpa}</div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 6px;">
                        <a href="${pageContext.request.contextPath}/companyAction?action=select&studentId=${s.id}"
                           class="btn btn-success btn-sm"
                           title="Confirm Selection" onclick="return confirm('Confirm selection for ${s.name}?')">
                            <i class="fa-solid fa-check"></i> Confirm
                        </a>
                        <a href="${pageContext.request.contextPath}/companyAction?action=reject&studentId=${s.id}"
                           class="btn btn-danger-ghost btn-sm"
                           title="Reject" onclick="return confirm('Reject ${s.name}?')">
                            <i class="fa-solid fa-xmark"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Drive-wise Summary Table -->
    <div class="card" style="margin-top: 24px;" class="animate-in anim-d3">
        <div class="card-header">
            <span class="card-title"><i class="fa-solid fa-chart-bar" style="color: var(--primary); margin-right: 8px;"></i>Drive-wise Performance Summary</span>
        </div>
        <div class="table-wrapper" style="border: none; box-shadow: none; border-radius: 0;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Drive / Role</th>
                        <th>Drive Date</th>
                        <th>Package</th>
                        <th>Min CGPA</th>
                        <th>Applicants</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${myDrives}" varStatus="idx">
                        <tr>
                            <td class="text-muted">${idx.count}</td>
                            <td>
                                <div style="font-weight: 700;">${d.jobRole}</div>
                                <div class="text-muted" style="font-size: 12px;">${d.location}</div>
                            </td>
                            <td class="text-muted">${d.driveDate}</td>
                            <td><span class="badge badge-success">${d.salaryPackage}</span></td>
                            <td><span class="badge badge-warning">${d.eligibilityCgpa}+</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/company/applications.jsp?driveId=${d.id}"
                                   class="btn btn-ghost btn-sm">
                                    <i class="fa-solid fa-eye"></i> View
                                </a>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/company/applications.jsp?driveId=${d.id}"
                                   class="btn btn-outline btn-sm">
                                    <i class="fa-solid fa-users"></i> Applicants
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty myDrives}">
                <div class="empty-state">
                    <i class="fa-solid fa-briefcase"></i>
                    <h3>No Drives Yet</h3>
                    <p>Post a drive to see results here.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    function publishResults() {
        if (<%= selectedStudents.size() %> === 0) {
            alert('No selected candidates to publish. Go to View Applicants and approve candidates first.');
            return;
        }
        if (confirm('Publish results for <%= selectedStudents.size() %> selected student(s)? They will be notified immediately.')) {
            window.location = '${pageContext.request.contextPath}/companyAction?action=publishResults';
        }
    }
</script>

<jsp:include page="/includes/company_footer.jsp" />
