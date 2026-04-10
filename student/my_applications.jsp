<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.ApplicationDAO, com.smartplacement.model.Application, com.smartplacement.model.Student, java.util.List" %>
<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<div class="main-content slide-up" style="margin-top: 90px; max-width: 1000px; margin-left: auto; margin-right: auto; padding: 0 24px;">
    
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 28px; font-weight: 800; color: var(--text-primary);">
            <i class="fa-solid fa-clock-rotate-left" style="color: var(--primary);"></i> Application Roadmap
        </h2>
        <p style="color: var(--text-secondary);">Track your recruitment progress across all applied companies.</p>
    </div>

    <%
        Student student = (Student) session.getAttribute("userObj");
        ApplicationDAO aDao = new ApplicationDAO();
        List<Application> list = aDao.getApplicationsByStudent(student.getId());
        request.setAttribute("apps", list);
    %>

    <div style="display: flex; flex-direction: column; gap: 24px;">
        <c:forEach var="a" items="${apps}">
            <div class="card glass-card hover-fx" style="padding: 24px; border-radius: 16px;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px;">
                    <div style="display: flex; gap: 16px; align-items: center;">
                        <div style="width: 50px; height: 50px; background: rgba(10,102,194,0.05); color: var(--primary); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                            <i class="fa-solid fa-building"></i>
                        </div>
                        <div>
                            <h3 style="font-size: 18px; font-weight: 800; color: var(--text-primary); margin-bottom: 2px;">${a.companyName}</h3>
                            <p style="font-size: 14px; color: var(--primary); font-weight: 600;">${a.jobRole}</p>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge" style="
                            <c:if test="${a.status == 'APPLIED'}">background: rgba(10,102,194,0.1); color: var(--primary);</c:if>
                            <c:if test="${a.status == 'SHORTLISTED'}">background: rgba(245,158,11,0.1); color: #f59e0b;</c:if>
                            <c:if test="${a.status == 'SELECTED'}">background: rgba(16,185,129,0.1); color: #10b981;</c:if>
                            <c:if test="${a.status == 'REJECTED'}">background: rgba(239,68,68,0.1); color: #ef4444;</c:if>
                        ">${a.status}</span>
                        <p style="font-size: 11px; color: var(--text-secondary); margin-top: 8px;">Applied on: ${a.applyDate}</p>
                    </div>
                </div>

                <!-- Status Progress Bar -->
                <div style="padding: 12px 0;">
                    <div style="position: relative; height: 6px; background: var(--border); border-radius: 3px; margin-bottom: 30px;">
                        <c:set var="prog" value="25" />
                        <c:if test="${a.status == 'SHORTLISTED'}"><c:set var="prog" value="65" /></c:if>
                        <c:if test="${a.status == 'SELECTED' || a.status == 'REJECTED'}"><c:set var="prog" value="100" /></c:if>
                        
                        <div style="position: absolute; left: 0; top: 0; height: 100%; border-radius: 3px; 
                             width: ${prog}%; 
                             background: #0a66c2;">
                        </div>

                        <!-- Dots -->
                        <div style="display: flex; justify-content: space-between; transform: translateY(-7px); width: 100%;">
                            <div style="width: 20px; height: 20px; background: var(--primary); border: 4px solid var(--surface); border-radius: 50%;" title="Applied"></div>
                            <div style="width: 20px; height: 20px; background: ${prog >= 65 ? 'var(--primary)' : 'var(--border)'}; border: 4px solid var(--surface); border-radius: 50%;" title="Shortlisted"></div>
                            <div style="width: 20px; height: 20px; background: ${prog == 100 ? (a.status == 'REJECTED' ? '#ef4444' : '#10b981') : 'var(--border)'}; border: 4px solid var(--surface); border-radius: 50%;" title="Final Result"></div>
                        </div>
                        
                        <div style="display: flex; justify-content: space-between; font-size: 11px; font-weight: 700; color: var(--text-secondary); margin-top: 10px;">
                            <span>APPLIED</span>
                            <span>SHORTLISTED</span>
                            <span>DECISION</span>
                        </div>
                    </div>
                </div>

                <c:if test="${a.status == 'SELECTED'}">
                    <div class="alert alert-success" style="margin-top: 12px; margin-bottom: 0; padding: 12px; border-radius: 10px; font-size: 13px;">
                        <i class="fa-solid fa-trophy"></i> <strong>Congratulations!</strong> You have been selected for the <b>${a.jobRole}</b> position at <b>${a.companyName}</b>.
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty apps}">
        <div class="card glass-card" style="text-align: center; padding: 100px 24px;">
            <i class="fa-solid fa-paper-plane" style="font-size: 64px; color: var(--border); margin-bottom: 24px; opacity: 0.5;"></i>
            <h3 style="font-size: 22px; font-weight: 800; color: var(--text-primary);">No Applications Yet</h3>
            <p style="color: var(--text-secondary); max-width: 420px; margin: 8px auto 24px;">Your journey starts with the first application. Head over to the Explore page for the newest job drives.</p>
            <a href="jobs.jsp" class="btn btn-primary" style="padding: 12px 32px; border-radius: 12px;">Discover Opportunities</a>
        </div>
    </c:if>
</div>

<jsp:include page="/includes/footer.jsp" />
