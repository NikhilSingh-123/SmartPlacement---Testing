<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.JobDriveDAO, com.smartplacement.model.JobDrive, com.smartplacement.model.Student, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/login.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<%
    Student s = (Student) session.getAttribute("userObj");
    JobDriveDAO dao = new JobDriveDAO();
    // If coming from search, use the 'drives' attribute from SearchServlet
    List<JobDrive> drives = (List<JobDrive>) request.getAttribute("drives");
    if (drives == null) {
        drives = dao.getDrivesForStudent(s.getId());
    }
    request.setAttribute("drives", drives);
%>

<div class="feed-container" style="max-width: 1128px; grid-template-columns: 350px 1fr; height: calc(100vh - 80px); overflow: hidden; margin-top: 16px;">
    
    <!-- Left: Job List -->
    <aside style="background: white; border: 1px solid var(--border); border-radius: 8px; overflow-y: auto; height: 100%;">
        <div style="padding: 16px; border-bottom: 1px solid var(--border);">
            <h2 style="font-size: 18px; font-weight: 700;">Jobs for you</h2>
            <c:if test="${not empty searchQuery}">
                <p style="font-size: 12px; color: var(--text-secondary);">Showing results for "${searchQuery}"</p>
            </c:if>
        </div>

        <c:forEach var="d" items="${drives}" varStatus="status">
            <div class="job-item ${status.first ? 'active-job' : ''}" 
                 onclick="showDetail('${d.id}', '${d.jobRole}', '${d.companyName}', '${d.location}', '${d.salaryPackage}', '${d.eligibilityCgpa}', '${d.description}', '${d.applied}', '${d.eligibleBranches}')"
                 style="padding: 16px; border-bottom: 1px solid var(--border); cursor: pointer; transition: background 0.2s;">
                <div style="display: flex; gap: 12px;">
                    <div style="width: 48px; height: 48px; background: #f3f2ef; border-radius: 4px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <i class="fa-solid fa-briefcase" style="font-size: 24px; color: var(--primary);"></i>
                    </div>
                    <div style="flex: 1;">
                        <div style="font-size: 14px; font-weight: 700; color: var(--primary);">${d.jobRole}</div>
                        <div style="font-size: 13px; font-weight: 400; color: var(--text-primary);">${d.companyName}</div>
                        <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px;">${d.location}</div>
                        <div style="font-size: 11px; color: var(--success); font-weight: 700; margin-top: 4px;">
                             <i class="fa-solid fa-clock"></i> Applied ${d.applied ? 'Recently' : 'Now'}
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty drives}">
            <div style="padding: 40px 16px; text-align: center;">
                 <i class="fa-solid fa-ban" style="font-size: 32px; color: var(--text-secondary); margin-bottom: 12px;"></i>
                 <div style="font-size: 14px; font-weight: 700;">No jobs found</div>
                 <a href="jobs.jsp" style="font-size: 12px; color: var(--primary);">Clear filters</a>
            </div>
        </c:if>
    </aside>

    <!-- Right: Job Detail Preview -->
    <main class="card" id="jobDetailArea" style="height: 100%; overflow-y: auto; padding: 0;">
        <c:choose>
            <c:when test="${not empty drives}">
                <c:set var="first" value="${drives[0]}" />
                <div id="detailContent">
                    <div style="padding: 24px; border-bottom: 1px solid var(--border);">
                        <h1 id="detRole" style="font-size: 24px; font-weight: 700;">${first.jobRole}</h1>
                        <div style="display: flex; gap: 8px; align-items: center; margin-top: 8px;">
                            <span id="detCompany" style="font-size: 16px; color: var(--text-primary); font-weight: 600;">${first.companyName}</span>
                            <span style="color: var(--text-secondary);">&bull;</span>
                            <span id="detLoc" style="font-size: 16px; color: var(--text-secondary);">${first.location}</span>
                        </div>
                        <div id="detMeta" style="margin-top: 16px; display: flex; gap: 12px;">
                             <span class="badge badge-primary" style="padding: 6px 12px;">Package: ${first.salaryPackage}</span>
                             <span class="badge badge-warning" style="padding: 6px 12px;">Min CGPA: ${first.eligibilityCgpa}</span>
                        </div>

                        <div style="margin-top: 24px; display: flex; gap: 12px;">
                            <c:choose>
                                <c:when test="${first.applied}">
                                    <button class="btn btn-primary" disabled style="padding: 10px 32px; opacity: 0.7;">Applied</button>
                                </c:when>
                                <c:otherwise>
                                    <a id="detApplyBtn" href="${pageContext.request.contextPath}/studentAction?action=applyJob&driveId=${first.id}" class="btn btn-primary" style="padding: 10px 32px;">Apply Now</a>
                                </c:otherwise>
                            </c:choose>
                            <button class="btn btn-outline" style="padding: 10px 32px;">Save</button>
                        </div>
                    </div>

                    <div style="padding: 24px;">
                        <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 16px;">Job Description</h3>
                        <div id="detDesc" style="font-size: 15px; color: var(--text-primary); line-height: 1.6; white-space: pre-line;">
                            ${first.description}
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div style="height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: var(--text-secondary);">
                    <i class="fa-solid fa-magnifying-glass" style="font-size: 48px; margin-bottom: 16px;"></i>
                    <p>Select a job to view details</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<script>
    function showDetail(id, role, company, loc, salary, cgpa, desc, applied, branches) {
        // Update UI
        document.getElementById('detRole').innerText = role;
        document.getElementById('detCompany').innerText = company;
        document.getElementById('detLoc').innerText = loc;
        document.getElementById('detDesc').innerText = desc;
        document.getElementById('detMeta').innerHTML = `
            <span class="badge badge-primary" style="padding: 6px 12px;">Package: ${salary}</span>
            <span class="badge badge-warning" style="padding: 6px 12px;">Min CGPA: ${cgpa}</span>
        `;

        const applyBtn = document.getElementById('detApplyBtn');
        if (applyBtn) {
            if (applied === "true") {
                applyBtn.innerText = "Applied";
                applyBtn.classList.add("disabled");
                applyBtn.removeAttribute("href");
            } else {
                applyBtn.innerText = "Apply Now";
                applyBtn.classList.remove("disabled");
                applyBtn.href = `${pageContext.request.contextPath}/studentAction?action=applyJob&driveId=` + id;
            }
        }

        // Highlight active item
        document.querySelectorAll('.job-item').forEach(item => {
            item.classList.remove('active-job');
        });
        event.currentTarget.classList.add('active-job');
    }
</script>

<style>
    .job-item:hover { background: #f3f2ef; }
    .active-job { background: #e8f3ff !important; border-left: 4px solid var(--primary); }
    .disabled { background: #cbd5e1 !important; cursor: not-allowed; border: none; }
</style>

<jsp:include page="/includes/footer.jsp" />
