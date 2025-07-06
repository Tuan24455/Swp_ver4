<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Account Settings - Hotel Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link
      href="${pageContext.request.contextPath}/css/style.css"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="d-flex" id="wrapper">
      <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="account-settings" />
      </jsp:include>

      <!-- Main Content -->
      <div id="page-content-wrapper" class="flex-fill">
        <!-- Top Navigation -->
        <jsp:include page="includes/navbar.jsp" />

        <div class="container-fluid py-4">
          <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb custom-breadcrumb">
              <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
              <li class="breadcrumb-item active" aria-current="page">
                Account Settings
              </li>
            </ol>
          </nav>

          <!-- Page Header -->
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">Account Settings</h1>
            <div class="btn-group">
              <button
                class="btn btn-outline-success"
                onclick="saveAllSettings()"
              >
                <i class="fas fa-save me-2"></i>Save All Changes
              </button>
            </div>
          </div>          <div class="row g-4">
            <!-- Display Messages -->
            <div class="col-12">
              <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                  <i class="fas fa-check-circle me-2"></i>${successMessage}
                  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
              </c:if>
              <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                  <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
              </c:if>
            </div>

            <!-- Profile Information -->
            <div class="col-lg-8">
              <div class="card shadow-sm mb-4">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-user me-2"></i>Profile Information
                  </h5>
                </div>
                <div class="card-body">
                  <form id="profileForm" method="post" action="${pageContext.request.contextPath}/admin/account-settings">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="row g-3">
                      <div class="col-12">
                        <label for="fullName" class="form-label">Full Name *</label>
                        <input
                          type="text"
                          class="form-control"
                          id="fullName"
                          name="fullName"
                          value="${userData.fullName != null ? userData.fullName : ''}"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="email" class="form-label">Email Address *</label>
                        <input
                          type="email"
                          class="form-control"
                          id="email"
                          name="email"
                          value="${userData.email != null ? userData.email : ''}"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input
                          type="tel"
                          class="form-control"
                          id="phone"
                          name="phone"
                          value="${userData.phone != null ? userData.phone : ''}"
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="gender" class="form-label">Gender</label>
                        <select class="form-select" id="gender" name="gender">
                          <option value="">Select Gender</option>
                          <option value="Male" ${userData.gender == 'Male' ? 'selected' : ''}>Male</option>
                          <option value="Female" ${userData.gender == 'Female' ? 'selected' : ''}>Female</option>
                          <option value="Other" ${userData.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                      </div>
                      <div class="col-md-6">
                        <label for="birth" class="form-label">Date of Birth</label>
                        <input
                          type="date"
                          class="form-control"
                          id="birth"
                          name="birth"
                          value="<fmt:formatDate value='${userData.birth}' pattern='yyyy-MM-dd'/>"
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="role" class="form-label">Role</label>
                        <input
                          type="text"
                          class="form-control"
                          id="role"
                          value="${userData.role != null ? userData.role : ''}"
                          readonly
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="userName" class="form-label">Username</label>
                        <input
                          type="text"
                          class="form-control"
                          id="userName"
                          value="${userData.userName != null ? userData.userName : ''}"
                          readonly
                        />
                      </div>
                      <div class="col-12">
                        <label for="address" class="form-label">Address</label>
                        <textarea
                          class="form-control"
                          id="address"
                          name="address"
                          rows="3"
                          placeholder="Enter your address..."
                        >${userData.address != null ? userData.address : ''}</textarea>
                      </div>
                    </div>
                    <div class="mt-3">
                      <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Update Profile
                      </button>
                      <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                        <i class="fas fa-undo me-2"></i>Reset Changes
                      </button>
                    </div>
                  </form>
                </div>
              </div>

              <!-- Change Password -->
              <div class="card shadow-sm mb-4">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-lock me-2"></i>Change Password
                  </h5>
                </div>
                <div class="card-body">
                  <form id="passwordForm" method="post" action="${pageContext.request.contextPath}/admin/account-settings">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="row g-3">
                      <div class="col-12">
                        <label for="currentPassword" class="form-label">Current Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="currentPassword"
                          name="currentPassword"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="newPassword" class="form-label">New Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="newPassword"
                          name="newPassword"
                          required
                        />
                        <div class="form-text">
                          Password must be at least 6 characters long.
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="confirmPassword" class="form-label">Confirm New Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="confirmPassword"
                          name="confirmPassword"
                          required
                        />
                      </div>
                    </div>
                    <div class="mt-3">
                      <button type="submit" class="btn btn-warning">
                        <i class="fas fa-key me-2"></i>Change Password
                      </button>
                    </div>
                  </form>
                </div>
              </div>

              <!-- Security Settings -->
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-shield-alt me-2"></i>Security Settings
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row g-3">
                    <div class="col-12">
                      <div class="form-check form-switch">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="twoFactorAuth"
                          checked
                        />
                        <label class="form-check-label" for="twoFactorAuth">
                          <strong>Two-Factor Authentication</strong>
                          <br />
                          <small class="text-muted">Add an extra layer of security to your account</small>
                        </label>
                      </div>
                    </div>
                    <div class="col-12">
                      <div class="form-check form-switch">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="emailNotifications"
                          checked
                        />
                        <label class="form-check-label" for="emailNotifications">
                          <strong>Email Notifications</strong>
                          <br />
                          <small class="text-muted">Receive security alerts and login notifications</small>
                        </label>
                      </div>
                    </div>
                    <div class="col-12">
                      <div class="form-check form-switch">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="sessionTimeout"
                        />
                        <label class="form-check-label" for="sessionTimeout">
                          <strong>Auto Session Timeout</strong>
                          <br />
                          <small class="text-muted">Automatically log out after 30 minutes of inactivity</small>
                        </label>
                      </div>
                    </div>
                  </div>
                  <div class="mt-3">
                    <button
                      type="button"
                      class="btn btn-outline-info"
                      onclick="viewLoginHistory()"
                    >
                      <i class="fas fa-history me-2"></i>View Login History
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-warning"
                      onclick="revokeAllSessions()"
                    >
                      <i class="fas fa-sign-out-alt me-2"></i>Sign Out All Devices
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Profile Picture & Quick Info -->
            <div class="col-lg-4">
              <div class="card shadow-sm mb-4">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-camera me-2"></i>Profile Picture
                  </h5>
                </div>
                <div class="card-body text-center">
                  <div class="mb-3">
                    <img
                      src="https://via.placeholder.com/150x150"
                      class="rounded-circle img-fluid border"
                      alt="Profile Picture"
                      style="width: 150px; height: 150px; object-fit: cover"
                      id="profileImage"
                    />
                  </div>
                  <input
                    type="file"
                    class="form-control mb-3"
                    id="profilePictureInput"
                    accept="image/*"
                    onchange="previewImage(this)"
                  />
                  <button
                    type="button"
                    class="btn btn-outline-primary btn-sm"
                    onclick="uploadProfilePicture()"
                  >
                    <i class="fas fa-upload me-2"></i>Upload Photo
                  </button>
                  <button
                    type="button"
                    class="btn btn-outline-danger btn-sm"
                    onclick="removeProfilePicture()"
                  >
                    <i class="fas fa-trash me-2"></i>Remove
                  </button>
                </div>
              </div>

              <!-- Account Summary -->
              <div class="card shadow-sm mb-4">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-info-circle me-2"></i>Account Summary
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row g-2">
                    <div class="col-6">
                      <small class="text-muted">Account Created</small>
                      <div class="fw-bold">Jan 15, 2024</div>
                    </div>
                    <div class="col-6">
                      <small class="text-muted">Last Login</small>
                      <div class="fw-bold">Today, 09:30 AM</div>
                    </div>
                    <div class="col-6">
                      <small class="text-muted">Total Logins</small>
                      <div class="fw-bold">1,247</div>
                    </div>
                    <div class="col-6">
                      <small class="text-muted">Status</small>
                      <div class="fw-bold text-success">
                        <i class="fas fa-circle me-1" style="font-size: 8px"></i>Active
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-bolt me-2"></i>Quick Actions
                  </h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <button
                      type="button"
                      class="btn btn-outline-primary btn-sm"
                      onclick="exportAccountData()"
                    >
                      <i class="fas fa-download me-2"></i>Export Account Data
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-warning btn-sm"
                      onclick="resetPreferences()"
                    >
                      <i class="fas fa-refresh me-2"></i>Reset Preferences
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-danger btn-sm"
                      onclick="deactivateAccount()"
                    >
                      <i class="fas fa-user-times me-2"></i>Deactivate Account
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Toast -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
      <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
          <i class="fas fa-check-circle text-success me-2"></i>
          <strong class="me-auto">Success</strong>
          <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage">
          Settings updated successfully!
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Sidebar toggle functionality
      document
        .getElementById("menu-toggle")
        .addEventListener("click", function () {
          document
            .getElementById("sidebar-wrapper")
            .classList.toggle("toggled");
        });      // Functions
      function resetForm() {
        const profileForm = document.getElementById("profileForm");
        if (confirm("Are you sure you want to reset all changes?")) {
          profileForm.reset();
          showToast("Form reset successfully!");
        }
      }

      function validateProfileForm() {
        const fullName = document.getElementById("fullName").value;
        const email = document.getElementById("email").value;

        if (!fullName || !email) {
          alert("Please fill in all required fields (Full Name and Email).");
          return false;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
          alert("Please enter a valid email address.");
          return false;
        }

        return true;
      }

      function validatePasswordForm() {
        const currentPassword = document.getElementById("currentPassword").value;
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (!currentPassword || !newPassword || !confirmPassword) {
          alert("Please fill in all password fields.");
          return false;
        }

        if (newPassword !== confirmPassword) {
          alert("New passwords don't match.");
          return false;
        }

        if (newPassword.length < 6) {
          alert("Password must be at least 6 characters long.");
          return false;
        }

        return true;
      }

      // Add form validation before submission
      document.getElementById("profileForm").addEventListener("submit", function(event) {
        if (!validateProfileForm()) {
          event.preventDefault();
        }
      });

      document.getElementById("passwordForm").addEventListener("submit", function(event) {
        if (!validatePasswordForm()) {
          event.preventDefault();
        }
      });

      function saveAllSettings() {
        updateProfile();
        // Save security settings as well
        showToast("All settings saved successfully!");
      }

      function previewImage(input) {
        if (input.files && input.files[0]) {
          const reader = new FileReader();
          reader.onload = function (e) {
            document.getElementById("profileImage").src = e.target.result;
          };
          reader.readAsDataURL(input.files[0]);
        }
      }

      function uploadProfilePicture() {
        const fileInput = document.getElementById("profilePictureInput");
        if (!fileInput.files[0]) {
          alert("Please select an image first.");
          return;
        }
        
        // Here you would typically upload the file to your server
        showToast("Profile picture updated successfully!");
      }

      function removeProfilePicture() {
        if (confirm("Are you sure you want to remove your profile picture?")) {
          document.getElementById("profileImage").src = "https://via.placeholder.com/150x150";
          document.getElementById("profilePictureInput").value = "";
          showToast("Profile picture removed successfully!");
        }
      }

      function viewLoginHistory() {
        alert("Opening login history...");
        // Implementation for viewing login history
      }

      function revokeAllSessions() {
        if (confirm("Are you sure you want to sign out all devices? This will log you out from all active sessions.")) {
          showToast("All sessions have been revoked. You will be logged out shortly.");
          // Implementation for revoking all sessions
        }
      }

      function exportAccountData() {
        alert("Preparing account data export...");
        // Implementation for exporting account data
      }

      function resetPreferences() {
        if (confirm("Are you sure you want to reset all preferences to default?")) {
          showToast("Preferences reset to default!");
          // Implementation for resetting preferences
        }
      }

      function deactivateAccount() {
        if (confirm("Are you sure you want to deactivate your account? This action cannot be undone.")) {
          alert("Account deactivation requested. Please contact system administrator.");
          // Implementation for account deactivation
        }
      }

      function showToast(message) {
        document.getElementById("toastMessage").textContent = message;
        const toast = new bootstrap.Toast(document.getElementById("successToast"));
        toast.show();
      }
    </script>
  </body>
</html>