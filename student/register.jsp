<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration | Smart Placement</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <i class="fa-solid fa-graduation-cap"></i> SmartPlacement
        </a>
        <a href="${pageContext.request.contextPath}/login.jsp" class="back-link">
            Already registered? Sign in
        </a>
    </nav>

    <main class="login-container">
        <div class="login-card">
            <div class="illustration-side">
                <div>
                    <h1>Join the Elite.</h1>
                    <p>Connect with top companies and launch your career seamlessly.</p>
                </div>
                <img src="${pageContext.request.contextPath}/images/student.png" alt="Student Success">
            </div>

            <div class="form-side">
                <div class="form-header">
                    <h2>Student Registration</h2>
                    <p>Create your candidate profile to apply for jobs.</p>
                </div>

                <c:if test="${param.error == 'invalid'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Registration failed. Please check your details.
                    </div>
                </c:if>

                <form action="<%=request.getContextPath()%>/StudentRegisterServlet" method="post">
                    <div class="form-group">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" name="name" placeholder="Full Name" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" placeholder="Student Email" required>
                    </div>
                    <div class="form-group" style="position: relative;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 12px; top: 12px;"></i>
                        <input type="password" name="password" id="studentPassword" placeholder="Create Password" 
                            required style="width: 100%; padding: 12px 12px 12px 36px;">
                        <i class="fa-solid fa-eye" id="toggleStudentPassword" 
                            style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);"></i>
                    </div>

                    <script>
                        const toggleStudentPassword = document.querySelector("#toggleStudentPassword");
                        const studentPassword = document.querySelector("#studentPassword");

                        toggleStudentPassword.addEventListener("click", function () {
                            const type = studentPassword.getAttribute("type") === "password" ? "text" : "password";
                            studentPassword.setAttribute("type", type);
                            this.classList.toggle("fa-eye-slash");
                        });
                    </script>
                    <div class="form-group">
                        <i class="fa-solid fa-code-branch"></i>
                        <input type="text" name="branch" placeholder="Degree/Branch" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-graduation-cap"></i>
                        <input type="number" step="0.01" name="cgpa" placeholder="CGPA" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-phone"></i>
                        <input type="text" name="contact" placeholder="Contact Number" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-building-columns"></i>
                        <input type="text" name="collegeName" placeholder="College/University Name" required>
                    </div>

                    <button type="submit" class="btn-auth">
                        Register as Student <i class="fa-solid fa-arrow-right-long"></i>
                    </button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
