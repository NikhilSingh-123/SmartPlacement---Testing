<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.*, com.smartplacement.model.*, java.util.*" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'company'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "applicants");
    request.setAttribute("pageTitle", "View Applicants");

    Company company = (Company) session.getAttribute("userObj");
    StudentDAO sDao = new StudentDAO();
    JobDriveDAO jDao = new JobDriveDAO();

    // Check if filtered by driveId
    String driveIdParam = request.getParameter("driveId");
    List<Student> students;
    String filterLabel = "All Drives";

    if (driveIdParam != null && !driveIdParam.isEmpty()) {
        try {
            int driveId = Integer.parseInt(driveIdParam);
            students = sDao.getStudentsByDrive(driveId);
            JobDrive drive = jDao.getDriveById(driveId);
            if (drive != null) filterLabel = drive.getJobRole();
        } catch (Exception e) {
            students = sDao.getAllStudents();
        }
    } else {
        students = sDao.getStudentsByCompany(company.getId());
    }

    request.setAttribute("students", students);
    request.setAttribute("filterLabel", filterLabel);
%>

<jsp:include page="/includes/company_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Applicants
                <span style="font-size: 14px; font-weight: 500; color: var(--text-muted); margin-left: 8px;">
                    — <%= filterLabel %>
                </span>
            </h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                Reviewing <%= students.size() %> candidate<%= students.size() != 1 ? "s" : "" %>. Shortlist or reject directly from this view.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/company/manage_drives.jsp" class="btn btn-ghost">
            <i class="fa-solid fa-arrow-left"></i> All Drives
        </a>
    </div>

    <!-- Mini Stats -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;" class="animate-in anim-d1">
        <div class="stat-card purple" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px;"><i class="fa-solid fa-users"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Applicants</div>
                <div class="stat-value" style="font-size: 22px;"><%= students.size() %></div>
            </div>
        </div>
        <div class="stat-card orange" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px;"><i class="fa-solid fa-user-check"></i></div>
            <div class="stat-info">
                <div class="stat-label">Shortlisted</div>
                <div class="stat-value" style="font-size: 22px;" id="shortlistCount">—</div>
            </div>
        </div>
        <div class="stat-card green" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px;"><i class="fa-solid fa-trophy"></i></div>
            <div class="stat-info">
                <div class="stat-label">Selected</div>
                <div class="stat-value" style="font-size: 22px;" id="selectedCount">—</div>
            </div>
        </div>
    </div>

    <!-- Applicants Table -->
    <div class="table-wrapper animate-in anim-d2">
        <div class="table-toolbar">
            <div class="table-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="studentSearch" placeholder="Search by name or branch...">
            </div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <select class="form-control" id="statusFilter" style="font-size: 13px; padding: 7px 12px; width: auto;">
                    <option value="">All Statuses</option>
                    <option value="APPLIED">Applied</option>
                    <option value="SHORTLISTED">Shortlisted</option>
                    <option value="SELECTED">Selected</option>
                    <option value="REJECTED">Rejected</option>
                </select>
                <select class="form-control" id="cgpaFilter" style="font-size: 13px; padding: 7px 12px; width: auto;">
                    <option value="">Any CGPA</option>
                    <option value="9">9.0+</option>
                    <option value="8">8.0+</option>
                    <option value="7">7.0+</option>
                </select>
            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Candidate</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="studentBody">
                <c:forEach var="s" items="${students}" varStatus="idx">
                    <tr class="student-row" data-cgpa="${s.cgpa}" data-status="${s.status}">
                        <td class="text-muted" style="font-size: 12px;">${idx.count}</td>
                        <td>
                            <div class="table-cell-with-logo">
                                <div class="table-company-logo">
                                    ${s.name.substring(0,1).toUpperCase()}
                                </div>
                                <div>
                                    <div class="table-name-label student-name">${s.name}</div>
                                    <div class="table-sub-label">${s.email}</div>
                                </div>
                            </div>
                        </td>
                        <td class="student-branch">${s.branch}</td>
                        <td>
                            <span style="font-weight: 800; color: var(--primary);">${s.cgpa}</span>
                            <span class="text-muted" style="font-size: 11px;">/10</span>
                        </td>
                        <td>
                            <a href="mailto:${s.email}" style="color: var(--primary); font-size: 13px; font-weight: 600;">
                                <i class="fa-solid fa-envelope"></i> Send Mail
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${s.status == 'SELECTED'}">
                                    <span class="badge badge-success student-status">Selected</span>
                                </c:when>
                                <c:when test="${s.status == 'SHORTLISTED'}">
                                    <span class="badge badge-warning student-status">Shortlisted</span>
                                </c:when>
                                <c:when test="${s.status == 'REJECTED'}">
                                    <span class="badge badge-danger student-status">Rejected</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-gray student-status">Applied</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div style="display: flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/companyAction?action=shortlist&studentId=${s.id}&driveId=${param.driveId}"
                                   class="btn btn-success btn-sm"
                                   title="Shortlist this candidate">
                                    <i class="fa-solid fa-user-check"></i> Shortlist
                                </a>
                                <a href="${pageContext.request.contextPath}/companyAction?action=reject&studentId=${s.id}&driveId=${param.driveId}"
                                   class="btn btn-danger-ghost btn-sm"
                                   title="Reject this candidate"
                                   onclick="return confirm('Reject this candidate?')">
                                    <i class="fa-solid fa-xmark"></i> Reject
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty students}">
            <div class="empty-state">
                <i class="fa-solid fa-users"></i>
                <h3>No Applicants Yet</h3>
                <p>Once students apply to your drives, their profiles will appear here for review.</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    // Update mini-stat counts from table
    function updateCounts() {
        let shortlisted = 0, selected = 0;
        document.querySelectorAll('.student-row').forEach(r => {
            const status = r.getAttribute('data-status');
            if (status === 'SHORTLISTED') shortlisted++;
            if (status === 'SELECTED') selected++;
        });
        document.getElementById('shortlistCount').textContent = shortlisted;
        document.getElementById('selectedCount').textContent = selected;
    }
    updateCounts();

    function filterTable() {
        const search     = document.getElementById('studentSearch').value.toUpperCase();
        const statusVal  = document.getElementById('statusFilter').value.toUpperCase();
        const cgpaMinVal = parseFloat(document.getElementById('cgpaFilter').value) || 0;

        document.querySelectorAll('.student-row').forEach(row => {
            const name   = row.querySelector('.student-name')?.innerText.toUpperCase() || '';
            const branch = row.querySelector('.student-branch')?.innerText.toUpperCase() || '';
            const status = row.querySelector('.student-status')?.innerText.toUpperCase() || '';
            const cgpa   = parseFloat(row.getAttribute('data-cgpa')) || 0;

            const ok = name.includes(search) || branch.includes(search);
            const okStatus = !statusVal || status.includes(statusVal);
            const okCgpa   = cgpa >= cgpaMinVal;
            row.style.display = (ok && okStatus && okCgpa) ? '' : 'none';
        });
    }

    document.getElementById('studentSearch').addEventListener('keyup', filterTable);
    document.getElementById('statusFilter').addEventListener('change', filterTable);
    document.getElementById('cgpaFilter').addEventListener('change', filterTable);
</script>

<jsp:include page="/includes/company_footer.jsp" />
