<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.SavedJobDAO, com.smartplacement.model.JobDrive, com.smartplacement.model.Student, java.util.List" %>
<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<div class="main-content slide-up" style="margin-top: 90px; max-width: 1200px; margin-left: auto; margin-right: auto; padding: 0 24px;">
    
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 28px; font-weight: 800; color: var(--text-primary);">
            <i class="fa-solid fa-bookmark" style="color: var(--primary);"></i> Bookmarked Jobs
        </h2>
        <p style="color: var(--text-secondary);">Roles you have saved for later consideration.</p>
    </div>

    <%
        Student s = (Student) session.getAttribute("userObj");
        SavedJobDAO dao = new SavedJobDAO();
        List<JobDrive> drives = dao.getSavedJobsByStudent(s.getId());
        request.setAttribute("drives", drives);
    %>

    <div class="job-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 24px;">
        <c:forEach var="d" items="${drives}">
            <div class="card glass-card hover-fx" style="display:flex; flex-direction:column; justify-content:space-between; border-radius: 16px; padding: 24px;">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                        <span class="badge" style="background: rgba(10,102,194,0.1); color: var(--primary); font-weight: 700;">${d.location}</span>
                        <a href="${pageContext.request.contextPath}/studentAction?action=removeSavedJob&driveId=${d.id}" style="color: #ef4444;" title="Remove Bookmark">
                            <i class="fa-solid fa-trash-can"></i>
                        </a>
                    </div>

                    <h3 style="color:var(--text-primary); font-size: 20px; font-weight: 700; margin-bottom:4px;">${d.jobRole}</h3>
                    <h4 style="color:var(--primary); font-weight:600; margin-bottom: 16px; font-size: 16px;">${d.companyName}</h4>
                    
                    <p style="font-size: 14px; color:var(--text-secondary); margin-bottom: 20px; line-height: 1.6;">
                        ${d.description}
                    </p>

                    <div style="display:flex; flex-wrap:wrap; gap:12px; margin-bottom: 24px;">
                        <div style="display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--text-secondary);">
                            <i class="fa-solid fa-sack-dollar" style="color: #10b981;"></i> <b>${d.salaryPackage}</b>
                        </div>
                    </div>
                </div>
                
                <div style="border-top: 1px solid var(--border); padding-top: 20px; display:flex; justify-content:space-between; align-items:center;">
                    <div style="font-size: 12px; color: var(--text-secondary);">
                        Drive: <b>${d.driveDate}</b>
                    </div>
                    <a href="${pageContext.request.contextPath}/studentAction?action=applyJob&driveId=${d.id}" class="btn btn-primary" style="padding: 8px 20px; border-radius: 10px; font-weight: 600;">Apply Now</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty drives}">
        <div class="card glass-card" style="text-align: center; padding: 80px 24px;">
            <i class="fa-solid fa-bookmark" style="font-size: 64px; margin-bottom: 24px; color: var(--border); opacity: 0.3;"></i>
            <h3 style="font-size: 22px; font-weight: 700; color: var(--text-primary);">No Bookmarks Yet</h3>
            <p style="color: var(--text-secondary); max-width: 400px; margin: 8px auto 0;">Save jobs from the Opportunity Portal to view them here later.</p>
            <a href="jobs.jsp" class="btn btn-primary" style="margin-top: 24px;">Explore Jobs</a>
        </div>
    </c:if>
</div>

<jsp:include page="/includes/footer.jsp" />
