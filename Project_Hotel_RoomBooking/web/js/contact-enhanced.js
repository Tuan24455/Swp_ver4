/**
 * Enhanced Contact Page JavaScript
 * Hotel Management System
 */

class ContactFormManager {
  constructor() {
    this.form = document.getElementById("contactForm");
    this.submitBtn = document.getElementById("submitBtn");
    this.messageTextarea = document.getElementById("message");
    this.charCount = document.getElementById("charCount");

    this.initEventListeners();
    this.initFormValidation();
    this.initAnimations();
  }

  initEventListeners() {
    if (this.form) {
      this.form.addEventListener("submit", (e) => this.handleSubmit(e));
    }

    if (this.messageTextarea && this.charCount) {
      this.messageTextarea.addEventListener("input", () => this.updateCharCount());
    }

    const inputs = this.form.querySelectorAll(".form-control, .form-check-input");
    inputs.forEach((input) => {
      input.addEventListener("blur", () => this.validateField(input));
      input.addEventListener("input", () => this.clearFieldError(input));
    });

    const resetBtn = this.form.querySelector('button[type="reset"]');
    if (resetBtn) {
      resetBtn.addEventListener("click", () => this.resetForm());
    }

    this.autoHideAlerts();
  }

  initFormValidation() {
    this.validationRules = {
      name: {
        required: true,
        minLength: 2,
        pattern: /^[a-zA-ZÀ-ỹ\s]+$/,
        message: "Tên phải có ít nhất 2 ký tự và chỉ chứa chữ cái",
      },
      email: {
        required: true,
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        message: "Email không hợp lệ",
      },
      phone: {
        pattern: /^[0-9]{10,11}$/,
        message: "Số điện thoại phải có 10-11 chữ số",
      },
      subject: {
        required: true,
        message: "Vui lòng chọn chủ đề",
      },
      message: {
        required: true,
        minLength: 10,
        maxLength: 500,
        message: "Tin nhắn phải có từ 10-500 ký tự",
      },
      privacy: {
        required: true,
        message: "Bạn phải đồng ý với chính sách bảo mật",
      },
    };
  }

  initAnimations() {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry, index) => {
          if (entry.isIntersecting) {
            setTimeout(() => {
              entry.target.classList.add("animate__animated", "animate__fadeInUp");
            }, index * 100);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.1 }
    );

    document.querySelectorAll(".form-group").forEach((group) => {
      observer.observe(group);
    });
  }

  validateField(field) {
    const fieldName = field.name;
    const value = field.type === "checkbox" ? field.checked : field.value.trim();
    const rules = this.validationRules[fieldName];

    if (!rules) return true;

    let isValid = true;
    let errorMessage = "";

    this.clearFieldError(field);

    if (rules.required && !value) {
      isValid = false;
      errorMessage = this.getFieldLabel(fieldName) + " là bắt buộc";
    }

    if (isValid && rules.pattern && value && !rules.pattern.test(field.value.trim())) {
      isValid = false;
      errorMessage = rules.message;
    }

    if (isValid && rules.minLength && value.length < rules.minLength) {
      isValid = false;
      errorMessage = rules.message;
    }

    if (isValid && rules.maxLength && value.length > rules.maxLength) {
      isValid = false;
      errorMessage = rules.message;
    }

    if (!isValid) {
      this.showFieldError(field, errorMessage);
    } else {
      this.showFieldSuccess(field);
    }

    return isValid;
  }

  showFieldError(field, message) {
    field.classList.remove("is-valid");
    field.classList.add("is-invalid");

    const feedback = field.parentNode.querySelector(".invalid-feedback");
    if (feedback) {
      feedback.textContent = message;
    }
  }

  showFieldSuccess(field) {
    field.classList.remove("is-invalid");
    field.classList.add("is-valid");
  }

  clearFieldError(field) {
    field.classList.remove("is-invalid", "is-valid");
  }

  getFieldLabel(fieldName) {
    const labels = {
      name: "Tên",
      email: "Email",
      phone: "Số điện thoại",
      subject: "Chủ đề",
      message: "Tin nhắn",
      privacy: "Chính sách bảo mật",
    };
    return labels[fieldName] || fieldName;
  }

  updateCharCount() {
    const length = this.messageTextarea.value.length;
    this.charCount.textContent = length;

    if (length > 450) {
      this.charCount.style.color = "#e74c3c";
    } else if (length > 400) {
      this.charCount.style.color = "#f39c12";
    } else {
      this.charCount.style.color = "#6c757d";
    }
  }

  handleSubmit(e) {
    e.preventDefault();

    const fields = this.form.querySelectorAll(".form-control, .form-check-input");
    let isFormValid = true;

    fields.forEach((field) => {
      if (!this.validateField(field)) {
        isFormValid = false;
      }
    });

    if (!isFormValid) {
      this.showNotification("Vui lòng kiểm tra lại thông tin", "error");
      const firstError = this.form.querySelector(".is-invalid");
      if (firstError) {
        firstError.scrollIntoView({ behavior: "smooth", block: "center" });
        firstError.focus();
      }
      return;
    }

    this.setLoadingState(true);

    // ✅ GỬI FORM ĐẾN SERVLET
    this.form.submit();
  }

  setLoadingState(loading) {
    if (loading) {
      this.submitBtn.disabled = true;
      this.submitBtn.classList.add("loading");
      this.submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
    } else {
      this.submitBtn.disabled = false;
      this.submitBtn.classList.remove("loading");
      this.submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn';
    }
  }

  resetForm() {
    this.form.reset();

    const fields = this.form.querySelectorAll(".form-control, .form-check-input");
    fields.forEach((field) => {
      this.clearFieldError(field);
    });

    if (this.charCount) {
      this.charCount.textContent = "0";
      this.charCount.style.color = "#6c757d";
    }

    this.showNotification("Form đã được đặt lại", "info");
  }

  showNotification(message, type = "info") {
    const notification = document.createElement("div");
    notification.className = `alert alert-${type === "error" ? "danger" : type === "success" ? "success" : "info"} animate__animated animate__fadeInDown`;
    notification.innerHTML = `
      <i class="fas fa-${type === "error" ? "exclamation-triangle" : type === "success" ? "check-circle" : "info-circle"} me-2"></i>
      ${message}
    `;

    const formBody = document.querySelector(".form-card-body");
    formBody.insertBefore(notification, formBody.firstChild);

    setTimeout(() => {
      notification.classList.add("animate__fadeOutUp");
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
      }, 500);
    }, 5000);
  }

  autoHideAlerts() {
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach((alert) => {
      setTimeout(() => {
        alert.classList.add("animate__fadeOutUp");
        setTimeout(() => {
          if (alert.parentNode) {
            alert.parentNode.removeChild(alert);
          }
        }, 500);
      }, 8000);
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  window.contactManager = new ContactFormManager();

  const contactDetails = document.querySelectorAll(".contact-details p");
  contactDetails.forEach((detail) => {
    const text = detail.textContent.trim();
    if (text.includes("@") || text.match(/[\d\s+\-]+/)) {
      detail.style.cursor = "pointer";
      detail.title = "Click để sao chép";
      detail.addEventListener("click", () => {
        const cleanText = text.split("\n")[0];
        navigator.clipboard.writeText(cleanText).then(() => {
          window.contactManager.showNotification("Đã sao chép vào clipboard", "success");
        });
      });
    }
  });

  document.body.classList.add("animate__animated", "animate__fadeIn");
});
