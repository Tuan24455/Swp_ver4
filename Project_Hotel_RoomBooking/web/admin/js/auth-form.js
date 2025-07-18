// Auth Form JavaScript
class AuthForm {
    constructor() {
        this.init();
    }

    init() {
        this.setupPasswordToggle();
        this.setupFormValidation();
        this.setupOTPInputs();
        this.setupTimer();
        this.setupAnimations();
    }

    // Form validation
    setupFormValidation() {
        const forms = document.querySelectorAll('.auth-form');

        forms.forEach((form) => {
            form.addEventListener('submit', (e) => {
                if (!this.validateForm(form)) {
                    e.preventDefault();
                    this.showError('Vui lòng kiểm tra lại thông tin đã nhập');
                }
            });

            const inputs = form.querySelectorAll('.form-input');
            inputs.forEach((input) => {
                input.addEventListener('blur', () => this.validateField(input));
                input.addEventListener('input', () => this.clearFieldError(input));
            });
        });
    }

    validateForm(form) {
        let isValid = true;
        const inputs = form.querySelectorAll('.form-input[required]');

        inputs.forEach((input) => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        const newPassword = form.querySelector('input[name="newpassword"]');
        const confirmPassword = form.querySelector('input[name="confirmpassword"]');

        if (newPassword && confirmPassword) {
            if (newPassword.value !== confirmPassword.value) {
                this.showFieldError(confirmPassword, 'Mật khẩu xác nhận không khớp');
                isValid = false;
            }

            if (!this.validatePassword(newPassword.value)) {
                this.showFieldError(newPassword, 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số');
                isValid = false;
            }
        }

        return isValid;
    }

    validateField(input) {
        const value = input.value.trim();

        if (input.hasAttribute('required') && !value) {
            this.showFieldError(input, 'Trường này không được để trống');
            return false;
        }

        if (input.name === 'otp' && value && !/^\d{8}$/.test(value)) {
            this.showFieldError(input, 'Mã OTP phải có đúng 8 chữ số');
            return false;
        }

        this.clearFieldError(input);
        return true;
    }

    validatePassword(password) {
        return (
                password.length >= 8 &&
                /[A-Z]/.test(password) &&
                /[a-z]/.test(password) &&
                /\d/.test(password)
                );
    }

    showFieldError(input, message) {
        this.clearFieldError(input);

        input.classList.add('error');

        const errorDiv = document.createElement('div');
        errorDiv.className = 'field-error';
        errorDiv.textContent = message;
        errorDiv.style.cssText = `
      color: #e53e3e;
      font-size: 0.875rem;
      margin-top: 0.25rem;
      display: flex;
      align-items: center;
      gap: 0.25rem;
    `;

        const icon = document.createElement('i');
        icon.className = 'fas fa-exclamation-circle';
        errorDiv.insertBefore(icon, errorDiv.firstChild);

        input.parentNode.appendChild(errorDiv);
        input.classList.add('shake');

        setTimeout(() => {
            input.classList.remove('shake');
        }, 500);
    }

    clearFieldError(input) {
        input.classList.remove('error');
        const errorDiv = input.parentNode.querySelector('.field-error');
        if (errorDiv) {
            errorDiv.remove();
        }
    }

    showError(message) {
        const existingError = document.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }

        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message fade-in';
        errorDiv.innerHTML = `
      <i class="fas fa-exclamation-triangle"></i>
      ${message}
    `;

        const form = document.querySelector('.auth-form');
        form.insertBefore(errorDiv, form.firstChild);

        setTimeout(() => {
            errorDiv.remove();
        }, 5000);
    }

    // OTP input handling
    setupOTPInputs() {
        const otpInput = document.querySelector('.otp-input-single');
        if (!otpInput)
            return;

        otpInput.addEventListener('input', (e) => {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 8)
                value = value.slice(0, 8);
            e.target.value = value;

            if (value.length === 8) {
                e.target.classList.add('filled');
            } else {
                e.target.classList.remove('filled');
            }
        });

        otpInput.addEventListener('paste', (e) => {
            e.preventDefault();
            const digits = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 8);
            otpInput.value = digits;

            if (digits.length === 8) {
                otpInput.classList.add('filled');
            }
        });

        otpInput.addEventListener('keypress', (e) => {
            if (!/\d/.test(e.key) && !['Backspace', 'Delete', 'Tab', 'Enter'].includes(e.key)) {
                e.preventDefault();
            }
        });
    }

    disableForm() {
        const form = document.querySelector('.auth-form');
        const inputs = form.querySelectorAll('input, button');

        inputs.forEach((input) => {
            input.disabled = true;
        });
    }

    // UI Animations
    setupAnimations() {
        const card = document.querySelector('.auth-card');
        if (card) {
            card.classList.add('fade-in');
        }

        const errorMessage = document.querySelector('.error-message');
        if (errorMessage) {
            errorMessage.scrollIntoView({behavior: 'smooth', block: 'center'});
        }
    }

    // Button loading state
    setButtonLoading(button, loading = true) {
        if (loading) {
            button.classList.add('btn-loading');
            button.disabled = true;
        } else {
            button.classList.remove('btn-loading');
            button.disabled = false;
    }
    }
}

// Init after DOM ready
document.addEventListener('DOMContentLoaded', () => {
    new AuthForm();
});

// Utility: Show notification
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 1rem 1.5rem;
    border-radius: 8px;
    color: white;
    font-weight: 500;
    z-index: 1000;
    animation: slideIn 0.3s ease;
  `;

    switch (type) {
        case 'success':
            notification.style.background = '#38a169';
            break;
        case 'error':
            notification.style.background = '#e53e3e';
            break;
        default:
            notification.style.background = '#3182ce';
    }

    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Animation keyframes for notification
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);
