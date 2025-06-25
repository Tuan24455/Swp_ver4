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
        <nav
          class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
        >
          <div class="container-fluid">
            <div class="d-flex align-items-center gap-3">
              <span id="current-date" class="fw-semibold text-muted">Thứ Ba, 24 tháng 6, 2025</span>
              <span id="current-time" class="fw-semibold">16:56:28</span>
            </div>
          </div>
        </nav>

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
          </div>

          <div class="row g-4">
            <!-- Profile Information -->
            <div class="col-lg-8">
              <div class="card shadow-sm mb-4">
                <div class="card-header bg-white border-bottom py-3">
                  <h5 class="mb-0">
                    <i class="fas fa-user me-2"></i>Profile Information
                  </h5>
                </div>
                <div class="card-body">
                  <form id="profileForm">
                    <div class="row g-3">
                      <div class="col-md-6">
                        <label for="firstName" class="form-label">First Name *</label>
                        <input
                          type="text"
                          class="form-control"
                          id="firstName"
                          value="Admin"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="lastName" class="form-label">Last Name *</label>
                        <input
                          type="text"
                          class="form-control"
                          id="lastName"
                          value="User"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="email" class="form-label">Email Address *</label>
                        <input
                          type="email"
                          class="form-control"
                          id="email"
                          value="admin@hotel.com"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input
                          type="tel"
                          class="form-control"
                          id="phone"
                          value="+1 (555) 123-4567"
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="role" class="form-label">Role</label>
                        <input
                          type="text"
                          class="form-control"
                          id="role"
                          value="System Administrator"
                          readonly
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="department" class="form-label">Department</label>
                        <select class="form-select" id="department">
                          <option value="administration" selected>Administration</option>
                          <option value="management">Management</option>
                          <option value="operations">Operations</option>
                          <option value="it">IT Department</option>
                        </select>
                      </div>
                      <div class="col-12">
                        <label for="bio" class="form-label">Bio/Description</label>
                        <textarea
                          class="form-control"
                          id="bio"
                          rows="4"
                          placeholder="Tell us about yourself..."
                        >System Administrator with 5+ years of experience managing hotel operations and technology infrastructure.</textarea>
                      </div>
                    </div>
                    <div class="mt-3">
                      <button
                        type="button"
                        class="btn btn-primary"
                        onclick="updateProfile()"
                      >
                        <i class="fas fa-save me-2"></i>Update Profile
                      </button>
                      <button type="button" class="btn btn-outline-secondary">
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
                  <form id="passwordForm">
                    <div class="row g-3">
                      <div class="col-12">
                        <label for="currentPassword" class="form-label">Current Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="currentPassword"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="newPassword" class="form-label">New Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="newPassword"
                          required
                        />
                        <div class="form-text">
                          Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character.
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="confirmPassword" class="form-label">Confirm New Password *</label>
                        <input
                          type="password"
                          class="form-control"
                          id="confirmPassword"
                          required
                        />
                      </div>
                    </div>
                    <div class="mt-3">
                      <button
                        type="button"
                        class="btn btn-warning"
                        onclick="changePassword()"
                      >
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

  </body>
</html>