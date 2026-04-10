<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'company'}">
    <c:redirect url="/login.jsp" />
</c:if>

<%
    request.setAttribute("currentPage", "postjob");
    request.setAttribute("pageTitle", "Post Job Drive");
%>

<jsp:include page="/includes/company_header.jsp" />

<div class="admin-content">
    <div class="page-header-actions animate-in">
        <div>
            <h1 style="font-size: 22px; font-weight: 800;">Post a New Job Drive</h1>
            <p class="text-muted" style="font-size: 14px; margin-top: 4px;">Fill in the details below to launch a new recruitment drive for engineering talent.</p>
        </div>
        <a href="${pageContext.request.contextPath}/company/manage_drives.jsp" class="btn btn-ghost">
            <i class="fa-solid fa-arrow-left"></i> Back to Drives
        </a>
    </div>

    <div style="max-width: 820px; margin-top: 8px;" class="animate-in anim-d1">
        <div class="card">
            <div class="card-header">
                <span class="card-title"><i class="fa-solid fa-briefcase" style="color: var(--primary); margin-right: 8px;"></i>Drive Details</span>
                <span class="badge badge-primary">New Drive</span>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/companyAction" method="post" id="postJobForm" novalidate>
                    <input type="hidden" name="action" value="addDrive">

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="jobRole">Job Role / Title <span class="form-required">*</span></label>
                            <input type="text" id="jobRole" name="jobRole" class="form-control"
                                   placeholder="e.g. Software Engineer, Data Analyst" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="salary">Salary Package (LPA) <span class="form-required">*</span></label>
                            <input type="text" id="salary" name="salary" class="form-control"
                                   placeholder="e.g. 12.5 LPA or 10-15 LPA" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="cgpa">Minimum CGPA Required <span class="form-required">*</span></label>
                            <input type="number" id="cgpa" name="cgpa" class="form-control"
                                   placeholder="e.g. 7.5" step="0.01" min="0" max="10" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="branches">Eligible Branches <span class="form-required">*</span></label>
                            <input type="text" id="branches" name="branches" class="form-control"
                                   placeholder="e.g. CSE, IT, ECE (comma-separated)" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="lastDate">Application Deadline <span class="form-required">*</span></label>
                            <input type="date" id="lastDate" name="lastDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="driveDate">Drive / Interview Date <span class="form-required">*</span></label>
                            <input type="date" id="driveDate" name="driveDate" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="location">Job Location <span class="form-required">*</span></label>
                        <input type="text" id="location" name="location" class="form-control"
                               placeholder="e.g. Bangalore / Remote / Hybrid" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="jobType">Employment Type</label>
                        <select id="jobType" name="jobType" class="form-control">
                            <option value="Full-Time">Full-Time</option>
                            <option value="Internship">Internship</option>
                            <option value="Contract">Contract</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="description">Job Description <span class="form-required">*</span></label>
                        <textarea id="description" name="description" class="form-control" rows="5"
                                  placeholder="Outline the responsibilities, required skills, tech stack, and perks..." required></textarea>
                        <p class="form-hint">This description will be visible to all eligible students on their job feed.</p>
                    </div>

                    <div style="padding-top: 20px; border-top: 1px solid var(--border); display: flex; gap: 12px;">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fa-solid fa-paper-plane"></i> Launch Drive
                        </button>
                        <button type="reset" class="btn btn-ghost btn-lg">
                            <i class="fa-solid fa-rotate-left"></i> Reset Form
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card" style="margin-top: 20px;">
            <div class="card-body">
                <div style="display: flex; gap: 14px; align-items: flex-start;">
                    <i class="fa-solid fa-circle-info" style="color: var(--primary); font-size: 20px; margin-top: 2px;"></i>
                    <div>
                        <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">How Drive Matching Works</div>
                        <p class="text-muted" style="font-size: 13px; line-height: 1.6;">
                            Once you post a drive, the system automatically notifies all eligible students based on their branch and CGPA.
                            Students can then apply directly from their dashboard. You can review all applicants from the "View Applicants" section.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('postJobForm').addEventListener('submit', function(e) {
        const cgpa = parseFloat(document.getElementById('cgpa').value);
        if (isNaN(cgpa) || cgpa < 0 || cgpa > 10) {
            e.preventDefault();
            alert('Please enter a valid CGPA between 0 and 10.');
            return;
        }
        const lastDate = new Date(document.getElementById('lastDate').value);
        const driveDate = new Date(document.getElementById('driveDate').value);
        if (driveDate < lastDate) {
            e.preventDefault();
            alert('Drive date cannot be before the application deadline.');
        }
    });
</script>

<jsp:include page="/includes/company_footer.jsp" />
