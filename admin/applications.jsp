<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.StudentDAO, com.smartplacement.model.Student, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'admin'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "applications");
    request.setAttribute("pageTitle", "Applications");
    StudentDAO sDao = new StudentDAO();
    List<Student> students = sDao.getAllStudents();
    request.setAttribute("students", students);
%>

<jsp:include page="/includes/admin_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Student Applications</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                Review and manage all <%= students.size() %> registered students and their placement status.
            </p>
        </div>
    </div>

    <!-- Mini Stats -->
    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin: 20px 0;" class="animate-in anim-d1">
        <div class="stat-card blue" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-users"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Students</div>
                <div class="stat-value" style="font-size: 22px;"><%= students.size() %></div>
            </div>
        </div>
        <div class="stat-card green" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-trophy"></i></div>
            <div class="stat-info">
                <div class="stat-label">Placed</div>
                <div class="stat-value" style="font-size: 22px;">—</div>
            </div>
        </div>
        <div class="stat-card orange" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-hourglass-half"></i></div>
            <div class="stat-info">
                <div class="stat-label">Shortlisted</div>
                <div class="stat-value" style="font-size: 22px;">—</div>
            </div>
        </div>
        <div class="stat-card purple" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-file-circle-minus"></i></div>
            <div class="stat-info">
                <div class="stat-label">Seeking</div>
                <div class="stat-value" style="font-size: 22px;">—</div>
            </div>
        </div>
    </div>

    <!-- Student Table -->
    <div class="table-wrapper animate-in anim-d2">
        <div class="table-toolbar">
            <div class="table-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="studentSearch" placeholder="Search by name, branch or email...">
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <select class="form-control" style="width: auto; font-size: 13px; padding: 7px 12px;" id="statusFilter">
                    <option value="">All Statuses</option>
                    <option value="APPLIED">Applied</option>
                    <option value="SHORTLISTED">Shortlisted</option>
                    <option value="SELECTED">Selected</option>
                    <option value="REJECTED">Rejected</option>
                </select>
            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Student</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="studentBody">
                <c:forEach var="s" items="${students}" varStatus="idx">
                    <tr class="student-row">
                        <td class="text-muted" style="font-size: 12px;">${idx.count}</td>
                        <td>
                            <div class="table-cell-with-logo">
                                <div class="table-company-logo student-name-initial">
                                    ${s.name.substring(0,1).toUpperCase()}
                                </div>
                                <div>
                                    <div class="table-name-label student-name">${s.name}</div>
                                    <div class="table-sub-label student-email">${s.email}</div>
                                </div>
                            </div>
                        </td>
                        <td><span class="student-branch">${s.branch}</span></td>
                        <td>
                            <span style="font-weight: 800; color: var(--primary);">${s.cgpa}</span>
                            <span class="text-muted" style="font-size: 11px;"> / 10</span>
                        </td>
                        <td class="text-muted student-email-col">${s.email}</td>
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
                                <button class="btn btn-success btn-sm"
                                    onclick="updateStatus(${s.id}, 'SELECTED', this)"
                                    title="Approve">
                                    <i class="fa-solid fa-check"></i> Approve
                                </button>
                                <button class="btn btn-danger-ghost btn-sm"
                                    onclick="updateStatus(${s.id}, 'REJECTED', this)"
                                    title="Reject">
                                    <i class="fa-solid fa-xmark"></i> Reject
                                </button>
                                <button class="btn btn-ghost btn-sm"
                                    onclick="window.location='mailto:${s.email}'"
                                    title="Contact">
                                    <i class="fa-solid fa-envelope"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty students}">
            <div class="empty-state">
                <i class="fa-solid fa-users"></i>
                <h3>No Students Found</h3>
                <p>Students will appear here once they register on the platform.</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    // Search
    document.getElementById('studentSearch').addEventListener('keyup', function () {
        filterTable();
    });

    // Status filter
    document.getElementById('statusFilter').addEventListener('change', function () {
        filterTable();
    });

    function filterTable() {
        const searchVal = document.getElementById('studentSearch').value.toUpperCase();
        const statusVal = document.getElementById('statusFilter').value.toUpperCase();

        document.querySelectorAll('.student-row').forEach(row => {
            const name    = row.querySelector('.student-name')?.innerText.toUpperCase() || '';
            const branch  = row.querySelector('.student-branch')?.innerText.toUpperCase() || '';
            const email   = row.querySelector('.student-email')?.innerText.toUpperCase() || '';
            const status  = row.querySelector('.student-status')?.innerText.toUpperCase() || '';

            const matchesSearch = name.includes(searchVal) || branch.includes(searchVal) || email.includes(searchVal);
            const matchesStatus = !statusVal || status.includes(statusVal);

            row.style.display = (matchesSearch && matchesStatus) ? '' : 'none';
        });
    }

    function updateStatus(studentId, status, btn) {
        const label = status === 'SELECTED' ? 'Approve' : 'Reject';
        if (!confirm(`${label} this student?`)) return;
        window.location = '${pageContext.request.contextPath}/adminAction?action=updateStudentStatus&id=' + studentId + '&status=' + status;
    }
</script>

<jsp:include page="/includes/admin_footer.jsp" />
