class ProfileManager {
    constructor() {
        this.isEditMode = false;
        this.originalFormData = {};
        this.profileForm = document.getElementById("profileForm");

        this.contextPath = typeof CONTEXT_PATH !== 'undefined' ? CONTEXT_PATH : ''; 
        console.log("ProfileManager Initialized. Context Path:", this.contextPath);

        this.initEventListeners();
        this.initFormValidation();
    }

    initEventListeners() {
        if (this.profileForm) {
            this.profileForm.addEventListener("submit", (e) => this.handleProfileSubmit(e));
        }

        const editBtn = document.getElementById("editToggleBtn");
        if (editBtn) {
            editBtn.addEventListener("click", () => this.toggleEditMode());
        }

        const cancelBtn = document.getElementById("cancelBtn");
        if (cancelBtn) {
            cancelBtn.addEventListener("click", () => this.cancelEdit());
        }

        const avatarOverlay = document.querySelector(".avatar-overlay");
        if (avatarOverlay) {
            avatarOverlay.addEventListener("click", () => document.getElementById("profilePictureInput").click());
        }
        
        // Thêm event listener cho nút "Xóa ảnh" nếu chưa có
        const removeAvatarBtn = document.querySelector(".avatar-actions .btn-remove");
        if (removeAvatarBtn) {
            removeAvatarBtn.addEventListener("click", () => this.removeProfilePictureAndNotifyServer());
        }

        // Thêm event listener cho nút "Xóa tài khoản" nếu chưa có
        const deleteAccountBtn = document.querySelector(".user-status-badge .btn-remove");
        if (deleteAccountBtn) {
            // Tùy chỉnh: nếu nút này là để xóa tài khoản (soft delete), 
            // bạn cần một servlet khác, không phải deleteimg.
            // Nếu bạn muốn dùng nút này để xóa ảnh, hãy điều chỉnh cho phù hợp.
            // Hiện tại tôi giữ nguyên onclick trong JSP để gọi hàm tương ứng.
        }
    }

    initFormValidation() {
        const inputs = this.profileForm.querySelectorAll(".info-input");
        inputs.forEach((input) => {
            input.addEventListener("blur", () => this.validateField(input));
            input.addEventListener("input", () => this.clearFieldError(input));
        });
    }

    validateField(input) {
        this.clearFieldError(input);

        const value = input.value.trim();
        const name = input.name;
        let isValid = true;
        let message = "";

        if (name === "fullName") {
            if (!value) {
                isValid = false;
                message = "Họ tên không được để trống.";
            } else if (value.length < 2) {
                isValid = false;
                message = "Họ tên phải có ít nhất 2 ký tự.";
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
            const phoneRegex = /^[0-9]{10}$/;
            if (value && !phoneRegex.test(value)) {
                isValid = false;
                message = "Số điện thoại không hợp lệ (10 chữ số).";
            }
        } else if (name === "birth") {
            if (value) {
                const birthDate = new Date(value);
                const today = new Date();
                const age = today.getFullYear() - birthDate.getFullYear();
                if (age < 16 || age > 100) {
                    isValid = false;
                    message = "Tuổi phải từ 16 đến 100.";
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
        const feedback = input.parentNode.querySelector(".invalid-feedback");
        if (feedback) {
            feedback.textContent = "";
        }
    }

    toggleEditMode() {
        this.isEditMode = true;
        const inputs = this.profileForm.querySelectorAll(".info-input");

        const errorMessageElement = document.getElementById("errorMessage");
        if (errorMessageElement) {
            errorMessageElement.textContent = "";
        }
        inputs.forEach(input => {
            if (input.name) {
                this.originalFormData[input.name] = input.value;
            }
        });

        inputs.forEach((input) => {
            input.removeAttribute("readonly");
            input.removeAttribute("disabled");
            this.clearFieldError(input);
        });

        document.getElementById("formActions").style.display = "flex";
        document.getElementById("editToggleBtn").style.display = "none"; 
    }

    cancelEdit() {
        this.isEditMode = false;
        const inputs = this.profileForm.querySelectorAll(".info-input");

        inputs.forEach((input) => {
            if (input.name && this.originalFormData[input.name] !== undefined) {
                input.value = this.originalFormData[input.name];
            }

            if (input.name === "userName") {
                input.setAttribute("readonly", true);
                input.setAttribute("disabled", true);
            } else if (input.tagName === "SELECT") {
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
        console.log(`Toast (${type}):`, message); 
        const toastElementId = type === "success" ? "successToast" : "errorToast";
        const toastElement = document.getElementById(toastElementId);
        if (toastElement) {
            const toastBody = toastElement.querySelector(".toast-body");
            if (toastBody) {
                toastBody.textContent = message;
            }
            const toast = new bootstrap.Toast(toastElement);
            toast.show();
        } else {
            alert(message); 
        }
    }

    handleProfileSubmit(e) {
        e.preventDefault();
        console.log("Form submit triggered.");

        const inputsToValidate = this.profileForm.querySelectorAll(".info-input:not([disabled]):not([readonly])");
        let isFormValid = true;

        inputsToValidate.forEach((input) => {
            if (!this.validateField(input)) {
                isFormValid = false;
            }
        });

        if (!isFormValid) {
            this.showToast("Vui lòng kiểm tra lại thông tin.", "error");
            const firstError = this.profileForm.querySelector(".is-invalid");
            if (firstError) {
                firstError.focus();
            }
            return;
        }

        this.showToast("Thông tin đã được cập nhật thành công!", "success");
        // e.target.submit(); // Bỏ comment nếu bạn muốn submit form chính
    }

    async handleAvatarFileSelect(input) {
        const file = input.files[0];
        if (!file) {
            console.log("No file selected.");
            return;
        }
        console.log("File selected:", file.name, "Type:", file.type, "Size:", file.size);

        this.previewImage(input); 

        console.log("Attempting to upload profile picture to server...");
        await this.uploadProfilePictureToServer(file);
    }

    previewImage(input) {
        const preview = document.getElementById("profileImage");
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    async uploadProfilePictureToServer(file) {
        const formData = new FormData();
        formData.append('profilePicture', file);

        const username = document.getElementById('currentUsername').value;
        const userId = document.getElementById('currentUserId').value;

        // Lưu ý: User ID và Username được lấy từ session trên server, 
        // việc gửi qua query string chỉ để debug/log, không nên dùng cho logic chính
        // (đã bỏ trong code fetch bên dưới để đảm bảo an toàn).
        if (!username || !userId) {
            this.showToast('Không thể xác định thông tin người dùng. Vui lòng đăng nhập lại.', 'error');
            console.error("User info missing from hidden inputs.");
            return;
        }
        console.log("Uploading for User ID (from client-side hidden input):", userId, "Username:", username);

        try {
            const uploadUrl = `${this.contextPath}/upload`; // Sử dụng contextPath
            console.log("Sending upload request to URL:", uploadUrl);

            const response = await fetch(uploadUrl, {
                method: 'POST',
                body: formData,
            });

            console.log("Upload response status:", response.status, response.statusText);

            if (response.ok) { 
                const data = await response.json(); 
                this.showToast('Tải ảnh đại diện thành công!', 'success');
                if (data.newAvatarUrl) {
                    document.getElementById('profileImage').src = data.newAvatarUrl;
                    console.log("New avatar URL updated on client:", data.newAvatarUrl);
                }
                document.getElementById("profilePictureInput").value = "";
            } else {
                const errorText = await response.text(); 
                console.error("Server responded with error:", response.status, errorText);

                try {
                    const errorData = JSON.parse(errorText); 
                    this.showToast('Lỗi khi tải ảnh đại diện: ' + errorData.message, 'error');
                } catch (jsonError) {
                    this.showToast('Lỗi khi tải ảnh đại diện: ' + errorText.substring(0, Math.min(errorText.length, 100)) + '...', 'error'); 
                    console.error("Failed to parse error response as JSON:", jsonError);
                }
            }
        } catch (error) {
            console.error('Error uploading profile picture:', error);
            this.showToast('Đã xảy ra lỗi mạng hoặc hệ thống. Vui lòng thử lại.', 'error');
        }
    }

    // Hàm xóa ảnh đại diện và thông báo cho server
    async removeProfilePictureAndNotifyServer() {
        console.log("Attempting to remove profile picture and notify server...");
        
        // Lấy userId từ input hidden (chỉ để logging, server sẽ xác thực lại từ session)
        const userId = document.getElementById('currentUserId').value;
        if (!userId) {
            this.showToast('Không thể xác định người dùng để xóa ảnh.', 'error');
            console.error("User ID missing from client-side hidden input for deletion.");
            return;
        }
        console.log("Sending delete request for User ID (from client-side hidden input):", userId);

        try {
            // URL để gọi Servlet xóa ảnh
            const deleteUrl = `${this.contextPath}/deleteimg`; // Sử dụng contextPath
            console.log("Sending delete request to URL:", deleteUrl);

            const response = await fetch(deleteUrl, {
                method: 'POST' // Đảm bảo khớp với doPost trong Servlet
                // Không cần gửi userId trong body nếu server lấy từ session
            });

            console.log("Delete response status:", response.status, response.statusText);

            if (response.ok) { // Status 200-299
                const data = await response.json();
                this.showToast('Ảnh đại diện đã được xóa thành công!', 'success');
                // Cập nhật ảnh mặc định trên giao diện
                if (data.newAvatarUrl) {
                    document.getElementById("profileImage").src = data.newAvatarUrl; 
                    console.log("New avatar URL updated on client (after deletion):", data.newAvatarUrl);
                } else {
                    document.getElementById("profileImage").src = `${this.contextPath}/images/user/default_avatar.png`; // Fallback
                    console.log("No newAvatarUrl from server, set default locally.");
                }
                document.getElementById("profilePictureInput").value = ""; // Xóa file khỏi input
            } else {
                const errorText = await response.text(); 
                console.error("Server responded with error during deletion:", response.status, errorText);
                try {
                    const errorData = JSON.parse(errorText); 
                    this.showToast('Lỗi khi xóa ảnh đại diện: ' + errorData.message, 'error');
                } catch (jsonError) {
                    this.showToast('Lỗi khi xóa ảnh đại diện: ' + errorText.substring(0, Math.min(errorText.length, 100)) + '...', 'error'); 
                    console.error("Failed to parse error response as JSON during deletion:", jsonError);
                }
            }
        } catch (error) {
            console.error('Error deleting profile picture:', error);
            this.showToast('Đã xảy ra lỗi mạng hoặc hệ thống. Vui lòng thử lại.', 'error');
        }
    }
}

// Global functions (if needed outside the class context)
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
});
