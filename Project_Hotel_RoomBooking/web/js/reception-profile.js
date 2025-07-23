class ProfileManager {
    constructor() {
        this.isEditMode = false;
        this.originalFormData = {};
        this.init();
    }

    init() {
        this.cacheElements();
        this.bindEvents();
        this.setupValidation();
        this.animateSections();
    }

    cacheElements() {
        this.editBtn = document.getElementById("editToggleBtn");
        this.avatarUploadBtn = document.getElementById("avatarUploadBtn");
        this.avatarInput = document.getElementById("avatarInput");
        this.personalInfoForm = document.getElementById("personalInfoForm");
        this.passwordForm = document.getElementById("passwordForm");
    }

    bindEvents() {
        if (this.editBtn)
            this.editBtn.addEventListener("click", () => this.toggleEditMode());
        if (this.avatarUploadBtn && this.avatarInput) {
            this.avatarUploadBtn.addEventListener("click", () => this.avatarInput.click());
            this.avatarInput.addEventListener("change", (e) => this.handleAvatarUpload(e));
        }
        if (this.personalInfoForm) {
            this.personalInfoForm.addEventListener("submit", (e) => this.submitPersonalInfo(e));
        }
        if (this.passwordForm) {
            this.passwordForm.addEventListener("submit", (e) => this.submitPassword(e));
        }

        this.realTimeValidation();
    }

    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        const inputs = this.personalInfoForm.querySelectorAll("input:not([type='hidden']), select, textarea");

        if (this.isEditMode) {
            inputs.forEach(input => {
                if (input.name !== "userName") {
                    input.removeAttribute("readonly");
                    input.removeAttribute("disabled");
                }
            });
            this.storeOriginalFormData();
            this.editBtn.innerHTML = '<i class="fas fa-times"></i> Hủy';
            this.showActions();
        } else {
            inputs.forEach(input => {
                if (input.tagName.toLowerCase() === "select") {
                    input.setAttribute("disabled", "disabled");
                } else {
                    input.setAttribute("readonly", "readonly");
                }
            });
            this.restoreOriginalFormData();
            this.editBtn.innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa';
            this.hideActions();
        }
    }

    storeOriginalFormData() {
        const form = new FormData(this.personalInfoForm);
        for (let [key, value] of form.entries()) {
            this.originalFormData[key] = value;
        }
    }

    restoreOriginalFormData() {
        Object.entries(this.originalFormData).forEach(([name, value]) => {
            const input = this.personalInfoForm.querySelector(`[name="${name}"]`);
            if (input) input.value = value;
        });
    }

    showActions() {
        const actions = this.personalInfoForm.querySelector(".form-actions");
        if (actions) actions.style.display = "flex";
    }

    hideActions() {
        const actions = this.personalInfoForm.querySelector(".form-actions");
        if (actions) actions.style.display = "none";
    }

    async submitPersonalInfo(e) {
        e.preventDefault();
        if (!this.validatePersonalInfoForm()) return;

        const formData = new URLSearchParams(new FormData(this.personalInfoForm));

        try {
            this.setLoading(this.personalInfoForm, true);
            const response = await fetch(`${CONTEXT_PATH}/receptionInfor`, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: formData
            });

            if (response.ok) {
                this.showMessage("Cập nhật thành công!", "success");
                setTimeout(() => location.reload(), 1000);
            } else {
                this.showMessage("Cập nhật thất bại!", "error");
            }
        } catch (err) {
            console.error(err);
            this.showMessage("Lỗi khi gửi thông tin", "error");
        } finally {
            this.setLoading(this.personalInfoForm, false);
        }
    }

    validatePersonalInfoForm() {
        const inputs = this.personalInfoForm.querySelectorAll(
            'input:not([type="hidden"]):not([disabled]), select:not([disabled]), textarea:not([disabled])'
        );
        let isFormValid = true;

        inputs.forEach(input => {
            const isValid = this.validateField(input);
            if (!isValid) isFormValid = false;
        });

        return isFormValid;
    }

    validateField(input) {
        this.clearError(input);
        const value = input.value.trim();
        const name = input.name;
        let isValid = true;
        let message = "";

        if (name === "fullName") {
            const nameRegex = /^[\p{L} ]+$/u;
            if (!value) {
                isValid = false;
                message = "Họ tên không được để trống.";
            } else if (value.length < 2) {
                isValid = false;
                message = "Họ tên phải có ít nhất 2 ký tự.";
            } else if (!nameRegex.test(value)) {
                isValid = false;
                message = "Họ tên chỉ được chứa chữ cái và khoảng trắng.";
            }
        } else if (name === "email") {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!value) {
                isValid = false;
                message = "Email không được để trống.";
            } else if (!emailRegex.test(value)) {
                isValid = false;
                message = "Email không hợp lệ.";
            }
        } else if (name === "phone") {
            const phoneRegex = /^[0-9]{10,11}$/;
            if (value && !phoneRegex.test(value)) {
                isValid = false;
                message = "Số điện thoại không hợp lệ (10–11 chữ số).";
            }
        } else if (name === "birth") {
            if (value) {
                const birthDate = new Date(value);
                const today = new Date();
                if (isNaN(birthDate.getTime())) {
                    isValid = false;
                    message = "Ngày sinh không hợp lệ.";
                } else {
                    let age = today.getFullYear() - birthDate.getFullYear();
                    const m = today.getMonth() - birthDate.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                        age--;
                    }
                    if (age < 18 || age > 100) {
                        isValid = false;
                        message = "Tuổi phải từ 18 đến 100.";
                    }
                }
            }
        }

        if (!isValid) {
            this.showError(input, message);
        }

        return isValid;
    }

    realTimeValidation() {
        const inputs = this.personalInfoForm.querySelectorAll(
            'input:not([type="hidden"]):not([disabled]), select:not([disabled]), textarea:not([disabled])'
        );

        inputs.forEach(input => {
            input.addEventListener("blur", () => this.validateField(input));
        });
    }

    handleAvatarUpload(e) {
        const file = e.target.files[0];
        if (!file) return;

        const validTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"];
        if (!validTypes.includes(file.type)) {
            this.showMessage("Chỉ chấp nhận JPG, PNG, GIF", "error");
            return;
        }

        if (file.size > 5 * 1024 * 1024) {
            this.showMessage("Tệp quá lớn (tối đa 5MB)", "error");
            return;
        }

        const reader = new FileReader();
        reader.onload = () => {
            document.querySelector(".avatar-image").src = reader.result;
        };
        reader.readAsDataURL(file);

        this.uploadAvatar(file);
    }

    async uploadAvatar(file) {
        const formData = new FormData();
        formData.append("profilePicture", file);

        try {
            this.setLoading(this.avatarUploadBtn, true);
            const response = await fetch(`${CONTEXT_PATH}/upload`, {
                method: "POST",
                body: formData
            });

            const result = await response.json();
            if (result.success) {
                this.showMessage("Tải ảnh thành công!", "success");
            } else {
                this.showMessage(result.message || "Lỗi tải ảnh", "error");
            }
        } catch (err) {
            console.error(err);
            this.showMessage("Lỗi tải ảnh", "error");
        } finally {
            this.setLoading(this.avatarUploadBtn, false);
        }
    }

    validatePasswordForm() {
        const currentInput = document.getElementById("currentPassword");
        const newInput = document.getElementById("newPassword");
        const confirmInput = document.getElementById("confirmPassword");
        const realCurrentPassword = document.getElementById("currentUserPassword")?.value;

        let valid = true;

        if (currentInput.value !== realCurrentPassword) {
            this.showError(currentInput, "Mật khẩu hiện tại không đúng");
            valid = false;
        } else {
            this.clearError(currentInput);
        }

        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,16}$/;
        if (!passwordRegex.test(newInput.value)) {
            this.showError(newInput, "Mật khẩu phải dài 8–16 ký tự, gồm chữ hoa, thường và số");
            valid = false;
        } else {
            this.clearError(newInput);
        }

        if (confirmInput.value !== newInput.value) {
            this.showError(confirmInput, "Mật khẩu xác nhận không khớp");
            valid = false;
        } else {
            this.clearError(confirmInput);
        }

        return valid;
    }

    async submitPassword(e) {
        e.preventDefault();
        if (!this.validatePasswordForm()) return;

        const formData = new URLSearchParams(new FormData(this.passwordForm));
        try {
            this.setLoading(this.passwordForm, true);

            const response = await fetch(`${CONTEXT_PATH}/changeReceptionPassword`, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: formData
            });

            const result = await response.json();

            if (response.ok && result.success) {
                this.showMessage("Đổi mật khẩu thành công!", "success");
                this.passwordForm.reset();
            } else {
                this.showMessage(result.message || "Đổi mật khẩu thất bại", "error");
            }
        } catch (err) {
            console.error(err);
            this.showMessage("Đã xảy ra lỗi", "error");
        } finally {
            this.setLoading(this.passwordForm, false);
        }
    }

    showMessage(msg, type = "info") {
        const alert = document.createElement("div");
        alert.className = `alert alert-${type === "error" ? "danger" : type} alert-message fade-in`;
        alert.innerHTML = `
            <strong>${msg}</strong>
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        alert.style.cssText = "position: fixed; top: 20px; right: 20px; z-index: 9999;";
        document.body.appendChild(alert);
        setTimeout(() => alert.remove(), 5000);
    }

    showError(field, msg) {
        this.clearError(field);
        const error = document.createElement("div");
        error.className = "error-message";
        error.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${msg}`;
        if (!field.parentElement.querySelector(".error-message")) {
            field.parentElement.appendChild(error);
        }
        field.classList.add("shake");
        setTimeout(() => field.classList.remove("shake"), 500);
    }

    clearError(field) {
        const error = field.parentElement.querySelector(".error-message");
        if (error) error.remove();
    }

    setLoading(target, on) {
        if (!target) return;
        target.classList.toggle("loading", on);
        target.style.pointerEvents = on ? "none" : "auto";
    }

    setupValidation() {
        const fields = document.querySelectorAll("input[required], select[required], textarea[required]");
        fields.forEach(field => {
            const label = field.closest(".form-group")?.querySelector("label");
            if (label && !label.innerHTML.includes("*")) {
                const span = document.createElement("span");
                span.className = "required-indicator";
                span.innerHTML = " *";
                span.style.color = "#e74c3c";
                label.appendChild(span);
            }
        });
    }

    animateSections() {
        const sections = document.querySelectorAll(".profile-header, .avatar-section, .form-section");
        sections.forEach((section, i) => {
            setTimeout(() => section.classList.add("fade-in"), i * 200);
        });
    }
}

document.addEventListener("DOMContentLoaded", () => {
    window.profileManager = new ProfileManager();
});
