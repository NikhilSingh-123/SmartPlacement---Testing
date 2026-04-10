<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Login | Smart Placement</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <i class="fa-solid fa-graduation-cap"></i> SmartPlacement
        </a>
    </nav>

    <main class="login-container">
        <div class="login-card">
            <div class="illustration-side" style="background: linear-gradient(135deg, #1d4ed8, #0f2744);">
                <div>
                    <h1>Recruiter Console.</h1>
                    <p>Access your dashboard to manage job drives, track applications, and select top talent.</p>
                </div>
                <img src="${pageContext.request.contextPath}/images/student.png" alt="Company Success">
            </div>

            <div class="form-side">
                <div class="form-header">
                    <h2>Company Sign In</h2>
                    <p>Welcome back! Please login with your corporate email.</p>
                </div>

                <!-- Messages -->
                <c:if test="${param.msg == 'registered'}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i> Registration successful! Please login.
                    </div>
                </c:if>
                <c:if test="${param.error == 'invalid'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Invalid Corporate Credentials.
                    </div>
                </c:if>

                <form action="../CompanyLoginServlet" method="post">
                    <div class="form-group">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" placeholder="Corporate Email" required>
                    </div>
                    <div class="form-group" style="position: relative;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 12px; top: 12px;"></i>
                        <input type="password" name="password" id="companyLoginPassword" placeholder="Password" 
                            required style="width: 100%; padding: 12px 12px 12px 36px;">
                        <i class="fa-solid fa-eye" id="toggleCompanyLoginPassword" 
                            style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);"></i>
                    </div>

                    <script>
                        const toggleCompanyLoginPassword = document.querySelector("#toggleCompanyLoginPassword");
                        const companyLoginPassword = document.querySelector("#companyLoginPassword");

                        toggleCompanyLoginPassword.addEventListener("click", function () {
                            const type = companyLoginPassword.getAttribute("type") === "password" ? "text" : "password";
                            companyLoginPassword.setAttribute("type", type);
                            this.classList.toggle("fa-eye-slash");
                        });
                    </script>

                    <button type="submit" class="btn-auth">
                        Recruiter Login <i class="fa-solid fa-arrow-right-long"></i>
                    </button>
                    
                    <p style="text-align: center; margin-top: 15px; font-size: 13px;">
                        New here? <a href="register.jsp">Register your company</a>
                    </p>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
