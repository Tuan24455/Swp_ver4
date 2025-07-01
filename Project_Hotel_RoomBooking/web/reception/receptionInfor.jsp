<%-- 
    Document   : receptionInfor
    Created on : Jun 29, 2025, 10:19:17 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="dashboard" />
            </jsp:include>

            <!-- Main Content -->
            <div class="profile-container">
                <div class="container-fluid py-4">

                    <!-- Page Header -->
                    <div class="profile-header animate__animated animate__fadeInDown">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="page-title-section">
                                    <h1 class="page-title">
                                        <i class="fas fa-user-circle me-3"></i>
                                        Thông tin cá nhân
                                    </h1>
                                    <p class="page-subtitle">Quản lý thông tin tài khoản và cài đặt cá nhân</p>
                                </div>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="user-status-badge">

                                    <i class="fas fa-shield-alt me-2"></i>
                                    <span class="status-text">${user.role}</span>
                                    <button type="button" class="btn btn-remove" onclick="window.profileManager.removeProfilePictureAndNotifyServer()">Xóa tài khoản
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <!-- Profile Picture Section -->
                        <div class="col-lg-4">
                            <div class="profile-card animate__animated animate__fadeInLeft">
                                <div class="profile-card-header">
                                    <h5 class="card-title">
                                        <i class="fas fa-camera me-2"></i>Ảnh đại diện
                                    </h5>
                                </div>
                                <div class="profile-card-body">
                                    <div class="avatar-section">
                                        <div class="avatar-container">
                                            <img
                                                src="${empty user.avatarUrl ? 'images/user/default_avatar.png' : user.avatarUrl}"
                                                class="profile-avatar"
                                                alt="Ảnh đại diện"
                                                id="profileImage"
                                                />
                                            <div class="avatar-overlay">
                                                <i class="fas fa-camera"></i>
                                            </div>
                                        </div>

                                        <div class="avatar-info">
                                            <h6 class="user-name">${user.fullName}</h6>
                                            <p class="user-email">${user.email}</p>
                                            <input type="hidden" id="currentUsername" value="${user.userName}">
                                            <input type="hidden" id="currentUserId" value="${user.id}">
                                        </div>
                                    </div>

                                    <div class="avatar-actions">
                                        <input
                                            type="file"
                                            class="d-none"
                                            id="profilePictureInput"
                                            accept="image/*"
                                            onchange="window.profileManager.handleAvatarFileSelect(this)" />
                                        <button type="button" class="btn btn-upload" onclick="document.getElementById('profilePictureInput').click()">
                                            <i class="fas fa-upload me-2"></i>Tải ảnh lên
                                        </button>
                                        <button type="button" class="btn btn-remove"">
                                            <i class="fas fa-trash me-2"></i>Xóa ảnh
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Stats -->
                            <div class="stats-card animate__animated animate__fadeInLeft" style="animation-delay: 0.2s">
                                <div class="stats-header">
                                    <h6><i class="fas fa-chart-line me-2"></i>Thống kê tài khoản</h6>
                                </div>
                                <div class="stats-grid">
                                    <div class="stat-item">
                                        <div class="stat-icon">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <div class="stat-info">
                                            <span class="stat-number">0</span>
                                            <span class="stat-label">Đặt phòng</span>
                                        </div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-icon">
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <div class="stat-info">
                                            <span class="stat-number">0</span>
                                            <span class="stat-label">Đánh giá</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Personal Information Section -->
                        <div class="col-lg-8">
                            <div class="info-card animate__animated animate__fadeInRight">
                                <div class="info-card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="card-title">
                                            <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                        </h5>
                                        <button type="button" class="btn btn-edit" id="editToggleBtn" onclick="window.profileManager.toggleEditMode()">
                                            <i class="fas fa-pen me-2"></i>Chỉnh sửa
                                        </button>
                                    </div>
                                </div>
                                <div class="info-card-body">
                                    <form id="profileForm" action="information" method="post">
                                        <div class="info-grid">
                                            <!-- Full Name -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-user me-2"></i>Họ và tên
                                                </label>
                                                <input type="text" class="form-control info-input" name="fullName" 
                                                       value="${user.fullName}" readonly />
                                                <div class="invalid-feedback"></div>
                                            </div>

                                            <!-- Username -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-at me-2"></i>Tên đăng nhập
                                                </label>
                                                <input type="text" class="form-control info-input" 
                                                       value="${user.userName}" readonly disabled />
                                            </div>

                                            <!-- Email -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-envelope me-2"></i>Email
                                                </label>
                                                <input type="email" class="form-control info-input" name="email"
                                                       value="${user.email}" readonly />
                                                <div class="invalid-feedback"></div>
                                                <%
                                                    String mess = (String) request.getAttribute("error");
                                                %>
                                                <i id="errorMessage" style="color: red"><%= (mess != null && !mess.isEmpty()) ? mess : "" %></i>
                                            </div>

                                            <!-- Phone -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-phone me-2"></i>Số điện thoại
                                                </label>
                                                <input type="text" class="form-control info-input" name="phone"
                                                       value="${user.phone}" readonly />
                                                <div class="invalid-feedback"></div>
                                            </div>

                                            <!-- Birth Date -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-birthday-cake me-2"></i>Ngày sinh
                                                </label>
                                                <fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd" var="birthFormatted" />
                                                <input type="date" class="form-control info-input" name="birth"
                                                       value="${birthFormatted}" readonly />
                                                <div class="invalid-feedback"></div>
                                            </div>

                                            <!-- Gender -->
                                            <div class="info-group">
                                                <label class="info-label">
                                                    <i class="fas fa-venus-mars me-2"></i>Giới tính
                                                </label>
                                                <select class="form-select info-input" name="gender" readonly>
                                                    <option value="Nam" ${user.gender == 'Nam' || user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                                    <option value="Nữ" ${user.gender == 'Nữ' || user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                                    <option value="Khác" ${user.gender == 'Khác' || user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                                </select>
                                                <div class="invalid-feedback"></div>
                                            </div>

                                            <!-- Address -->
                                            <div class="info-group full-width">
                                                <label class="info-label">
                                                    <i class="fas fa-map-marker-alt me-2"></i>Địa chỉ
                                                </label>
                                                <textarea class="form-control info-input" name="address" rows="2" readonly>${user.address}</textarea>
                                            </div>
                                        </div>

                                        <!-- Form Actions -->
                                        <div class="form-actions" id="formActions" style="display: none;">
                                            <button type="button" class="btn btn-cancel" id="cancelBtn">
                                                <i class="fas fa-times me-2"></i>Hủy
                                            </button>
                                            <button type="submit" class="btn btn-save">
                                                <i class="fas fa-save me-2"></i>Lưu thay đổi
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Security Section -->
                            <div class="security-card animate__animated animate__fadeInRight" style="animation-delay: 0.2s">
                                <div class="security-card-header">
                                    <h5 class="card-title">
                                        <i class="fas fa-shield-alt me-2"></i>Bảo mật tài khoản
                                    </h5>
                                </div>
                                <div class="security-card-body">
                                    <div class="security-items">
                                        <div class="security-item">
                                            <div class="security-info">
                                                <i class="fas fa-key security-icon"></i>
                                                <div>
                                                    <h6>Đổi mật khẩu</h6>
                                                    <p>Cập nhật mật khẩu để bảo vệ tài khoản</p>
                                                </div>
                                            </div>
                                            <button class="btn btn-outline-primary btn-sm" onclick="showChangePasswordModal()">
                                                <i class="fas fa-edit me-1"></i>Đổi
                                            </button>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Change Password Modal -->
            <div class="modal fade" id="changePasswordModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-key me-2"></i>Đổi mật khẩu
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form id="changePasswordForm" action="changePassword" method="post">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu hiện tại</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="currentPassword" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword(this)">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="newPassword" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword(this)">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Xác nhận mật khẩu mới</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" name="confirmPassword" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword(this)">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Toast Notifications -->
            <div class="toast-container position-fixed bottom-0 end-0 p-3">
                <div id="successToast" class="toast" role="alert">
                    <div class="toast-header">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <strong class="me-auto">Thành công</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body" id="toastMessage">
                        Cập nhật thông tin thành công!
                    </div>
                </div>

                <div id="errorToast" class="toast" role="alert">
                    <div class="toast-header">
                        <i class="fas fa-exclamation-circle text-danger me-2"></i>
                        <strong class="me-auto">Lỗi</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body" id="errorToastMessage">
                        Có lỗi xảy ra!
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="js/profile-enhanced.js"></script>
        </div>
    </body>
</html>
