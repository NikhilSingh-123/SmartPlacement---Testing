<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartplacement.dao.NotificationDAO, com.smartplacement.model.Student, java.util.List" %>

<c:if test="${empty sessionScope.userObj || sessionScope.role != 'student'}">
    <c:redirect url="/index.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<%
    Student s = (Student) session.getAttribute("userObj");
    NotificationDAO nDao = new NotificationDAO();
    List<com.smartplacement.dao.NotificationDAO.Notification> notifications = nDao.getNotificationsByStudent(s.getId());
    request.setAttribute("notifications", notifications);
%>

<div class="feed-container">
    <!-- Left: Profile Summary -->
    <aside class="left-sidebar reveal reveal-delay-1">
        <div class="card profile-summary">
            <div class="cover" style="background: linear-gradient(135deg, var(--primary), #1e40af);"></div>
            <div style="width: 64px; height: 64px; background: white; border-radius: 50%; border: 1px solid var(--border); margin: -32px auto 0; display: flex; align-items: center; justify-content: center; position: relative; z-index: 2; overflow: hidden;">
                <i class="fa-solid fa-user-graduate" style="font-size: 28px; color: var(--primary);"></i>
            </div>
            <h3 style="margin-top: 12px; font-weight: 700;">${sessionScope.userObj.name}</h3>
            <p style="padding: 0 16px; font-size: 13px; color: var(--text-muted);">${sessionScope.userObj.branch}</p>
        </div>
    </aside>

    <!-- Center: Notification Feed -->
    <main class="main-feed reveal reveal-delay-2">
        <div class="card" style="padding: 24px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 style="font-size: 20px; font-weight: 800; color: var(--text-main);">Notifications</h1>
                <p style="font-size: 14px; color: var(--text-muted); margin-top: 4px;">Stay updated on your placement journey.</p>
            </div>
            <form action="${pageContext.request.contextPath}/studentAction" method="post">
                <input type="hidden" name="action" value="markNotificationsRead">
                <button type="submit" class="btn btn-outline" style="font-size: 12px; border-radius: 8px;">Mark as read</button>
            </form>
        </div>

        <div id="notificationFeed">
            <c:forEach var="n" items="${notifications}">
                <div class="card reveal reveal-delay-3" style="padding: 20px; border-left: 4px solid ${n.read ? 'transparent' : 'var(--primary)'}; background: ${n.read ? 'white' : 'var(--primary-light)'}; margin-bottom: 12px;">
                    <div style="display: flex; gap: 16px;">
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: white; border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                             <i class="fa-solid ${n.message.contains('Selected') ? 'fa-medal' : (n.message.contains('Drive') ? 'fa-briefcase' : 'fa-info-circle')}" 
                                style="font-size: 20px; color: ${n.message.contains('Selected') ? '#f59e0b' : 'var(--primary)'};"></i>
                        </div>
                        <div style="flex: 1;">
                            <p style="font-size: 15px; font-weight: ${n.read ? '600' : '800'}; color: var(--text-main); line-height: 1.5;">${n.message}</p>
                            <div style="font-size: 11px; color: var(--text-muted); margin-top: 8px;">${n.createdAt}</div>
                        </div>
                        <c:if test="${!n.read}">
                             <div style="width: 8px; height: 8px; background: var(--primary); border-radius: 50%; margin-top: 8px;"></div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty notifications}">
            <div class="card" style="padding: 100px 24px; text-align: center;">
                <i class="fa-solid fa-bell-slash" style="font-size: 64px; color: var(--border); margin-bottom: 24px; opacity: 0.3;"></i>
                <h3 style="font-weight: 800; color: var(--text-muted);">Inbox Empty</h3>
                <p style="margin-top: 8px; color: var(--text-muted);">We'll notify you when companies post results or updates.</p>
            </div>
        </c:if>
    </main>

    <!-- Right: Quick Actions -->
    <aside class="right-sidebar reveal reveal-delay-3">
        <div class="card" style="padding: 20px;">
             <h3 style="font-size: 14px; font-weight: 800; text-transform: uppercase; color: var(--text-muted); margin-bottom: 20px;">Manage</h3>
             <ul style="list-style: none; display: flex; flex-direction: column; gap: 12px;">
                <li><a href="profile.jsp" style="text-decoration: none; font-size: 13px; font-weight: 700; color: var(--primary);"><i class="fa-solid fa-user-gear" style="margin-right: 8px;"></i> Notification Prefs</a></li>
                <li><a href="jobs.jsp" style="text-decoration: none; font-size: 13px; font-weight: 700; color: var(--primary);"><i class="fa-solid fa-briefcase" style="margin-right: 8px;"></i> View New Jobs</a></li>
             </ul>
        </div>
    </aside>
</div>

<jsp:include page="/includes/footer.jsp" />
