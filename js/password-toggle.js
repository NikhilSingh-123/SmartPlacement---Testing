document.addEventListener('DOMContentLoaded', function() {
    const passwordFields = document.querySelectorAll('input[type="password"]');
    
    passwordFields.forEach(field => {
        // Create wrapper
        const wrapper = document.createElement('div');
        wrapper.className = 'password-box';
        field.parentNode.insertBefore(wrapper, field);
        wrapper.appendChild(field);
        
        // Add eye icon
        const icon = document.createElement('i');
        icon.className = 'fa-solid fa-eye toggle-password';
        wrapper.appendChild(icon);
        
        icon.addEventListener('click', function() {
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });
});
