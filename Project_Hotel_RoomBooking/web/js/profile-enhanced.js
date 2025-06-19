/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * Enhanced Profile Page JavaScript
 * Hotel Management System
 */

// Import Bootstrap
const bootstrap = window.bootstrap;
class ProfileManager {
    constructor() {
        this.isEditMode = false;
        this.originalFormData = {};

        this.initEventListeners();
        this.initFormValidation();
        this.initTooltips();
    }

    initEventListeners() {
        const profileForm = document.getElementById("profileForm");
        if (profileForm) {
            profileForm.addEventListener("submit", (e) => this.handleProfileSubmit(e));
        }

        const changePasswordForm = document.getElementById("changePasswordForm");
        if (changePasswordForm) {
            changePasswordForm.addEventListener("submit", (e) => this.handlePasswordSubmit(e));
        }

        const avatarContainer = document.querySelector(".avatar-container");
        if (avatarContainer) {
            avatarContainer.addEventListener("click", () => {
                document.getElementById("profilePictureInput").click();
            });
        }

        document.addEventListener("keydown", (e) => this.handleKeyboardShortcuts(e));
    }

    initFormValidation() {
        const inputs = document.querySelectorAll(".info-input");
        inputs.forEach((input) => {
            input.addEventListener("blur", () => this.validateField(input));
            input.addEventListener("input", () => this.clearFieldError(input));
        });
    }

    initTooltips() {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl));
    }

    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        const editBtn = document.getElementById("editToggleBtn");
        const formActions = document.getElementById("formActions");
        const inputs = document.querySelectorAll(".info-input:not([disabled])");

        if (this.isEditMode) {
            this.storeOriginalFormData();

            editBtn.innerHTML = '<i class="fas fa-times me-2"></i>Hủy chỉnh sửa';
            editBtn.classList.remove("btn-edit");
            editBtn.classList.add("btn-cancel");

            formActions.style.display = "flex";

            inputs.forEach((input) => {
                input.removeAttribute("readonly");
                input.classList.add("animate__animated", "animate__pulse");
            });

            this.showToast("Chế độ chỉnh sửa đã được kích hoạt", "info");
        } else {
            this.cancelEdit();
        }
    }

    cancelEdit() {
        this.isEditMode = false;
        const editBtn = document.getElementById("editToggleBtn");
        const formActions = document.getElementById("formActions");
        const inputs = document.querySelectorAll(".info-input:not([disabled])");

        editBtn.innerHTML = '<i class="fas fa-pen me-2"></i>Chỉnh sửa';
        editBtn.classList.remove("btn-cancel");
        editBtn.classList.add("btn-edit");

        formActions.style.display = "none";

        inputs.forEach((input) => {
            input.setAttribute("readonly", true);
            input.classList.remove("animate__pulse");
        });

        this.restoreOriginalFormData();
        this.showToast("Đã hủy chỉnh sửa", "warning");
    }

    storeOriginalFormData() {
        const form = document.getElementById("profileForm");
        const formData = new FormData(form);
        this.originalFormData = {};

        for (const [key, value] of formData.entries()) {
            this.originalFormData[key] = value;
        }
    }

    restoreOriginalFormData() {
        Object.keys(this.originalFormData).forEach((key) => {
            const input = document.querySelector(`[name="${key}"]`);
            if (input) {
                input.value = this.originalFormData[key];
            }
        });
    }

    validateField(input) {
        const value = input.value.trim();
        const fieldName = input.name;
        let isValid = true;
        let errorMessage = "";

        this.clearFieldError(input);

        switch (fieldName) {
            case "fullName":
                if (!value) {
                    isValid = false;
                    errorMessage = "Họ tên không được để trống";
                } else if (value.length < 2) {
                    isValid = false;
                    errorMessage = "Họ tên phải có ít nhất 2 ký tự";
                }
                break;
            case "email":
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!value) {
                    isValid = false;
                    errorMessage = "Email không được để trống";
                } else if (!emailRegex.test(value)) {
                    isValid = false;
                    errorMessage = "Email không hợp lệ";
                }
                break;
            case "phone":
                const phoneRegex = /^[0-9]{10,11}$/;
                if (value && !phoneRegex.test(value)) {
                    isValid = false;
                    errorMessage = "Số điện thoại không hợp lệ";
                }
                break;
            case "birth":
                if (value) {
                    const birthDate = new Date(value);
                    const today = new Date();
                    const age = today.getFullYear() - birthDate.getFullYear();
                    if (age < 16 || age > 100) {
                        isValid = false;
                        errorMessage = "Tuổi phải từ 16 đến 100";
                    }
                }
                break;
        }

        if (!isValid) {
            this.showFieldError(input, errorMessage);
        }

        return isValid;
    }

    showFieldError(input, message) {
        input.classList.add("is-invalid");
        const existingError = input.parentNode.querySelector(".invalid-feedback");
        if (existingError) {
            existingError.remove();
        }
        const errorDiv = document.createElement("div");
        errorDiv.className = "invalid-feedback";
        errorDiv.textContent = message;
        input.parentNode.appendChild(errorDiv);
    }

    clearFieldError(input) {
        input.classList.remove("is-invalid");
        const errorDiv = input.parentNode.querySelector(".invalid-feedback");
        if (errorDiv) {
            errorDiv.remove();
        }
    }

    handleProfileSubmit(e) {
        e.preventDefault();
        const inputs = document.querySelectorAll(".info-input:not([readonly]):not([disabled])");
        let isFormValid = true;
        inputs.forEach((input) => {
            if (!this.validateField(input)) {
                isFormValid = false;
            }
        });

        if (!isFormValid) {
            this.showToast("Vui lòng kiểm tra lại thông tin", "error");
            return;
        }

        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
        submitBtn.disabled = true;

        setTimeout(() => {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
            this.toggleEditMode();
            this.showToast("Cập nhật thông tin thành công!", "success");
        }, 2000);
    }

    handlePasswordSubmit(e) {
        e.preventDefault();
        const currentPassword = e.target.currentPassword.value;
        const newPassword = e.target.newPassword.value;
        const confirmPassword = e.target.confirmPassword.value;

        if (!currentPassword || !newPassword || !confirmPassword) {
            this.showToast("Vui lòng điền đủ thông tin", "error");
            return;
        }

        if (newPassword.length < 6) {
            this.showToast("Mật khẩu mới phải có ít nhất 6 ký tự", "error");
            return;
        }

        if (newPassword !== confirmPassword) {
            this.showToast("Mật khẩu xác nhận không khớp", "error");
            return;
        }

        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        submitBtn.disabled = true;

        setTimeout(() => {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
            const modal = bootstrap.Modal.getInstance(document.getElementById("changePasswordModal"));
            modal.hide();
            e.target.reset();
            this.showToast("Đổi mật khẩu thành công!", "success");
        }, 2000);
    }

    handleKeyboardShortcuts(e) {
        if ((e.ctrlKey || e.metaKey) && e.key === "e") {
            e.preventDefault();
            this.toggleEditMode();
        }

        if (e.key === "Escape" && this.isEditMode) {
            this.cancelEdit();
        }
    }

    showToast(message, type = "info") {
        const toastId = type === "error" ? "errorToast" : "successToast";
        const messageId = type === "error" ? "errorToastMessage" : "toastMessage";
        const toast = document.getElementById(toastId);
        const messageElement = document.getElementById(messageId);
        if (toast && messageElement) {
            messageElement.textContent = message;
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
    }
    }
}

function toggleEditMode() {
    if (window.profileManager) {
        window.profileManager.toggleEditMode();
    }
}

function cancelEdit() {
    if (window.profileManager) {
        window.profileManager.cancelEdit();
    }
}

function previewImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const profileImage = document.getElementById("profileImage");
            profileImage.src = e.target.result;
            profileImage.classList.add("animate__animated", "animate__zoomIn");
            if (window.profileManager) {
                window.profileManager.showToast('Ảnh đã được chọn. Nhấn "Tải ảnh lên" để lưu.', "info");
            }
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function uploadProfilePicture() {
    const input = document.getElementById("profilePictureInput");
    if (!input.files || !input.files[0]) {
        if (window.profileManager) {
            window.profileManager.showToast("Vui lòng chọn ảnh trước", "error");
        }
        return;
    }
    if (window.profileManager) {
        window.profileManager.showToast("Đang tải ảnh lên...", "info");
    }
    setTimeout(() => {
        if (window.profileManager) {
            window.profileManager.showToast("Tải ảnh lên thành công!", "success");
        }
    }, 2000);
}

function removeProfilePicture() {
    if (confirm("Bạn có chắc chắn muốn xóa ảnh đại diện?")) {
        const profileImage = document.getElementById("profileImage");
        profileImage.src = "images/user/default_avatar.png";
        const input = document.getElementById("profilePictureInput");
        input.value = "";
        if (window.profileManager) {
            window.profileManager.showToast("Đã xóa ảnh đại diện", "success");
        }
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

document.addEventListener("DOMContentLoaded", () => {
    window.profileManager = new ProfileManager();
    document.body.classList.add("animate__animated", "animate__fadeIn");
});

document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
        if (window.profileManager && window.profileManager.isEditMode) {
            localStorage.setItem("profileDraft", JSON.stringify(window.profileManager.originalFormData));
        }
    }
});
