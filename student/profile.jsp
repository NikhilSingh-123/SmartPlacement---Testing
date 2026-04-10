<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty sessionScope.userObj}">
    <c:redirect url="/login.jsp" />
</c:if>

<jsp:include page="/includes/header.jsp" />

<c:set var="student" value="${sessionScope.userObj}" />

<div style="max-width: 1128px; margin: 24px auto; display: flex; gap: 24px; padding: 0 16px;">
    
    <!-- Sidebar Inclusion -->
    <jsp:include page="/includes/student_sidebar.jsp" />

    <!-- Main Content -->
    <main style="flex: 1; margin-left: 304px;">
        
        <!-- Profile Header Hub -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="profile-banner" style="background-image: url('${not empty student.coverPhoto ? pageContext.request.contextPath.concat('/').concat(student.coverPhoto) : ''}');">
                <form id="coverForm" action="${pageContext.request.contextPath}/FileUploadServlet" method="post" enctype="multipart/form-data" style="position: absolute; top: 10px; right: 10px;">
                    <input type="hidden" name="uploadType" value="cover">
                    <label for="coverInput" style="background: white; padding: 10px; border-radius: 50%; cursor: pointer; box-shadow: var(--shadow-sm);">
                        <i class="fa-solid fa-camera"></i>
                        <input type="file" id="coverInput" name="file" style="display: none;" onchange="this.form.submit()">
                    </label>
                </form>
                
                <div class="profile-avatar-wrapper">
                    <img src="${not empty student.profilePhoto ? pageContext.request.contextPath.concat('/').concat(student.profilePhoto) : pageContext.request.contextPath.concat('/images/chatbot.png')}" alt="Student Profile">
                    <form id="profileForm" action="${pageContext.request.contextPath}/FileUploadServlet" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="uploadType" value="profile">
                        <input type="file" id="profileInput" name="file" style="display: none;" onchange="this.form.submit()">
                        <label for="profileInput" style="position: absolute; inset: 0; cursor: pointer;"></label>
                    </form>
                </div>
            </div>
            <div style="padding: 80px 40px 40px;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h1 style="margin: 0;">${student.name}</h1>
                        <p style="font-size: 18px; color: var(--text-muted); margin-top: 8px;">${student.branch} Student | ${student.email}</p>
                        <p style="font-size: 14px; color: var(--text-muted); margin-top: 4px;">Contact: ${student.contactNumber}</p>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 32px; font-weight: 800; color: var(--primary);">${student.cgpa}</div>
                        <div style="font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Cummulative GPA</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Sections -->
        <div id="edit" class="card" style="padding: 32px; margin-bottom: 24px;">
            <h3 style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px;">
                <i class="fa-solid fa-pen-to-square" style="color: var(--primary);"></i> Edit Profile Details
            </h3>
            <form action="${pageContext.request.contextPath}/studentAction" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                    <div class="form-group">
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px;">FULL NAME</label>
                        <input type="text" name="name" value="${student.name}" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 16px;">
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px;">ACADEMIC BRANCH</label>
                        <input type="text" name="branch" value="${student.branch}" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 16px;">
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px;">CURRENT CGPA</label>
                        <input type="number" step="0.01" name="cgpa" value="${student.cgpa}" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 16px;">
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px;">CONTACT NUMBER</label>
                        <input type="text" name="contactNumber" value="${student.contactNumber}" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 16px;">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary" style="margin-top: 24px; padding: 12px 40px; border-radius: 50px;">Save Profile Changes</button>
            </form>
        </div>

        <div id="resume" class="card" style="padding: 32px;">
            <h3 style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px;">
                <i class="fa-solid fa-file-pdf" style="color: var(--primary);"></i> Resume Management
            </h3>
            <c:if test="${not empty student.resumePath}">
                <div style="background: #f0f7ff; padding: 20px; border-radius: 12px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center;">
                    <div style="display: flex; gap: 16px; align-items: center;">
                        <i class="fa-solid fa-file-check" style="font-size: 32px; color: var(--primary);"></i>
                        <div>
                            <div style="font-weight: 700;">Active Resume Found</div>
                            <div style="font-size: 12px; color: var(--text-muted);">${student.resumePath}</div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/${student.resumePath}" class="btn btn-outline" style="border-radius: 50px;">Download PDF</a>
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/studentAction" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="uploadResume">
                <p style="font-size: 14px; color: var(--text-muted); margin-bottom: 12px;">Update your professional resume (PDF format only, max 5MB).</p>
                <div style="display: flex; gap: 16px;">
                    <input type="file" name="resume" required style="flex: 1; padding: 10px; border: 2px dashed var(--border); border-radius: 8px;">
                    <button type="submit" class="btn btn-primary" style="padding: 10px 30px; border-radius: 50px;">Upload Now</button>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />
