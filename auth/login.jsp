<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Redirect if already logged in
    if (session.getAttribute("userObj") != null) {
        String role = (String) session.getAttribute("role");
        if ("student".equals(role)) response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
        else if ("company".equals(role)) response.sendRedirect(request.getContextPath() + "/companyDashboard");
        else if ("admin".equals(role)) response.sendRedirect(request.getContextPath() + "/adminDashboard");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Login | Smart Placement System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

    <!-- Minimal Navbar -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <i class="fa-solid fa-graduation-cap"></i> SmartPlacement
        </a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">
            <i class="fa-solid fa-house"></i> Back to Home
        </a>
    </nav>

    <main class="login-container">
        <div class="login-card">
            
            <!-- Left Side illustration -->
            <div class="illustration-side">
                <div>
                    <h1>Welcome to <br>Your Future.</h1>
                    <p>Access exclusive top-tier job drives and AI-driven career insights tailored for your professional growth.</p>
                </div>
                <img src="${pageContext.request.contextPath}/images/student.png" alt="Candidate Success">
            </div>

            <!-- Right Side Form -->
            <div class="form-side" id="loginArea">
                <div class="form-header reveal reveal-delay-1">
                    <h2>Sign In</h2>
                    <p>Enter your credentials to access the portal.</p>
                </div>

                <!-- Error Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error reveal">
                        <i class="fa-solid fa-circle-exclamation"></i> ${error}
                        <c:remove var="error" scope="session" />
                    </div>
                </c:if>

                <!-- Success messages (e.g. from registration) -->
                <c:if test="${param.msg == 'registered'}">
                    <div class="alert alert-success reveal">
                        <i class="fa-solid fa-circle-check"></i> Registration successful! Please login.
                    </div>
                </c:if>

                <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                    <!-- Role Selection -->
                    <div class="role-selector" style="display: flex; background: #f3f4f6; padding: 4px; border-radius: 50px; margin-bottom: 24px;">
                        <button type="button" class="role-btn active" style="flex:1; border:none; padding:10px; border-radius:50px; background:var(--primary); color:white; font-weight:700; cursor:pointer;" onclick="setRole('student', this)">Candidate</button>
                        <button type="button" class="role-btn" style="flex:1; border:none; padding:10px; border-radius:50px; background:transparent; color:var(--text-muted); font-weight:700; cursor:pointer;" onclick="setRole('company', this)">Company</button>
                        <button type="button" class="role-btn" style="flex:1; border:none; padding:10px; border-radius:50px; background:transparent; color:var(--text-muted); font-weight:700; cursor:pointer;" onclick="setRole('admin', this)">Admin</button>
                    </div>
                    <input type="hidden" name="role" id="currentRole" value="student">

                    <div class="form-group reveal reveal-delay-2">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="text" name="email" placeholder="Email Address / Admin Username" required>
                    </div>
                    <div class="form-group reveal reveal-delay-3" style="position: relative;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 12px; top: 18px; color: var(--text-muted);"></i>
                        <input type="password" name="password" id="passwordField" placeholder="Password"
                            required style="width: 100%; padding: 12px 12px 12px 36px; border: 1px solid var(--border); border-radius: 4px;">
                        <i class="fa-solid fa-eye" id="togglePasswordField" 
                            style="position: absolute; right: 12px; top: 18px; cursor: pointer; color: var(--text-muted);"></i>
                    </div>

                    <div class="form-options reveal reveal-delay-4">
                        <label class="checkbox-container">
                            <input type="checkbox" name="remember"> Remember me
                        </label>
                        <a href="#" class="forgot-link">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn btn-primary reveal reveal-delay-5" style="width: 100%;">
                        Sign In <i class="fa-solid fa-arrow-right-long"></i>
                    </button>
                </form>

                <div class="register-cta reveal reveal-delay-5">
                    <p>New to SmartPlacement? <a id="registerLink" href="${pageContext.request.contextPath}/student/register.jsp">Create an account</a></p>
                </div>
            </div>
        </div>
    </main>

    <script>
        const togglePasswordField = document.querySelector("#togglePasswordField");
        const passwordField = document.querySelector("#passwordField");

        togglePasswordField.addEventListener("click", function () {
            const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
            passwordField.setAttribute("type", type);
            this.classList.toggle("fa-eye-slash");
        });

        function setRole(role, btn) {
            document.getElementById('currentRole').value = role;
            
            // Update form action and register link based on role
            const form = document.getElementById('loginForm');
            const registerLink = document.getElementById('registerLink');
            
            if (role === 'company') {
                form.action = '${pageContext.request.contextPath}/CompanyLoginServlet';
                if(registerLink) { registerLink.href = '${pageContext.request.contextPath}/company/register.jsp'; registerLink.style.display = 'inline'; }
            } else if (role === 'student') {
                form.action = '${pageContext.request.contextPath}/StudentLoginServlet';
                if(registerLink) { registerLink.href = '${pageContext.request.contextPath}/student/register.jsp'; registerLink.style.display = 'inline'; }
            } else {
                form.action = '${pageContext.request.contextPath}/AdminLoginServlet';
                if(registerLink) { registerLink.style.display = 'none'; }
            }

            document.querySelectorAll('.role-btn').forEach(b => {
                b.style.background = 'transparent';
                b.style.color = 'var(--text-muted)';
            });
            btn.style.background = 'var(--primary)';
            btn.style.color = 'white';
        }

        function togglePassword() {
            const passwordField = document.getElementById('passwordField');
            const toggleIcon = document.querySelector('.password-toggle');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            }
        }

        // Magnetic Button Effect
        const btn = document.querySelector('.btn-auth');
        btn.addEventListener('mousemove', (e) => {
            const rect = btn.getBoundingClientRect();
            const x = e.clientX - rect.left - rect.width / 2;
            const y = e.clientY - rect.top - rect.height / 2;
            btn.style.transform = `translate(${x * 0.2}px, ${y * 0.2}px)`;
        });
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = '';
        });
    </script>
</body>
</html>
