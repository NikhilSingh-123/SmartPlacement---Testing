<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | Smart Placement</title>
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
        <div class="login-card" style="max-width: 450px;">
            <div class="form-side" style="width: 100%;">
                <div class="form-header">
                    <div style="background: var(--primary); width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                        <i class="fa-solid fa-user-shield" style="color: white; font-size: 28px;"></i>
                    </div>
                    <h2>Admin Console</h2>
                    <p>Enter administrative credentials to proceed.</p>
                </div>

                <!-- Error Messages -->
                <c:if test="${param.error == 'invalid'}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i> Invalid Admin Credentials.
                    </div>
                </c:if>

                <form action="../AdminLoginServlet" method="post">
                    <div class="form-group">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" placeholder="Admin Email" required>
                    </div>
                    <div class="form-group" style="position: relative;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 12px; top: 12px;"></i>
                        <input type="password" name="password" id="adminPasswordInput" placeholder="Password" 
                            required style="width: 100%; padding: 12px 12px 12px 36px;">
                        <i class="fa-solid fa-eye" id="toggleAdminPassword" 
                            style="position: absolute; right: 12px; top: 12px; cursor: pointer; color: var(--text-muted);"></i>
                    </div>

                    <script>
                        const toggleAdminPassword = document.querySelector("#toggleAdminPassword");
                        const adminPasswordInput = document.querySelector("#adminPasswordInput");

                        toggleAdminPassword.addEventListener("click", function () {
                            const type = adminPasswordInput.getAttribute("type") === "password" ? "text" : "password";
                            adminPasswordInput.setAttribute("type", type);
                            this.classList.toggle("fa-eye-slash");
                        });
                    </script>

                    <button type="submit" class="btn-auth" style="background: #111827; margin-top: 10px;">
                        Secure Login <i class="fa-solid fa-shield-halved"></i>
                    </button>
                    
                    <p style="text-align: center; margin-top: 20px; font-size: 13px;">
                        <a href="${pageContext.request.contextPath}/login.jsp" style="color: var(--text-muted);">Switch to Candidate Login</a>
                    </p>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
