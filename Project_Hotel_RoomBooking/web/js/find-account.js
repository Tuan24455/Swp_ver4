/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global value */

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("findAccountForm");
  const keywordInput = document.getElementById("keyword");
  const submitBtn = document.getElementById("submitBtn");
  const errorMessage = document.getElementById("errorMessage");
  const errorText = document.getElementById("errorText");
  const inputIcon = document.getElementById("inputIcon");
  const btnText = submitBtn.querySelector(".btn-text");
  const loadingSpinner = submitBtn.querySelector(".loading-spinner");

  // Dynamic icon change based on input
  keywordInput.addEventListener("input", function () {
    const value = this.value.trim();

    // Clear previous errors when user starts typing
    hideError();

    // Change icon based on input type
    if (value.includes("@")) {
      inputIcon.className = "fas fa-envelope input-icon";
    } else if (value.length > 0) {
      inputIcon.className = "fas fa-user input-icon";
    } else {
      inputIcon.className = "fas fa-user input-icon";
    }
  });

  // Form validation and submission
  form.addEventListener("submit", (e) => {
    const keyword = keywordInput.value.trim();

    // Client-side validation
    if (!keyword) {
      e.preventDefault();
      showError("Vui lòng nhập email hoặc tên đăng nhập");
      keywordInput.focus();
      return;
    }

    // Basic email format validation if it looks like an email
    if (keyword.includes("@") && !isValidEmail(keyword)) {
      e.preventDefault();
      showError("Định dạng email không hợp lệ");
      keywordInput.focus();
      return;
    }

    // Show loading state
    setLoadingState(true);
  });

  // Email validation function
  function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  // Show error message
  function showError(message) {
    errorText.textContent = message;
    errorMessage.style.display = "flex";
    keywordInput.style.borderColor = "#dc2626";
    keywordInput.style.boxShadow = "0 0 0 3px rgba(220, 38, 38, 0.1)";
  }

  // Hide error message
  function hideError() {
    errorMessage.style.display = "none";
    keywordInput.style.borderColor = "#d1d5db";
    keywordInput.style.boxShadow = "none";
  }

  // Set loading state
  function setLoadingState(loading) {
    if (loading) {
      submitBtn.disabled = true;
      btnText.style.display = "none";
      loadingSpinner.style.display = "block";
      keywordInput.disabled = true;
    } else {
      submitBtn.disabled = false;
      btnText.style.display = "inline";
      loadingSpinner.style.display = "none";
      keywordInput.disabled = false;
    }
  }

  // Handle form response (if there's an error from server)
  const serverError = document.querySelector(".server-error");
  if (serverError) {
    // Reset loading state if there was a server error
    setLoadingState(false);

    // Focus back to input for better UX
    keywordInput.focus();
    keywordInput.select();
  }

  // Add enter key support
  keywordInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      form.dispatchEvent(new Event("submit"));
    }
  });

  // Auto-focus on input when page loads
  keywordInput.focus();

  // Add smooth transitions for better UX
  keywordInput.addEventListener("focus", function () {
    this.parentElement.style.transform = "scale(1.02)";
    this.parentElement.style.transition = "transform 0.2s ease";
  });

  keywordInput.addEventListener("blur", function () {
    this.parentElement.style.transform = "scale(1)";
  });
});

// Utility function to show success message (if needed)
function showSuccessMessage(message) {
  const existingSuccess = document.querySelector(".success-message");
  if (existingSuccess) {
    existingSuccess.remove();
  }

  const successDiv = document.createElement("div");
  successDiv.className = "success-message";
  successDiv.innerHTML = `
        <i class="fas fa-check-circle"></i>
        <span>${message}</span>
    `;

  const form = document.getElementById("findAccountForm");
  form.appendChild(successDiv);

  // Auto-hide after 5 seconds
  setTimeout(() => {
    successDiv.remove();
  }, 5000);
}
