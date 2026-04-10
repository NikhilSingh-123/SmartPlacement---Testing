<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    // Safely check for existing sessions to prevent NullPointerException
    Object student = session.getAttribute("student");
    Object company = session.getAttribute("company");
    Object admin = session.getAttribute("admin");

    if (student != null) {
       response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
       return;
    }
    if (company != null) {
       response.sendRedirect(request.getContextPath() + "/company/dashboard.jsp");
       return;
    }
    if (admin != null) {
       response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
       return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Placement | Next-Gen Career Ecosystem</title>
    
    <!-- Unified Design System -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/landing.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        .auth-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(10, 25, 41, 0.85);
            backdrop-filter: blur(12px);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .auth-overlay.active { display: flex; animation: fadeIn 0.4s ease; }
        
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        .auth-card {
            background: white;
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.3);
            position: relative;
        }
    </style>
</head>
<body>

<div class="scroll-progress"></div>

<!-- 1. Navbar Elite -->
<nav class="navbar" id="navbar">
    <div class="logo">
        <i class="fa-solid fa-square-poll-vertical" style="color: var(--primary); font-size: 32px;"></i>
        <span style="margin-left: 8px; font-weight: 800; font-size: 24px; letter-spacing: -0.02em; color: var(--text-head);">SmartPlacement</span>
    </div>
    <div class="nav-links">
        <a href="#features">Ecosystem</a>
        <a href="#stats">Success</a>
        <a href="#partners">Partners</a>
        <button onclick="openAuth()" class="btn-login">Candidate Hub</button>
    </div>
</nav>

<!-- 2. Hero Section: Cinematic Entrance -->
<section class="hero" id="hero">
    <div class="hero-content" data-aos="fade-right" data-aos-duration="1200">
        <h1 style="color: white;">Accelerate Your <br><span style="color: var(--accent);">Professional Orbit.</span></h1>
        <p style="color: rgba(255,255,255,0.85);">The ultimate bridge between high-potential academic talent and world-leading corporate innovators. AI-driven matching at scale.</p>
        <div style="display: flex; gap: 20px; margin-top: 40px;">
             <button onclick="openAuth()" class="btn-login" style="padding: 18px 40px; font-size: 16px;">Get Started</button>
             <a href="#features" style="display: flex; align-items: center; gap: 10px; color: white; text-decoration: none; font-weight: 700;">Explore Ecosystem <i class="fa-solid fa-arrow-down"></i></a>
        </div>
    </div>
    <div class="hero-image" data-aos="zoom-in" data-aos-duration="1500">
        <img src="<%=request.getContextPath()%>/images/student.png" alt="Portal Preview" style="max-height: 600px; filter: drop-shadow(0 20px 40px rgba(0,0,0,0.3));">
    </div>
</section>

<!-- 3. Features: Interaction Grid -->
<section id="features" style="background: white;">
    <div class="section-title" style="text-align: center; margin-bottom: 80px;" data-aos="fade-up">
        <h2 style="font-size: 3rem; font-weight: 800;">Built for <span style="color: var(--primary);">Impact.</span></h2>
        <p style="margin: 20px auto 0; max-width: 600px;">Every module is engineered to maximize your placement probability and recruitment efficiency.</p>
    </div>
    
    <div class="feature-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 40px;">
        <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fa-solid fa-bolt"></i>
            <h3>Automated Matching</h3>
            <p>Our algorithms scan thousands of roles to find the perfect fit for your specific skill set.</p>
        </div>
        <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fa-solid fa-shield-halved"></i>
            <h3>Direct Channels</h3>
            <p>Directly communicate with corporate hiring managers without middle-tier barriers.</p>
        </div>
        <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
            <i class="fa-solid fa-chart-column"></i>
            <h3>Talent Analytics</h3>
            <p>Gain insights into your application performance and areas for skill optimization.</p>
        </div>
    </div>
</section>

<!-- 4. Stats: Visual Depth -->
<section class="stats" id="stats" data-aos="fade-up">
    <div class="stat-item">
        <h3 class="stat-number" data-target="300">0</h3>
        <p style="color: rgba(255,255,255,0.6); font-weight: 600;">Global Partners</p>
    </div>
    <div class="stat-item">
        <h3 class="stat-number" data-target="95">0</h3>
        <p style="color: rgba(255,255,255,0.6); font-weight: 600;">Placement Rate %</p>
    </div>
    <div class="stat-item">
        <h3 class="stat-number" data-target="15000">0</h3>
        <p style="color: rgba(255,255,255,0.6); font-weight: 600;">Career Successes</p>
    </div>
</section>

<footer style="padding: 80px 10%; background: #051426; color: white; text-align: center;">
    <h2 style="color: white; margin-bottom: 20px;">Join the Ecosystem.</h2>
    <p style="opacity: 0.7; margin-bottom: 40px;">Experience the next generation of academic-corporate synergy.</p>
    <div style="display: flex; gap: 24px; justify-content: center;">
        <a href="#" style="color: white; font-size: 24px;"><i class="fa-brands fa-linkedin"></i></a>
        <a href="#" style="color: white; font-size: 24px;"><i class="fa-brands fa-twitter"></i></a>
    </div>
    <div style="margin-top: 60px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 30px; font-size: 14px; opacity: 0.5;">
        &copy; 2026 Smart Placement System. All Rights Reserved.
    </div>
</footer>

<!-- Auth Overlay -->
<div class="auth-overlay" id="authOverlay">
    <div class="auth-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
            <h2 style="font-size: 24px; font-weight: 800; color: var(--primary);">Secure Login</h2>
            <i class="fa-solid fa-xmark" onclick="closeAuth()" style="cursor: pointer; font-size: 20px; color: var(--text-muted);"></i>
        </div>
        
        <div style="display: flex; background: #f3f4f6; padding: 4px; border-radius: 50px; margin-bottom: 32px;">
            <button onclick="setRole('student', this)" class="role-btn active" style="flex:1; border:none; padding: 10px; border-radius:50px; background: var(--primary); color: white; cursor: pointer; font-weight: 700;">Student</button>
            <button onclick="setRole('company', this)" class="role-btn" style="flex:1; border:none; padding: 10px; border-radius:50px; background: transparent; color: var(--text-muted); cursor: pointer; font-weight: 700;">Company</button>
            <button onclick="setRole('admin', this)" class="role-btn" style="flex:1; border:none; padding: 10px; border-radius:50px; background: transparent; color: var(--text-muted); cursor: pointer; font-weight: 700;">Admin</button>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="role" id="currentRole" value="student">
            <div style="margin-bottom: 20px;">
                <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase;">Corporate ID / Email</label>
                <input type="email" name="email" placeholder="name@domain.com" style="width: 100%; padding: 14px; border-radius: 12px; border: 1px solid var(--border); background: #fafafa; font-weight: 600;" required>
            </div>
            <div style="margin-bottom: 32px;">
                <label style="display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase;">Access Key</label>
                <input type="password" name="password" placeholder="••••••••" style="width: 100%; padding: 14px; border-radius: 12px; border: 1px solid var(--border); background: #fafafa; font-weight: 600;" required>
            </div>
            <button type="submit" class="btn-login" style="width: 100%; border: none; padding: 16px; font-size: 16px;">Authorize Access</button>
        </form>
        
        <div id="signUpCta" style="margin-top: 24px; text-align: center; font-size: 14px; color: var(--text-muted);">
            New partner? <a id="registerLink" href="<%=request.getContextPath()%>/student/register.jsp" style="color: var(--primary); font-weight: 700; text-decoration: none;">Join the Ecosystem</a>
        </div>
    </div>
</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 1000, once: true });

    function openAuth() { document.getElementById('authOverlay').classList.add('active'); }
    function closeAuth() { document.getElementById('authOverlay').classList.remove('active'); }
    
    function setRole(role, btn) {
        document.getElementById('currentRole').value = role;
        document.querySelectorAll('.role-btn').forEach(b => {
             b.style.background = 'transparent';
             b.style.color = 'var(--text-muted)';
        });
        btn.style.background = 'var(--primary)';
        btn.style.color = 'white';
        
        const cta = document.getElementById('signUpCta');
        const link = document.getElementById('registerLink');
        if (role === 'admin') {
            cta.style.opacity = '0';
        } else {
            cta.style.opacity = '1';
            link.href = (role === 'company') ? '<%=request.getContextPath()%>/company/register.jsp' : '<%=request.getContextPath()%>/student/register.jsp';
        }
    }

    // Scroll Logic
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('navbar');
        const progress = document.querySelector('.scroll-progress');
        const scrollPercent = (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100;
        
        progress.style.width = scrollPercent + '%';
        
        if(window.scrollY > 100) nav.classList.add('scrolled');
        else nav.classList.remove('scrolled');
    });

    // Stat Counter
    const counters = document.querySelectorAll('.stat-number');
    const animateCounters = () => {
        counters.forEach(counter => {
            const target = +counter.getAttribute('data-target');
            const count = +counter.innerText;
            const inc = target / 40;
            if (count < target) {
                counter.innerText = Math.ceil(count + inc);
                setTimeout(animateCounters, 30);
            } else {
                counter.innerText = target;
            }
        });
    };
    
    // Trigger counters on scroll
    window.addEventListener('scroll', function counterHandler() {
        const stats = document.getElementById('stats');
        if(stats.getBoundingClientRect().top < window.innerHeight) {
            animateCounters();
            window.removeEventListener('scroll', counterHandler);
        }
    });
</script>

</body>
</html>