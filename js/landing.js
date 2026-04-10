document.addEventListener('DOMContentLoaded', () => {
    // 1. Elite Scroll Progress
    const progress = document.createElement('div');
    progress.className = 'scroll-progress';
    document.body.appendChild(progress);

    window.addEventListener('scroll', () => {
        const totalHeight = document.body.scrollHeight - window.innerHeight;
        const width = (window.scrollY / totalHeight) * 100;
        progress.style.width = width + '%';
        
        // Elite Navbar State
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 2. Refined Stats Counter
    const stats = document.querySelectorAll('.stat-number');
    const observerOptions = { threshold: 0.6 };
    
    const countUp = (entry) => {
        if (entry.isIntersecting) {
            const target = +entry.target.getAttribute('data-target');
            const duration = 2000;
            const step = (target / duration) * 10;
            let current = 0;
            
            const animate = () => {
                current += step;
                if (current < target) {
                    entry.target.innerText = Math.ceil(current);
                    setTimeout(animate, 10);
                } else {
                    entry.target.innerText = target + (entry.target.innerText.includes('%') ? '%' : '');
                }
            };
            animate();
            observer.unobserve(entry.target);
        }
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(countUp);
    }, observerOptions);

    stats.forEach(s => observer.observe(s));

    // 3. Magnetic Hover Effect (Subtle for CTAs)
    const magneticBtns = document.querySelectorAll('.btn-hero, .btn-login');
    magneticBtns.forEach(btn => {
        btn.addEventListener('mousemove', (e) => {
            const rect = btn.getBoundingClientRect();
            const x = e.clientX - rect.left - rect.width / 2;
            const y = e.clientY - rect.top - rect.height / 2;
            btn.style.transform = `translate(${x * 0.2}px, ${y * 0.2}px) scale(1.05)`;
        });
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = '';
        });
    });

    // 4. Smooth Scroll for Anchor Links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
