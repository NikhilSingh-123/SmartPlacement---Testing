<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'admin'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "companies");
    request.setAttribute("pageTitle", "Add Company");
%>

<jsp:include page="/includes/admin_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Add New Company</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">Register a new corporate partner to the SmartPlacement network.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/manage_companies.jsp" class="btn btn-ghost">
            <i class="fa-solid fa-arrow-left"></i> Back to Companies
        </a>
    </div>

    <div style="max-width: 720px; margin-top: 8px;" class="animate-in anim-d1">
        <div class="card">
            <div class="card-header">
                <span class="card-title"><i class="fa-solid fa-building" style="color: var(--primary); margin-right: 8px;"></i>Company Information</span>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/adminAction" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="addCompany">

                    <div class="form-group">
                        <label class="form-label" for="companyName">Company Name <span class="form-required">*</span></label>
                        <input type="text" id="companyName" name="companyName" class="form-control"
                               placeholder="e.g., Infosys Technologies" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="email">Official Email <span class="form-required">*</span></label>
                            <input type="email" id="email" name="email" class="form-control"
                                   placeholder="hr@company.com" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="website">Company Website</label>
                            <input type="url" id="website" name="website" class="form-control"
                                   placeholder="https://www.company.com">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="industry">Industry Sector <span class="form-required">*</span></label>
                            <select id="industry" name="industry" class="form-control" required>
                                <option value="" disabled selected>Select industry...</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Software & Technology">Software & Technology</option>
                                <option value="Banking & Finance">Banking & Finance</option>
                                <option value="Manufacturing">Manufacturing</option>
                                <option value="Healthcare & Pharma">Healthcare & Pharma</option>
                                <option value="Consulting">Consulting</option>
                                <option value="E-Commerce">E-Commerce</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="contactPerson">Contact Person</label>
                            <input type="text" id="contactPerson" name="contactPerson" class="form-control"
                                   placeholder="HR Manager name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="description">Company Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4"
                                  placeholder="Brief description of the company and its focus areas..."></textarea>
                        <p class="form-hint">This will be displayed to students on the job feed.</p>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="logo">Company Logo</label>
                        <input type="file" id="logo" name="logo" class="form-control" accept="image/*">
                        <p class="form-hint">Upload a high-quality logo (Square 1:1 recommended).</p>
                    </div>

                    <div style="display: flex; gap: 12px; margin-top: 8px; padding-top: 20px; border-top: 1px solid var(--border);">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fa-solid fa-plus"></i> Register Company
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/manage_companies.jsp" class="btn btn-ghost btn-lg">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Info Card -->
        <div class="card" style="margin-top: 20px;">
            <div class="card-body">
                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <i class="fa-solid fa-circle-info" style="color: var(--primary); font-size: 20px; margin-top: 2px;"></i>
                    <div>
                        <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">What happens after registration?</div>
                        <p class="text-muted" style="font-size: 13px; line-height: 1.6;">
                            Once added, the company can log in with their registered email to post job drives and review applications.
                            Students eligible for the company's drives will be automatically notified.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/admin_footer.jsp" />
