<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% 
    // Safely check for existing sessions
    Object student = session.getAttribute("student");
    Object company = session.getAttribute("company");
    Object admin = session.getAttribute("admin");

    if (student != null) { 
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp"); 
        return;
    } 
    if (company != null) { 
        response.sendRedirect(request.getContextPath() + "/companyDashboard"); 
        return;
    } 
    if (admin != null) { 
        response.sendRedirect(request.getContextPath() + "/adminDashboard"); 
        return;
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
                                <p>Access exclusive top-tier job drives and AI-driven career insights tailored for your
                                    professional growth.</p>
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
                                <div class="role-selector"
                                    style="display: flex; background: #f3f4f6; padding: 4px; border-radius: 50px; margin-bottom: 24px;">
                                    <button type="button" class="role-btn active"
                                        style="flex:1; border:none; padding:10px; border-radius:50px; background:var(--primary); color:white; font-weight:700; cursor:pointer;"
                                        onclick="setRole('student', this)">Candidate</button>
                                    <button type="button" class="role-btn"
                                        style="flex:1; border:none; padding:10px; border-radius:50px; background:transparent; color:var(--text-muted); font-weight:700; cursor:pointer;"
                                        onclick="setRole('company', this)">Company</button>
                                    <button type="button" class="role-btn"
                                        style="flex:1; border:none; padding:10px; border-radius:50px; background:transparent; color:var(--text-muted); font-weight:700; cursor:pointer;"
                                        onclick="setRole('admin', this)">Admin</button>
                                </div>
                                <input type="hidden" name="role" id="currentRole" value="student">

                                <div class="form-group reveal reveal-delay-2">
                                    <i class="fa-solid fa-envelope"></i>
                                    <input type="text" name="email" placeholder="Email Address / Admin Username"
                                        required>
                                </div>

                                <div class="form-group reveal reveal-delay-4" style="position: relative;">
                                <label style="display: block; font-size: 13px; font-weight: 700; margin-bottom: 6px;">Password</label>
                                <input type="password" name="password" id="passwordInput" required
                                    style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 4px; font-size: 14px;">
                                <i class="fa-solid fa-eye" id="togglePassword" 
                                    style="position: absolute; right: 12px; top: 38px; cursor: pointer; color: var(--text-muted);"></i>
                            </div>

                            <button type="submit" class="btn btn-primary reveal reveal-delay-5"
                                style="width: 100%; margin-top: 12px;">Sign in</button>
                        </form>

                        <div class="register-cta reveal reveal-delay-5">
                            <p>New to SmartPlacement? <a id="registerLink"
                                    href="${pageContext.request.contextPath}/student/register.jsp">Create an account</a>
                            </p>
                        </div>
                    </div>
                </div>
            </main>

            <script>
                const togglePassword = document.querySelector("#togglePassword");
                const passwordInput = document.querySelector("#passwordInput");

                togglePassword.addEventListener("click", function () {
                    const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
                    passwordInput.setAttribute("type", type);
                    this.classList.toggle("fa-eye-slash");
                });

                function setRole(role, btn) {
                        document.getElementById('currentRole').value = role;

                        // Update form action and register link based on role
                        const form = document.getElementById('loginForm');
                        const registerLink = document.getElementById('registerLink');
                        if (role === 'company') {
                            if (registerLink) { registerLink.href = '${pageContext.request.contextPath}/company/register.jsp'; registerLink.style.display = 'inline'; }
                        } else if (role === 'student') {
                            if (registerLink) { registerLink.href = '${pageContext.request.contextPath}/student/register.jsp'; registerLink.style.display = 'inline'; }
                        } else {
                            if (registerLink) { registerLink.style.display = 'none'; } // No admin registration
                        }

                        document.querySelectorAll('.role-btn').forEach(b => {
                            b.style.background = 'transparent';
                            b.style.color = 'var(--text-muted)';
                        });
                        btn.style.background = 'var(--primary)';
                        btn.style.color = 'white';
                    }




                </script>
            </body>

            </html>