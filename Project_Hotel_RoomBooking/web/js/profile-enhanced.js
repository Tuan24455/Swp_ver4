class ProfileManager {
  constructor() {
    this.isEditMode = false;
    this.originalFormData = {};

    this.initEventListeners();
    this.initFormValidation();
  }

  initEventListeners() {
    const profileForm = document.getElementById("profileForm");
    if (profileForm) {
      profileForm.addEventListener("submit", (e) => this.handleProfileSubmit(e));
    }

    const editBtn = document.getElementById("editToggleBtn");
    if (editBtn) {
      editBtn.addEventListener("click", () => this.toggleEditMode());
    }

    const cancelBtn = document.getElementById("cancelBtn");
    if (cancelBtn) {
      cancelBtn.addEventListener("click", () => this.cancelEdit());
    }
  }

  initFormValidation() {
    const inputs = document.querySelectorAll(".info-input");
    inputs.forEach((input) => {
      input.addEventListener("blur", () => this.validateField(input));
      input.addEventListener("input", () => this.clearFieldError(input));
    });
  }

  validateField(input) {
    const value = input.value.trim();
    const name = input.name;
    let isValid = true;
    let message = "";

    this.clearFieldError(input);

    if (name === "fullName") {
      if (!value) {
        isValid = false;
        message = "Họ tên không được để trống";
      } else if (value.length < 2) {
        isValid = false;
        message = "Họ tên phải có ít nhất 2 ký tự";
      }
    }

    if (name === "email") {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!value) {
        isValid = false;
        message = "Email không được để trống";
      } else if (!emailRegex.test(value)) {
        isValid = false;
        message = "Email không hợp lệ";
      }
    }

    if (name === "phone") {
      const phoneRegex = /^[0-9]{10,11}$/;
      if (value && !phoneRegex.test(value)) {
        isValid = false;
        message = "Số điện thoại không hợp lệ";
      }
    }

    if (name === "birth") {
      if (value) {
        const birthDate = new Date(value);
        const today = new Date();
        const age = today.getFullYear() - birthDate.getFullYear();
        if (age < 16 || age > 100) {
          isValid = false;
          message = "Tuổi phải từ 16 đến 100";
        }
      }
    }

    if (!isValid) {
      this.showFieldError(input, message);
    }

    return isValid;
  }

  showFieldError(input, message) {
    input.classList.add("is-invalid");
    const feedback = input.parentNode.querySelector(".invalid-feedback");
    if (feedback) {
      feedback.textContent = message;
    }
  }

  clearFieldError(input) {
    input.classList.remove("is-invalid", "is-valid");
  }

toggleEditMode() {
  this.isEditMode = true;
  const inputs = document.querySelectorAll(".info-input");

  inputs.forEach((input) => {
    if (input.tagName === "SELECT") {
      input.removeAttribute("disabled"); // Gỡ disabled khỏi select
    } else {
      input.removeAttribute("readonly"); // Gỡ readonly khỏi input/textarea
    }
  });

  document.getElementById("formActions").style.display = "flex";
  document.getElementById("editToggleBtn").style.display = "none";
}

cancelEdit() {
  this.isEditMode = false;
  const form = document.getElementById("profileForm");
  form.reset();

  const inputs = document.querySelectorAll(".info-input");

  inputs.forEach((input) => {
    if (input.tagName === "SELECT") {
      input.setAttribute("disabled", true);
    } else {
      input.setAttribute("readonly", true);
    }
    this.clearFieldError(input);
  });

  document.getElementById("formActions").style.display = "none";
  document.getElementById("editToggleBtn").style.display = "inline-block";
}

  showToast(message, type = "info") {
    alert(message); // tạm thời dùng alert đơn giản
  }

  handleProfileSubmit(e) {
    e.preventDefault();

    const inputs = document.querySelectorAll(".info-input:not([disabled]):not([readonly])");
    let isFormValid = true;

    inputs.forEach((input) => {
      if (!this.validateField(input)) {
        isFormValid = false;
      }
    });

    if (!isFormValid) {
      this.showToast("Vui lòng kiểm tra lại thông tin", "error");
      const firstError = document.querySelector(".is-invalid");
      if (firstError) firstError.focus();
      return;
    }

    // ✅ Gửi form thực sự
    e.target.submit();
  }
}

function showChangePasswordModal() {
    const modal = new bootstrap.Modal(document.getElementById("changePasswordModal"));
    modal.show();
}

function togglePassword(button) {
  const input = button.parentNode.querySelector("input");
  const icon = button.querySelector("i");

  if (input.type === "password") {
    input.type = "text";
    icon.classList.remove("fa-eye");
    icon.classList.add("fa-eye-slash");
  } else {
    input.type = "password";
    icon.classList.remove("fa-eye-slash");
    icon.classList.add("fa-eye");
  }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  window.profileManager = new ProfileManager();

  // Add loading animation
  document.body.classList.add("animate__animated", "animate__fadeIn")
});

// Handle page visibility change
document.addEventListener("visibilitychange", () => {
  if (document.hidden) {
    // Page is hidden - save draft if in edit mode
    if (window.profileManager && window.profileManager.isEditMode) {
      localStorage.setItem("profileDraft", JSON.stringify(window.profileManager.originalFormData));
    }
  }
});
