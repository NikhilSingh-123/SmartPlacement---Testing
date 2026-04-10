<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<div class="main-content slide-up" style="margin-top: 100px; max-width: 700px; margin-left: auto; margin-right: auto; padding: 0 24px;">
    
    <div style="text-align: center; margin-bottom: 40px;">
        <h2 style="font-size: 32px; font-weight: 800; color: var(--text-primary); margin-bottom: 12px;">Share Your Voice</h2>
        <p style="color: var(--text-secondary); font-size: 16px;">Your insights help us build a better recruitment ecosystem for everyone.</p>
    </div>

    <c:if test="${not empty sessionScope.succMsg}">
        <div class="alert alert-success" style="margin-bottom: 24px;">${sessionScope.succMsg}</div>
        <c:remove var="succMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger" style="margin-bottom: 24px;">${sessionScope.errorMsg}</div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>

    <div class="card glass-card hover-fx" style="padding: 40px; border-radius: 20px;">
        <form action="${pageContext.request.contextPath}/studentAction" method="post">
            <input type="hidden" name="action" value="submitFeedback">
            
            <div class="form-group" style="margin-bottom: 24px;">
                <label style="font-weight: 700; color: var(--text-primary); display: block; margin-bottom: 10px;">Enquiry Subject</label>
                <input type="text" name="subject" class="form-control" 
                       style="padding: 14px; border-radius: 12px; border: 1px solid var(--border); transition: border-color 0.3s;" 
                       required placeholder="e.g. Technical issue, Feature request, Experience feedback">
            </div>

            <div class="form-group" style="margin-bottom: 32px;">
                <label style="font-weight: 700; color: var(--text-primary); display: block; margin-bottom: 10px;">Detailed Message</label>
                <textarea name="message" class="form-control" 
                          style="padding: 14px; border-radius: 12px; border: 1px solid var(--border); transition: border-color 0.3s;" 
                          required rows="6" placeholder="Tell us more about your experience or concerns..."></textarea>
            </div>

            <button type="submit" class="btn btn-primary" 
                    style="width: 100%; padding: 16px; border-radius: 12px; font-weight: 700; font-size: 16px; box-shadow: 0 4px 15px rgba(10,102,194,0.3);">
                Transmitting Feedback <i class="fa-solid fa-paper-plane" style="margin-left: 8px;"></i>
            </button>
        </form>
        
        <div style="margin-top: 32px; padding-top: 24px; border-top: 1px solid var(--border); text-align: center;">
            <p style="font-size: 13px; color: var(--text-secondary); line-height: 1.6;">
                <i class="fa-solid fa-shield-halved" style="color: var(--primary); margin-right: 6px;"></i>
                Your feedback is confidential and will be reviewed by the system administrators to improve service quality.
            </p>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
