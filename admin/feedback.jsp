<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.FeedbackDAO, com.smartplacement.model.Feedback, java.util.List" %>
<c:if test="${empty sessionScope.userObj || sessionScope.role != 'admin'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<div class="main-content slide-up" style="margin-top: 90px; max-width: 1200px; margin-left: auto; margin-right: auto; padding: 0 24px;">
    
    <div style="margin-bottom: 32px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div>
            <h2 style="font-size: 28px; font-weight: 800; color: var(--text-primary);">
                <i class="fa-solid fa-comments-alt" style="color: var(--primary);"></i> Student Feedback
            </h2>
            <p style="color: var(--text-secondary);">Monitor internal suggestions and portal experience reports.</p>
        </div>
        <div class="glass-card" style="padding: 8px 16px; display: flex; align-items: center; gap: 12px; min-width: 300px; border-radius: 12px;">
            <i class="fa-solid fa-magnifying-glass" style="color: var(--text-secondary);"></i>
            <input type="text" id="feedbackSearch" placeholder="Filter by student or subject..." style="background: transparent; border: none; outline: none; color: var(--text-primary); width: 100%; font-size: 14px;">
        </div>
    </div>

    <%
        FeedbackDAO fDao = new FeedbackDAO();
        List<Feedback> feedbacks = fDao.getAllFeedback();
        request.setAttribute("feedbacks", feedbacks);
    %>

    <div class="card glass-card hover-fx">
        <div class="table-responsive" style="padding: 12px;">
            <table style="width: 100%; border-collapse: separate; border-spacing: 0 8px;">
                <thead>
                    <tr style="background: rgba(0,0,0,0.02); color: var(--text-secondary); text-transform: uppercase; font-size: 12px; letter-spacing: 1px;">
                        <th style="padding: 16px;">Student</th>
                        <th style="padding: 16px;">Subject</th>
                        <th style="padding: 16px;">Message</th>
                        <th style="padding: 16px; text-align: right;">Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="f" items="${feedbacks}">
                        <tr class="feedback-row" style="background: rgba(255,255,255,0.02); border-radius: 12px; transition: background 0.2s;">
                            <td style="padding: 16px; border-radius: 12px 0 0 12px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 36px; height: 36px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700;">
                                        ${f.studentName.substring(0,1).toUpperCase()}
                                    </div>
                                    <div class="student-name" style="font-weight: 700; color: var(--text-primary);">${f.studentName}</div>
                                </div>
                            </td>
                            <td class="feedback-subject" style="padding: 16px; color: var(--text-primary); font-weight: 600;">${f.subject}</td>
                            <td style="padding: 16px;">
                                <div style="max-width: 400px; font-size: 14px; color: var(--text-secondary); line-height: 1.5; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${f.message}">
                                    ${f.message}
                                </div>
                            </td>
                            <td style="padding: 16px; text-align: right; border-radius: 0 12px 12px 0; font-size: 13px; color: var(--text-secondary);">
                                ${f.submitDate}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty feedbacks}">
                <div style="text-align: center; padding: 80px 24px;">
                    <i class="fa-solid fa-comment-slash" style="font-size: 48px; color: var(--border); margin-bottom: 16px; display: block; opacity: 0.3;"></i>
                    <p style="color: var(--text-secondary);">No feedback submissions received yet.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
document.getElementById('feedbackSearch').addEventListener('keyup', function() {
    let filter = this.value.toUpperCase();
    let rows = document.getElementsByClassName('feedback-row');
    
    for (let row of rows) {
        let name = row.querySelector('.student-name').innerText.toUpperCase();
        let subject = row.querySelector('.feedback-subject').innerText.toUpperCase();
        if (name.includes(filter) || subject.includes(filter)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    }
});
</script>

<jsp:include page="/includes/footer.jsp" />
