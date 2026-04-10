<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Registration | Smart Placement</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <i class="fa-solid fa-graduation-cap"></i> SmartPlacement
        </a>
        <a href="login.jsp" class="back-link">
            Already registered? Sign in
        </a>
    </nav>

    <main class="login-container">
        <div class="login-card">
            <div class="illustration-side">
                <div>
                    <h1>Partner with Us.</h1>
                    <p>Connect with top talent and streamline your recruitment process with our AI-enhanced placement portal.</p>
                </div>
                <img src="${pageContext.request.contextPath}/images/student.png" alt="Company Success">
            </div>

            <div class="form-side">
                <div class="form-header">
                    <h2>Corporate Registration</h2>
                    <p>Create your company profile to start hiring.</p>
                </div>

                <!-- Error Messages -->
                <c:if test="${param.error == 'missing'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Please fill in all required fields.
                    </div>
                </c:if>
                <c:if test="${param.error == 'duplicate'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Email already registered. Please login.
                    </div>
                </c:if>
                <c:if test="${param.error == 'failed' || param.error == 'internal'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Registration failed. Please try again.
                    </div>
                </c:if>
                <c:if test="${param.error == 'invalid_email'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Invalid email format.
                    </div>
                </c:if>
                <c:if test="${param.error == 'weak_password'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Password must be at least 6 characters.
                    </div>
                </c:if>
                <c:if test="${param.error == 'invalid_contact'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Invalid contact number format.
                    </div>
                </c:if>

                <form action="../CompanyRegisterServlet" method="post">
                    <div class="form-group">
                        <i class="fa-solid fa-building"></i>
                        <input type="text" name="companyName" placeholder="Company Name" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" placeholder="Corporate Email" required>
                    </div>
                    <div class="form-group" style="position: relative;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 12px; top: 12px;"></i>
                        <input type="password" name="password" id="companyPasswordInput" placeholder="Create Password" 
                            required style="width: 100%; padding: 12px 12px 12px 36px;">
                        <i class="fa-solid fa-eye" id="toggleCompanyPassword" 
                            style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);"></i>
                    </div>

                    <script>
                        const toggleCompanyPassword = document.querySelector("#toggleCompanyPassword");
                        const companyPasswordInput = document.querySelector("#companyPasswordInput");

                        toggleCompanyPassword.addEventListener("click", function () {
                            const type = companyPasswordInput.getAttribute("type") === "password" ? "text" : "password";
                            companyPasswordInput.setAttribute("type", type);
                            this.classList.toggle("fa-eye-slash");
                        });
                    </script>
                    <div class="form-group">
                        <i class="fa-solid fa-phone"></i>
                        <input type="text" name="contact" placeholder="HR Contact Number" required>
                    </div>
                    <div class="form-group">
                        <i class="fa-solid fa-globe"></i>
                        <input type="text" name="website" placeholder="Website URL (Optional)">
                    </div>
                    <div class="form-group" style="padding: 10px;">
                        <textarea name="description" placeholder="Short Company Description" style="width: 100%; min-height: 100px; border: none; outline: none; background: transparent; font-family: inherit; font-size: 14px; color: var(--text-main); margin-left: 25px;"></textarea>
                    </div>

                    <button type="submit" class="btn-auth">
                        Register Company <i class="fa-solid fa-arrow-right-long"></i>
                    </button>
                    </button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
