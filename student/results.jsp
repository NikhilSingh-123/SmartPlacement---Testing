<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.ApplicationDAO, com.smartplacement.model.Application, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<%
    ApplicationDAO dao = new ApplicationDAO();
    List<Application> results = dao.getSuccessfulPlacements();
    request.setAttribute("results", results);
%>

<div class="feed-container">
    <!-- Left: Success Metrics -->
    <aside class="left-sidebar reveal reveal-delay-1">
        <div class="card" style="padding: 24px;">
            <h3 style="font-size: 14px; font-weight: 800; text-transform: uppercase; color: var(--text-muted); margin-bottom: 24px;">Growth Metrics</h3>
            
            <div style="display: flex; flex-direction: column; gap: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 13px; font-weight: 600;">Total Placed</span>
                    <span style="font-weight: 800; color: var(--primary);"><%= results.size() %></span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 13px; font-weight: 600;">Placement %</span>
                    <span style="font-weight: 800; color: var(--success);">84%</span>
                </div>
            </div>
            
            <p style="margin-top: 24px; font-size: 11px; color: var(--text-muted); line-height: 1.6;">Based on the 2026 Academic Recruitment Phase results.</p>
        </div>
    </aside>

    <!-- Center: Success Stream -->
    <main class="main-feed reveal reveal-delay-2">
        <div class="card" style="padding: 32px; margin-bottom: 24px; background: linear-gradient(135deg, #0a66c2, #1e40af); color: white; border: none;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                   <h1 style="font-size: 24px; font-weight: 800;">Academic Hall of Fame</h1>
                   <p style="font-size: 15px; opacity: 0.9; margin-top: 8px;">Celebrating elite placement successes across all departments.</p>
                </div>
                <div class="nav-search" style="max-width: 240px;">
                    <i class="fa-solid fa-magnifying-glass" style="color: white; opacity: 0.7;"></i>
                    <input type="text" id="resultSearch" placeholder="Search alumni..." style="background: rgba(255,255,255,0.1); color: white; border: 1px solid rgba(255,255,255,0.2);">
                </div>
            </div>
        </div>

        <div id="successFeed" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <c:forEach var="r" items="${results}">
                <div class="card result-card reveal reveal-delay-3" style="margin-bottom: 0;">
                    <div style="padding: 24px; text-align: center;">
                        <div style="width: 72px; height: 72px; background: var(--primary-light); color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 28px; margin: 0 auto 16px; box-shadow: var(--shadow-md);">
                            ${r.studentName.substring(0,1).toUpperCase()}
                        </div>
                        <h3 class="student-name" style="font-size: 18px; font-weight: 800; color: var(--text-main);">${r.studentName}</h3>
                        <p class="student-branch" style="font-size: 12px; color: var(--text-muted); font-weight: 600;">${r.branch}</p>
                        
                        <div style="margin-top: 20px; padding: 16px; background: #fafafa; border-radius: 12px; border: 1px solid var(--border);">
                             <div class="company-name" style="font-size: 15px; font-weight: 800; color: var(--primary);">${r.companyName}</div>
                             <div style="font-size: 13px; font-weight: 700; color: var(--text-main); margin-top: 4px;">${r.jobRole}</div>
                        </div>

                        <div style="margin-top: 16px;">
                             <span class="badge badge-success" style="font-size: 11px;">Package: ${r.salaryPackage}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty results}">
            <div class="card" style="padding: 120px 24px; text-align: center;">
                <i class="fa-solid fa-trophy" style="font-size: 64px; color: var(--border); margin-bottom: 24px; opacity: 0.3;"></i>
                <h3 style="font-weight: 800; color: var(--text-muted);">Results Pending</h3>
                <p style="margin-top: 8px; color: var(--text-muted);">Success stories are currently being processed in the system.</p>
            </div>
        </c:if>
    </main>

    <!-- Right: Future Opportunities -->
    <aside class="right-sidebar reveal reveal-delay-3">
        <div class="card" style="padding: 20px;">
             <h3 style="font-size: 14px; font-weight: 800; text-transform: uppercase; color: var(--text-muted); margin-bottom: 20px;">On Horizon</h3>
             <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="display: flex; gap: 12px; font-size: 12px;">
                    <i class="fa-solid fa-star" style="color: #f59e0b; margin-top: 3px;"></i>
                    <div>
                        <div style="font-weight: 700;">Fortune 500 Week</div>
                        <div style="color: var(--text-muted);">Coming next month</div>
                    </div>
                </div>
             </div>
             
             <button class="btn btn-outline" style="width: 100%; margin-top: 24px; border-radius: 8px; font-size: 12px;" onclick="window.location='history.jsp'">Placement Archive</button>
        </div>
    </aside>
</div>

<script>
document.getElementById('resultSearch').addEventListener('keyup', function() {
    let filter = this.value.toUpperCase();
    let cards = document.getElementsByClassName('result-card');
    
    for (let card of cards) {
        let name = card.querySelector('.student-name').innerText.toUpperCase();
        let company = card.querySelector('.company-name').innerText.toUpperCase();
        let branch = card.querySelector('.student-branch').innerText.toUpperCase();
        if (name.includes(filter) || company.includes(filter) || branch.includes(filter)) {
            card.style.display = "";
        } else {
            card.style.display = "none";
        }
    }
});
</script>

<jsp:include page="/includes/footer.jsp" />
