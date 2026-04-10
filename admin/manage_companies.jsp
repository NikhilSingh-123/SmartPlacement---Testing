<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.CompanyDAO, com.smartplacement.model.Company, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'admin'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "companies");
    request.setAttribute("pageTitle", "Manage Companies");
    CompanyDAO cDao = new CompanyDAO();
    List<Company> companies = cDao.getAllCompanies();
    request.setAttribute("companies", companies);
%>

<jsp:include page="/includes/admin_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Partner Companies</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                Manage the <%= companies.size() %> corporate partners in the SmartPlacement network.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/addCompany.jsp" class="btn btn-primary">
            <i class="fa-solid fa-plus"></i> Add New Company
        </a>
    </div>

    <!-- Stats Row -->
    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin: 20px 0;" class="animate-in anim-d1">
        <div class="stat-card blue" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-building"></i></div>
            <div class="stat-info">
                <div class="stat-label">Total Partners</div>
                <div class="stat-value" style="font-size: 22px;"><%= companies.size() %></div>
            </div>
        </div>
        <div class="stat-card green" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-circle-check"></i></div>
            <div class="stat-info">
                <div class="stat-label">Verified</div>
                <div class="stat-value" style="font-size: 22px;"><%= companies.size() %></div>
            </div>
        </div>
        <div class="stat-card orange" style="padding: 16px 20px;">
            <div class="stat-icon" style="width: 40px; height: 40px; font-size: 18px;"><i class="fa-solid fa-clock"></i></div>
            <div class="stat-info">
                <div class="stat-label">Pending Review</div>
                <div class="stat-value" style="font-size: 22px;">0</div>
            </div>
        </div>
    </div>

    <!-- Company Table -->
    <div class="table-wrapper animate-in anim-d2">
        <div class="table-toolbar">
            <div class="table-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="companySearch" placeholder="Search by name or email...">
            </div>
            <div style="display: flex; align-items: center; gap: 10px; font-size: 13px; color: var(--text-muted);">
                Showing <%= companies.size() %> companies
            </div>
        </div>

        <table class="admin-table" id="companyTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Company</th>
                    <th>Email</th>
                    <th>Website</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="companyBody">
                <c:forEach var="c" items="${companies}" varStatus="s">
                    <tr class="company-row">
                        <td class="text-muted" style="font-size: 12px;">${s.count}</td>
                        <td>
                            <div class="table-cell-with-logo">
                                <div class="table-company-logo">
                                    ${c.companyName.substring(0,1).toUpperCase()}
                                </div>
                                <div>
                                    <div class="table-name-label company-name">${c.companyName}</div>
                                    <div class="table-sub-label company-email">${c.email}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="text-muted">${c.email}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty c.website}">
                                    <a href="${c.website}" target="_blank" style="color: var(--primary); font-weight: 600; font-size: 13px;">
                                        <i class="fa-solid fa-link"></i> Visit
                                    </a>
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="badge badge-success">Verified</span></td>
                        <td>
                            <div style="display: flex; gap: 6px;">
                                <button class="btn btn-ghost btn-sm" title="Edit">
                                    <i class="fa-solid fa-pen-to-square"></i> Edit
                                </button>
                                <a href="${pageContext.request.contextPath}/adminAction?action=deleteCompany&id=${c.id}"
                                   class="btn btn-danger-ghost btn-sm"
                                   onclick="return confirm('Delete ${c.companyName}? This cannot be undone.')">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty companies}">
            <div class="empty-state">
                <i class="fa-solid fa-building-circle-exclamation"></i>
                <h3>No Companies Yet</h3>
                <p>Add your first corporate partner to start building the placement network.</p>
                <a href="${pageContext.request.contextPath}/admin/addCompany.jsp" class="btn btn-primary" style="margin-top: 16px;">
                    <i class="fa-solid fa-plus"></i> Add Company
                </a>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.getElementById('companySearch').addEventListener('keyup', function () {
        const filter = this.value.toUpperCase();
        document.querySelectorAll('.company-row').forEach(row => {
            const name  = row.querySelector('.company-name')?.innerText.toUpperCase() || '';
            const email = row.querySelector('.company-email')?.innerText.toUpperCase() || '';
            row.style.display = (name.includes(filter) || email.includes(filter)) ? '' : 'none';
        });
    });
</script>

<jsp:include page="/includes/admin_footer.jsp" />
