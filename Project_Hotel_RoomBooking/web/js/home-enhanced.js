/*
 * Enhanced Home Page JavaScript
 * Hotel Room Management System
 */

class RoomFilterManager {
    constructor() {
        this.filterModal = document.getElementById("filterModal");
        this.filterToggleBtn = document.querySelector(".filter-toggle-btn");
        this.filterCloseBtn = document.querySelector(".filter-close-btn");
        this.paginationForm = document.getElementById("paginationForm");

        this.initEventListeners();
        this.initAnimations();
    }

    initEventListeners() {
        if (this.filterToggleBtn) {
            this.filterToggleBtn.addEventListener("click", () => this.showFilter());
        }

        if (this.filterCloseBtn) {
            this.filterCloseBtn.addEventListener("click", () => this.hideFilter());
        }

        if (this.filterModal) {
            this.filterModal.addEventListener("click", (e) => {
                if (e.target === this.filterModal) {
                    this.hideFilter();
                }
            });
        }

        document.addEventListener("keydown", (e) => {
            if (e.key === "Escape" && this.filterModal.classList.contains("show")) {
                this.hideFilter();
            }
        });

        this.initFormValidation();
        this.initSmoothScrolling();
    }

    showFilter() {
        if (!this.filterModal)
            return;

        this.filterModal.style.display = "flex";
        this.filterModal.classList.add("show");
        document.body.style.overflow = "hidden";

        const modalContent = this.filterModal.querySelector(".filter-modal-content");
        modalContent.classList.remove("animate__fadeOutUp");
        modalContent.classList.add("animate__fadeInDown");

        this.filterToggleBtn?.classList.add("active");

        setTimeout(() => {
            const firstInput = this.filterModal.querySelector("input, select");
            firstInput?.focus();
        }, 300);
    }

    hideFilter() {
        if (!this.filterModal)
            return;

        const modalContent = this.filterModal.querySelector(".filter-modal-content");
        modalContent.classList.remove("animate__fadeInDown");
        modalContent.classList.add("animate__fadeOutUp");

        setTimeout(() => {
            this.filterModal.classList.remove("show");
            this.filterModal.style.display = "none";
            document.body.style.overflow = "auto";
        }, 400);

        this.filterToggleBtn?.classList.remove("active");
    }

    toggleFilter() {
        if (this.filterModal.classList.contains("show")) {
            this.hideFilter();
        } else {
            this.showFilter();
        }
    }

    initFormValidation() {
        const priceFromInput = document.querySelector('input[name="priceFrom"]');
        const priceToInput = document.querySelector('input[name="priceTo"]');
        const checkinInput = document.querySelector('input[name="checkin"]');
        const checkoutInput = document.querySelector('input[name="checkout"]');

        if (priceFromInput && priceToInput) {
            priceFromInput.addEventListener("change", () => {
                if (priceFromInput.value && priceToInput.value) {
                    if (Number(priceFromInput.value) > Number(priceToInput.value)) {
                        priceFromInput.value = "";
                        this.showToast("Giá từ không thể lớn hơn giá đến", "warning");
                    }
                }
            });

            priceToInput.addEventListener("change", () => {
                if (priceFromInput.value && priceToInput.value) {
                    if (Number(priceToInput.value) < Number(priceFromInput.value)) {
                        priceToInput.value = "";
                        this.showToast("Giá đến không thể nhỏ hơn giá từ", "warning");
                    }
                }
            });
        }

        if (checkinInput && checkoutInput) {
            // Đặt min cho checkin là hôm nay
            const today = new Date();
            checkinInput.min = today.toISOString().split('T')[0];

            checkinInput.addEventListener("change", () => {
                if (checkinInput.value) {
                    const checkinDate = new Date(checkinInput.value);

                    // Cộng 1 ngày cho checkout
                    const nextDay = new Date(checkinDate);
                    nextDay.setDate(checkinDate.getDate() + 1);
                    const minCheckout = nextDay.toISOString().split('T')[0];

                    checkoutInput.min = minCheckout;
                    // Gợi ý ngày checkout mặc định nếu chưa có
                    if (!checkoutInput.value) {
                        checkoutInput.value = minCheckout;
                    }

                    // Nếu checkout đang < min → reset
                    if (checkoutInput.value && new Date(checkoutInput.value) < nextDay) {
                        checkoutInput.value = "";
                        this.showToast("Ngày trả phòng phải ít nhất sau ngày nhận phòng 1 ngày", "warning");
                    }
                }
            });

            checkoutInput.addEventListener("change", () => {
                if (checkinInput.value && checkoutInput.value) {
                    const checkinDate = new Date(checkinInput.value);
                    const checkoutDate = new Date(checkoutInput.value);

                    // Kiểm tra nếu checkout <= checkin → không hợp lệ
                    if (checkoutDate <= checkinDate) {
                        checkoutInput.value = "";
                        this.showToast("Ngày trả phòng phải sau ngày nhận phòng ít nhất 1 ngày", "warning");
                    }
                }
            });
        }
    }

    initAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: "0px 0px -50px 0px"
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry, index) => {
                if (entry.isIntersecting) {
                    setTimeout(() => {
                        entry.target.classList.add("animate__animated", "animate__fadeInUp");
                    }, index * 100);
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll(".room-card").forEach((card) => {
            observer.observe(card);
        });
    }

    initSmoothScrolling() {
        const originalGoToPage = window.goToPage?.bind(window);
        window.goToPage = (pageNumber) => {
            window.scrollTo({top: 0, behavior: "smooth"});
            setTimeout(() => {
                if (originalGoToPage) {
                    originalGoToPage(pageNumber);
                } else {
                    this.goToPage(pageNumber);
                }
            }, 300);
        };
    }

    goToPage(pageNumber) {
        if (!this.paginationForm)
            return;
        const pageInput = document.getElementById("paginationPage");
        if (pageInput) {
            pageInput.value = pageNumber;
            this.paginationForm.submit();
        }
    }

    resetFilter() {
        if (confirm("Bạn có chắc chắn muốn xóa tất cả bộ lọc?")) {
            // Get the current path
            const currentPath = window.location.pathname;

            // Check if the current path is "home" or "dich-vu" (service)
            if (currentPath.includes("home")) {
                window.location.href = "home";
            } else if (currentPath.includes("service") || currentPath.includes("service")) { // Added "service" for flexibility
                window.location.href = "service"; // Or "service" depending on your actual path
            } else {
                // Default redirection if neither "home" nor "dich-vu" is found
                window.location.href = "home";
            }
        }
    }

    showToast(message, type = "info") {
        const toast = document.createElement("div");
        toast.className = `toast-notification toast-${type}`;
        toast.innerHTML = `
            <div class="toast-content">
                <i class="fas fa-${this.getToastIcon(type)} toast-icon"></i>
                <span class="toast-message">${message}</span>
            </div>
        `;

        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${this.getToastColor(type)};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            z-index: 10000;
            animation: slideInRight 0.3s ease;
        `;

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.animation = "slideOutRight 0.3s ease";
            setTimeout(() => {
                document.body.removeChild(toast);
            }, 300);
        }, 3000);
    }

    getToastIcon(type) {
        const icons = {
            success: "check-circle",
            warning: "exclamation-triangle",
            error: "times-circle",
            info: "info-circle"
        };
        return icons[type] || "info-circle";
    }

    getToastColor(type) {
        const colors = {
            success: "#27ae60",
            warning: "#f39c12",
            error: "#e74c3c",
            info: "#3498db"
        };
        return colors[type] || "#3498db";
    }
}

function toggleFilter() {
    if (window.roomFilterManager) {
        window.roomFilterManager.toggleFilter();
    }
}

function resetFilter() {
    if (window.roomFilterManager) {
        window.roomFilterManager.resetFilter();
    }
}

function goToPage(pageNumber) {
    if (window.roomFilterManager) {
        window.roomFilterManager.goToPage(pageNumber);
    }
}

document.addEventListener("DOMContentLoaded", () => {
    window.roomFilterManager = new RoomFilterManager();

    const style = document.createElement("style");
    style.textContent = `
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOutRight {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
        .toast-content {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .toast-icon {
            font-size: 1.2rem;
        }
    `;
    document.head.appendChild(style);
});

window.addEventListener("load", () => {
    const loader = document.querySelector(".page-loader");
    if (loader) {
        loader.style.opacity = "0";
        setTimeout(() => {
            loader.style.display = "none";
        }, 300);
    }
});