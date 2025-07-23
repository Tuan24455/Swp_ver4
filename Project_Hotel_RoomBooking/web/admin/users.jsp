<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản lý người dùng - Hệ thống quản lý khách sạn</title>

        <!-- CSS Libraries -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/css/admin-enhanced.css" rel="stylesheet" />
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Include Sidebar -->
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="users" />
            </jsp:include>

            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Include Top Navigation -->
                <jsp:include page="includes/navbar.jsp" />

                <div class="container-fluid py-4">
                    <!-- Enhanced Page Header -->
                    <div class="page-header animate__animated animate__fadeInDown">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="h2 mb-2">
                                    <i class="fas fa-users me-3"></i>Quản lý người dùng
                                </h1>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                                <i class="fas fa-home me-1"></i>Trang chủ
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active">Quản lý người dùng</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="btn-group">
                                <button class="btn btn-light btn-enhanced" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                    <i class="fas fa-plus me-2"></i>Thêm nhân viên mới
                                </button>
                                <button class="btn btn-outline-light btn-enhanced" onclick="exportUsers()">
                                    <i class="fas fa-download me-2"></i>Xuất Excel
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Message Display -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show animate__animated animate__fadeInDown" role="alert">
                            <i class="fas fa-${messageType == 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Enhanced Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="kpi-card animate__animated animate__fadeInUp" style="animation-delay: 0.1s">
                                <div class="kpi-icon total-users">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="kpi-content">
                                    <h6 class="kpi-label">Tổng người dùng</h6>
                                    <h2 class="kpi-value" data-count="${userStats.total}">${userStats.total}</h2>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="kpi-card animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
                                <div class="kpi-icon admins">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <div class="kpi-content">
                                    <h6 class="kpi-label">Quản trị viên</h6>
                                    <h2 class="kpi-value" data-count="${userStats.admin}">${userStats.admin}</h2>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="kpi-card animate__animated animate__fadeInUp" style="animation-delay: 0.3s">
                                <div class="kpi-icon reception">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <div class="kpi-content">
                                    <h6 class="kpi-label">Nhân viên lễ tân</h6>
                                    <h2 class="kpi-value" data-count="${userStats.reception}">${userStats.reception}</h2>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="kpi-card animate__animated animate__fadeInUp" style="animation-delay: 0.4s">
                                <div class="kpi-icon customers">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="kpi-content">
                                    <h6 class="kpi-label">Khách hàng</h6>
                                    <h2 class="kpi-value" data-count="${userStats.customer}">${userStats.customer}</h2>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Enhanced User Management Table -->
                    <div class="card table-card animate__animated animate__fadeInUp" style="animation-delay: 0.5s">
                        <div class="card-header">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list me-2"></i>Danh sách người dùng
                                        <c:if test="${not empty searchKeyword}">
                                            <small class="text-muted">- Kết quả tìm kiếm: "${searchKeyword}"</small>
                                        </c:if>
                                        <c:if test="${not empty selectedRole}">
                                            <small class="text-muted">- Lọc theo vai trò: "${selectedRole}"</small>
                                        </c:if>
                                    </h5>
                                </div>
                                <div class="col-auto">
                                    <div class="search-container">
                                        <form method="get" action="userList" class="d-flex align-items-center">
                                            <input type="hidden" name="action" value="search" />
                                            <div class="search-box">
                                                <input type="text" name="keyword" class="form-control" 
                                                       placeholder="🔍 Tìm kiếm theo tên, email, số điện thoại..." 
                                                       value="${searchKeyword}" 
                                                       autocomplete="off" />
                                                <button type="submit" class="search-btn" title="Tìm kiếm">
                                                    <i class="fas fa-search"></i>
                                                </button>
                                            </div>
                                        </form>
                                        <c:if test="${not empty searchKeyword}">
                                            <div class="search-stats">
                                                Tìm thấy <strong>${fn:length(userList)}</strong> kết quả cho "<span class="search-highlight">${searchKeyword}</span>"
                                                <a href="userList" class="ms-2 text-decoration-none">
                                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-0">
                            <!-- Enhanced Filter Section -->
                            <div class="filter-section">
                                <form method="get" action="userList" class="row g-3">
                                    <input type="hidden" name="action" value="filter" />
                                    <div class="col-md-3">
                                        <select class="form-select" name="role" onchange="this.form.submit()">
                                            <option value="">Tất cả vai trò</option>
                                            <option value="Admin" ${selectedRole == 'Admin' ? 'selected' : ''}>Quản trị viên</option>
                                            <option value="Reception" ${selectedRole == 'Reception' ? 'selected' : ''}>Nhân viên lễ tân</option>
                                            <option value="Customer" ${selectedRole == 'Customer' ? 'selected' : ''}>Khách hàng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="userList" class="btn btn-outline-primary w-100">
                                            <i class="fas fa-refresh me-2"></i>Làm mới
                                        </a>
                                    </div>
                                </form>
                            </div>

                            <!-- Enhanced Table -->
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" id="usersTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Avatar</th>
                                            <th>Tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Vai trò</th>
                                            <th>Giới tính</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty userList}">
                                                <c:forEach var="user" items="${userList}" varStatus="status">
                                                    <tr class="user-row">
                                                        <td><strong>#${user.id}</strong></td>
                                                        <td>
                                                            <div class="user-avatar">
                                                                <c:choose>
                                                                    <c:when test="${not empty user.avatarUrl}">
                                                                        <img src="${pageContext.request.contextPath}/${user.avatarUrl}" 
                                                                             alt="Avatar" 
                                                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/user/default_avatar.png';" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/images/user/default_avatar.png" alt="Default Avatar" />
                                                                    </c:otherwise>
                                                                </c:choose>

                                                                <div class="status-indicator ${user.deleted ? 'offline' : 'online'}"></div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="user-info">
                                                                <strong><c:out value="${user.fullName}" /></strong>
                                                                <br />
                                                                <small class="text-muted">@<c:out value="${user.userName}" /></small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:out value="${user.email}" />
                                                            <c:if test="${not empty user.email}">
                                                                <br><small class="text-muted">
                                                                    <i class="fas fa-envelope me-1"></i>Đã xác thực
                                                                </small>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty user.phone}">
                                                                    <c:out value="${user.phone}" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa cập nhật</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge role-${fn:toLowerCase(user.role)}">
                                                                <c:choose>
                                                                    <c:when test="${user.role == 'Admin'}">Quản trị viên</c:when>
                                                                    <c:when test="${user.role == 'Reception'}">Nhân viên lễ tân</c:when>
                                                                    <c:when test="${user.role == 'Customer'}">Khách hàng</c:when>
                                                                    <c:otherwise><c:out value="${user.role}" /></c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.gender == 'Nam'}">
                                                                    <i class="fas fa-mars text-primary me-1"></i>Nam
                                                                </c:when>
                                                                <c:when test="${user.gender == 'Nữ'}">
                                                                    <i class="fas fa-venus text-danger me-1"></i>Nữ
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-genderless text-muted me-1"></i>Khác
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td>
                                                            <div class="action-buttons">
                                                                <button class="btn btn-sm btn-outline-primary" 
                                                                        title="Xem chi tiết" 
                                                                        onclick="viewUser(${user.id})">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-warning" 
                                                                        title="Chỉnh sửa" 
                                                                        onclick="editUser(${user.id}, this)">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <c:if test="${user.role != 'Admin'}">
                                                                    <button class="btn btn-sm btn-outline-danger" 
                                                                            title="Xóa" 
                                                                            onclick="deleteUser(${user.id}, '${user.fullName}')">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="10" class="text-center py-4">
                                                        <div class="no-data">
                                                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                                            <h5 class="text-muted">Không có người dùng nào</h5>
                                                            <p class="text-muted">Hãy thêm nhân viên hoặc thay đổi bộ lọc</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Enhanced Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-section">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="pagination-info">
                                            <small class="text-muted">
                                                Hiển thị ${(currentPage - 1) * pageSize + 1} đến 
                                                ${currentPage * pageSize > totalUsers ? totalUsers : currentPage * pageSize} 
                                                trong tổng số ${totalUsers} người dùng
                                            </small>
                                        </div>
                                        <nav aria-label="Phân trang">
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="userList?page=${currentPage - 1}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </li>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="userList?page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="userList?page=${currentPage + 1}">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add User Modal -->
        <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addUserModalLabel">
                            <i class="fas fa-user-plus me-2"></i>Thêm người dùng mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="addUserForm" action="addUser" method="post" enctype="multipart/form-data" novalidate>
                        <div class="modal-body">
                            <div class="row g-4">
                                <!-- Avatar Upload Section -->
                                <div class="col-12">
                                    <div class="avatar-upload-section text-center">
                                        <div class="avatar-preview mb-3">
                                            <img id="avatarPreview" src="${pageContext.request.contextPath}/images/user/default_avatar.png"
                                                 alt="Avatar Preview" class="rounded-circle" width="120" height="120">
                                        </div>
                                        <div class="avatar-upload">
                                            <input type="file" id="avatarFile" name="avatar" accept="image/*" class="d-none" onchange="previewAvatar(this)">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('avatarFile').click()">
                                                <i class="fas fa-camera me-2"></i>Chọn ảnh đại diện
                                            </button>
                                            <small class="form-text text-muted d-block mt-2">
                                                Chấp nhận file: JPG, PNG, GIF. Kích thước tối đa: 2MB
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Personal Information -->
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">
                                        <i class="fas fa-user me-1"></i>Họ và tên <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="fullName" name="fullName">
                                    <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="userName" class="form-label">
                                        <i class="fas fa-at me-1"></i>Tên đăng nhập <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="userName" name="userName">
                                    <div class="invalid-feedback">Vui lòng nhập tên đăng nhập</div>
                                    <small class="form-text text-muted">Chỉ chứa chữ cái, số và dấu gạch dưới</small>
                                </div>

                                <div class="col-md-6">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-1"></i>Email <span class="text-danger">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email">
                                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="phone" class="form-label">
                                        <i class="fas fa-phone me-1"></i>Số điện thoại <span class="text-danger">*</span>
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                    <div class="invalid-feedback">Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số</div>
                                </div>

                                <!-- Password Section -->
                                <div class="col-md-6">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-1"></i>Mật khẩu <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="confirmPassword" class="form-label">
                                        <i class="fas fa-lock me-1"></i>Xác nhận mật khẩu <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Mật khẩu xác nhận không khớp</div>
                                </div>

                                <!-- Role and Gender -->
                                <div class="col-md-6">
                                    <label for="role" class="form-label">
                                        <i class="fas fa-user-tag me-1"></i>Vai trò <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="role" name="role">
                                        <option value="Reception">Nhân viên lễ tân</option>
                                        <option value="Customer">Khách hàng</option>
                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn vai trò</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="gender" class="form-label">
                                        <i class="fas fa-venus-mars me-1"></i>Giới tính
                                    </label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>

                                <!-- Birth Date -->
                                <div class="col-md-6">
                                    <label for="birth" class="form-label">
                                        <i class="fas fa-birthday-cake me-1"></i>Ngày sinh <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="birth" name="birth">
                                    <div class="invalid-feedback">Vui lòng chọn ngày sinh</div>
                                </div>

                                <!-- Address -->
                                <div class="col-12">
                                    <label for="address" class="form-label">
                                        <i class="fas fa-map-marker-alt me-1"></i>Địa chỉ
                                    </label>
                                    <textarea class="form-control" id="address" name="address" rows="3" placeholder="Nhập địa chỉ chi tiết..."></textarea>
                                </div>

                                <!-- Additional Options -->
                                <div class="col-12">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="sendWelcomeEmail" name="sendWelcomeEmail" checked>
                                        <label class="form-check-label" for="sendWelcomeEmail">
                                            <i class="fas fa-envelope me-1"></i>Gửi email chào mừng cho người dùng mới
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary" id="saveUserBtn">
                                <i class="fas fa-save me-2"></i>Lưu người dùng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit User Modal -->
        <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editUserModalLabel">
                            <i class="fas fa-user-edit me-2"></i>Chỉnh sửa thông tin người dùng
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="editUserForm" action="editUser" method="post" enctype="multipart/form-data" novalidate>
                        <input type="hidden" id="editUserId" name="id" value="">
                        <div class="modal-body">
                            <!-- User Status Header -->
                            <div class="user-status-header mb-4">
                                <div class="row align-items-center">
                                    <div class="col-auto">
                                        <div class="user-avatar-large">
                                            <img id="editAvatarPreview" src="/placeholder.svg" alt="User Avatar" class="rounded-circle" width="80" height="80">
                                            <div class="status-indicator online"></div>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <h4 id="editUserDisplayName" class="mb-1"></h4>
                                        <p class="text-muted mb-1" id="editUserUsername"></p>
                                        <div class="d-flex gap-2">
                                            <span id="editUserRole" class="badge"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4">
                                <!-- Avatar Upload Section -->
                                <div class="col-12">
                                    <div class="avatar-upload-section text-center">
                                        <div class="avatar-preview mb-3">
                                            <img id="editAvatarPreviewLarge" src="/placeholder.svg" alt="Avatar Preview" class="rounded-circle" width="120" height="120">
                                        </div>
                                        <div class="avatar-upload">
                                            <input type="file" id="editAvatarFile" name="avatar" accept="image/*" class="d-none" onchange="previewEditAvatar(this)">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('editAvatarFile').click()">
                                                <i class="fas fa-camera me-2"></i>Thay đổi ảnh đại diện
                                            </button>
                                            <small class="form-text text-muted d-block mt-2">
                                                Chấp nhận file: JPG, PNG, GIF. Kích thước tối đa: 2MB
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Personal Information -->
                                <div class="col-md-6">
                                    <h6 class="section-title">
                                        <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                    </h6>

                                    <div class="mb-3">
                                        <label for="editFullName" class="form-label">
                                            <i class="fas fa-user me-1"></i>Họ và tên <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="editFullName" name="fullName">
                                        <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editUserNameInput" class="form-label">
                                            <i class="fas fa-at me-1"></i>Tên đăng nhập <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="editUserNameInput" name="userName" readonly>
                                        <div class="invalid-feedback">Vui lòng nhập tên đăng nhập</div>
                                        <small class="form-text text-muted">Chỉ chứa chữ cái, số và dấu gạch dưới</small>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editBirth" class="form-label">
                                            <i class="fas fa-birthday-cake me-1"></i>Ngày sinh <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" class="form-control" id="editBirth" name="birth">
                                        <div class="invalid-feedback">Vui lòng chọn ngày sinh</div>
                                    </div>

                                    <!-- ✅ THÊM TRƯỜNG GIỚI TÍNH BỊ THIẾU -->
                                    <div class="mb-3">
                                        <label for="editGender" class="form-label">
                                            <i class="fas fa-venus-mars me-1"></i>Giới tính
                                        </label>
                                        <select class="form-select" id="editGender" name="gender">
                                            <option value="">Chọn giới tính</option>
                                            <option value="Nam">Nam</option>
                                            <option value="Nữ">Nữ</option>
                                            <option value="Khác">Khác</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="col-md-6">
                                    <h6 class="section-title">
                                        <i class="fas fa-address-book me-2"></i>Thông tin liên hệ
                                    </h6>

                                    <div class="mb-3">
                                        <label for="editEmail" class="form-label">
                                            <i class="fas fa-envelope me-1"></i>Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="editEmail" name="email">
                                        <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editPhone" class="form-label">
                                            <i class="fas fa-phone me-1"></i>Số điện thoại <span class="text-danger">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="editPhone" name="phone">
                                        <div class="invalid-feedback">Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editRole" class="form-label">
                                            <i class="fas fa-user-tag me-1"></i>Vai trò <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="editRole" name="role">
                                            <option value="">Chọn vai trò</option>
                                            <option value="Reception">Nhân viên lễ tân</option>
                                            <option value="Customer">Khách hàng</option>
                                            <option value="Admin">Quản trị viên</option>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn vai trò</div>
                                    </div>
                                </div>

                                <!-- Address -->
                                <div class="col-12">
                                    <label for="editAddress" class="form-label">
                                        <i class="fas fa-map-marker-alt me-1"></i>Địa chỉ
                                    </label>
                                    <textarea class="form-control" id="editAddress" name="address" rows="3" placeholder="Nhập địa chỉ chi tiết..."></textarea>
                                </div>

                                <!-- Password Section -->
                                <div class="col-12">
                                    <h6 class="section-title">
                                        <i class="fas fa-lock me-2"></i>Đổi mật khẩu (tùy chọn)
                                    </h6>
                                    <p class="text-muted small mb-3">Để trống nếu không muốn thay đổi mật khẩu</p>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="editPassword" class="form-label">
                                                    <i class="fas fa-lock me-1"></i>Mật khẩu mới
                                                </label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="editPassword" name="password" minlength="8">
                                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('editPassword')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự</div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="editConfirmPassword" class="form-label">
                                                    <i class="fas fa-lock me-1"></i>Xác nhận mật khẩu
                                                </label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="editConfirmPassword" name="confirmPassword">
                                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('editConfirmPassword')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="invalid-feedback">Mật khẩu xác nhận không khớp</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ✅ SỬA VỊ TRÍ MODAL FOOTER -->
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary" id="saveEditUserBtn">
                                <i class="fas fa-save me-2"></i>Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- View User Modal -->
        <div class="modal fade" id="viewUserModal" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewUserModalLabel">
                            <i class="fas fa-user me-2"></i>Chi tiết người dùng
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="userDetails">
                            <!-- User details will be loaded here -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                        const contextPath = '<%= request.getContextPath() %>';

                                                        // ---------------- Helper Functions ---------------- //
                                                        function isValidFullName(name) {
                                                            const trimmed = name.trim();
                                                            const nameRegex = /^[\p{L} ]+$/u; // Hỗ trợ Unicode (tên có dấu)
                                                            return trimmed.length >= 2 && nameRegex.test(trimmed);
                                                        }

                                                        function isValidUsername(value) {
                                                            return /^\w+$/.test(value) && value.length >= 8;
                                                        }

                                                        function isValidPassword(value) {
                                                            return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,16}$/.test(value);
                                                        }

                                                        function isValidEmail(value) {
                                                            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
                                                        }

                                                        function isValidPhone(value) {
                                                            return /^0\d{9}$/.test(value);
                                                        }

                                                        function isAtLeast18YearsOld(dateStr) {
                                                            if (!dateStr)
                                                                return false;
                                                            const birthDate = new Date(dateStr);
                                                            const today = new Date();
                                                            let age = today.getFullYear() - birthDate.getFullYear();
                                                            const m = today.getMonth() - birthDate.getMonth();
                                                            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                                                                age--;
                                                            }
                                                            return age >= 18;
                                                        }


// Validation logic
                                                        function getValidationResultAdd(input) {
                                                            const value = input.value.trim();
                                                            switch (input.id) {
                                                                case 'fullName':
                                                                    return [isValidFullName(value), 'Họ và tên phải dài hơn 2 ký tự, chỉ chứa chữ cái và khoảng trắng'];
                                                                case 'userName':
                                                                    if (!value) {
                                                                        return [isValidUserName(value), 'Tên đăng nhập phải lớn hơn hoặc bằng 8 ký tự'];
                                                                    }
                                                                    return [/^\w+$/.test(value) && value.length >= 8, 'Tên đăng nhập phải ≥ 8 ký tự, chỉ gồm chữ cái, số, gạch dưới'];
                                                                case 'email':
                                                                    if (!value) {
                                                                        return [false, 'Vui lòng nhập email'];
                                                                    }
                                                                    return [isValidEmail(value), 'Email không hợp lệ'];
                                                                case 'phone':
                                                                    if (!value) {
                                                                        return [false, 'Vui lòng nhập số điện thoại'];
                                                                    }
                                                                    return [isValidPhone(value), 'Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số'];
                                                                case 'password':
                                                                    if (!value) {
                                                                        return [false, 'Vui lòng nhập mật khẩu'];
                                                                    }
                                                                    return [isValidPassword(value), 'Mật khẩu 8–16 ký tự, gồm chữ hoa, chữ thường và số'];
                                                                case 'confirmPassword':
                                                                    const pw = document.getElementById('password').value;
                                                                    if (!value) {
                                                                        return [false, 'Vui lòng nhập xác nhận mật khẩu'];
                                                                    }
                                                                    return [value === pw, 'Mật khẩu xác nhận không khớp'];
                                                                default:
                                                                    return [true, ''];
                                                            }
                                                        }
                                                        // Submit validation cho addUserForm
                                                        document.getElementById('addUserForm').addEventListener('submit', function (e) {
                                                            e.preventDefault();

                                                            const form = this;
                                                            let isValid = true;

                                                            // Lấy tất cả các elements cần validate
                                                            const fullName = document.getElementById('fullName');
                                                            const userName = document.getElementById('userName');
                                                            const birth = document.getElementById('birth');
                                                            const email = document.getElementById('email');
                                                            const phone = document.getElementById('phone');
                                                            const role = document.getElementById('role');
                                                            const password = document.getElementById('password');
                                                            const confirmPassword = document.getElementById('confirmPassword');

                                                            const inputs = [fullName, userName, birth, email, phone, role, password, confirmPassword];

                                                            // Reset validation state
                                                            form.classList.remove('was-validated');

                                                            inputs.forEach(input => {
                                                                if (input) {
                                                                    input.classList.remove('is-valid', 'is-invalid');
                                                                    const container = input.closest('.col-md-6') || input.closest('.col-12') || input.closest('.input-group')?.parentNode;
                                                                    const feedback = container?.querySelector('.invalid-feedback');
                                                                    if (feedback)
                                                                        feedback.style.display = 'none';
                                                                }
                                                            });

                                                            // Hàm helper để validate từng field
                                                            const validateField = (field, condition, message) => {
                                                                const container = field.closest('.col-md-6') || field.closest('.col-12') || field.closest('.input-group')?.parentNode;
                                                                const feedback = container?.querySelector('.invalid-feedback');

                                                                if (!condition) {
                                                                    field.classList.add('is-invalid');
                                                                    if (feedback) {
                                                                        feedback.textContent = message;
                                                                        feedback.style.display = 'block';
                                                                    }
                                                                    isValid = false;
                                                                } else {
                                                                    field.classList.add('is-valid');
                                                                    if (feedback)
                                                                        feedback.style.display = 'none';
                                                                }
                                                            };

                                                            // Validate từng field
                                                            validateField(fullName, fullName.value.trim().length > 0, 'Vui lòng nhập họ và tên');

                                                            // Validate username
                                                            if (!userName.value.trim()) {
                                                                validateField(userName, false, 'Vui lòng nhập tên đăng nhập');
                                                            } else {
                                                                validateField(userName, isValidUsername(userName.value.trim()), 'Tên đăng nhập phải ≥ 8 ký tự, chỉ gồm chữ cái, số, gạch dưới');
                                                            }

                                                            // Validate birth date
                                                            if (!birth.value) {
                                                                validateField(birth, false, 'Vui lòng chọn ngày sinh');
                                                            } else {
                                                                validateField(birth, isAtLeast18YearsOld(birth.value), 'Người dùng phải đủ 18 tuổi');
                                                            }

                                                            // Validate email
                                                            if (!email.value.trim()) {
                                                                validateField(email, false, 'Vui lòng nhập email');
                                                            } else {
                                                                validateField(email, isValidEmail(email.value.trim()), 'Email không hợp lệ');
                                                            }

                                                            // Validate phone
                                                            if (!phone.value.trim()) {
                                                                validateField(phone, false, 'Vui lòng nhập số điện thoại');
                                                            } else {
                                                                validateField(phone, isValidPhone(phone.value.trim()), 'Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số');
                                                            }

                                                            // Validate role
                                                            validateField(role, role.value !== '', 'Vui lòng chọn vai trò');

                                                            // Validate password
                                                            if (!password.value) {
                                                                validateField(password, false, 'Vui lòng nhập mật khẩu');
                                                            } else {
                                                                validateField(password, isValidPassword(password.value), 'Mật khẩu phải có ít nhất 6 ký tự');
                                                            }

                                                            // Validate confirm password
                                                            if (!confirmPassword.value) {
                                                                validateField(confirmPassword, false, 'Vui lòng nhập xác nhận mật khẩu');
                                                            } else {
                                                                validateField(confirmPassword, password.value === confirmPassword.value, 'Mật khẩu xác nhận không khớp');
                                                            }

                                                            // Submit nếu hợp lệ
                                                            if (isValid) {
                                                                const saveBtn = document.getElementById('saveUserBtn');
                                                                saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
                                                                saveBtn.disabled = true;
                                                                form.submit();
                                                            } else {
                                                                // Focus vào field đầu tiên có lỗi
                                                                const firstInvalidField = form.querySelector('.is-invalid');
                                                                if (firstInvalidField) {
                                                                    firstInvalidField.focus();
                                                                    firstInvalidField.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                                }
                                                            }
                                                        });

// Real-time validation cho addUserForm
                                                        document.getElementById('addUserForm').addEventListener('input', function (e) {
                                                            const input = e.target;
                                                            if (!input || !input.id)
                                                                return;

                                                            const value = input.value.trim();
                                                            const container = input.closest('.col-md-6') || input.closest('.col-12') || input.closest('.input-group')?.parentNode;
                                                            const feedback = container?.querySelector('.invalid-feedback');

                                                            input.classList.remove('is-valid', 'is-invalid');

                                                            // Nếu chưa nhập gì thì không hiển thị validation
                                                            if (!value) {
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                                return;
                                                            }

                                                            const [valid, message] = getValidationResultAdd(input);

                                                            if (valid) {
                                                                input.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                input.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = message;
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }

                                                            // Đặc biệt cho confirm password - validate lại khi password thay đổi
                                                            if (input.id === 'password') {
                                                                const confirmPasswordInput = document.getElementById('confirmPassword');
                                                                if (confirmPasswordInput.value) {
                                                                    // Trigger validation cho confirm password
                                                                    const event = new Event('input', {bubbles: true});
                                                                    confirmPasswordInput.dispatchEvent(event);
                                                                }
                                                            }
                                                        });

// Validation cho role select trong addUserForm
                                                        document.getElementById('role').addEventListener('change', function () {
                                                            const container = this.closest('.col-md-6');
                                                            const feedback = container?.querySelector('.invalid-feedback');

                                                            this.classList.remove('is-valid', 'is-invalid');

                                                            if (this.value !== '') {
                                                                this.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Vui lòng chọn vai trò';
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }
                                                        });

// Validation cho gender select trong addUserForm (optional - không bắt buộc)
                                                        document.getElementById('gender').addEventListener('change', function () {
                                                            const container = this.closest('.col-md-6');
                                                            const feedback = container?.querySelector('.invalid-feedback');

                                                            this.classList.remove('is-valid', 'is-invalid');

                                                            if (this.value !== '') {
                                                                this.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            }
                                                            // Gender không bắt buộc nên không hiển thị lỗi
                                                        });
// Validation cho birth date trong addUserForm
                                                        document.getElementById('birth').addEventListener('change', function () {
                                                            const container = this.closest('.col-md-6');
                                                            const feedback = container?.querySelector('.invalid-feedback');

                                                            this.classList.remove('is-valid', 'is-invalid');

                                                            if (!this.value) {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Vui lòng chọn ngày sinh';
                                                                    feedback.style.display = 'block';
                                                                }
                                                                return;
                                                            }

                                                            if (isAtLeast18YearsOldAdd(this.value)) {
                                                                this.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Người dùng phải đủ 18 tuổi';
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }
                                                        });

// Reset form khi đóng addUserModal
                                                        document.getElementById('addUserModal').addEventListener('hidden.bs.modal', function () {
                                                            const form = document.getElementById('addUserForm');
                                                            form.reset();
                                                            form.classList.remove('was-validated');

                                                            // Reset tất cả validation states
                                                            const inputs = form.querySelectorAll('.form-control, .form-select');
                                                            inputs.forEach(input => {
                                                                input.classList.remove('is-valid', 'is-invalid');
                                                                const container = input.closest('.col-md-6') || input.closest('.col-12') || input.closest('.input-group')?.parentNode;
                                                                const feedback = container?.querySelector('.invalid-feedback');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            });

                                                            // Reset avatar preview
                                                            const avatarPreview = document.getElementById('avatarPreview');
                                                            if (avatarPreview) {
                                                                avatarPreview.src = contextPath + '/images/user/default_avatar.png';
                                                            }

                                                            // Reset button
                                                            const saveBtn = document.getElementById('saveUserBtn');
                                                            saveBtn.innerHTML = '<i class="fas fa-save me-2"></i>Lưu người dùng';
                                                            saveBtn.disabled = false;

                                                            // Clear file input
                                                            const avatarFile = document.getElementById('avatarFile');
                                                            if (avatarFile)
                                                                avatarFile.value = '';
                                                        });

// Function để kiểm tra tất cả element cần thiết cho addUserModal
                                                        function checkAddUserElements() {
                                                            const requiredElements = [
                                                                'addUserForm',
                                                                'addUserModal',
                                                                'fullName',
                                                                'userName',
                                                                'email',
                                                                'phone',
                                                                'password',
                                                                'confirmPassword',
                                                                'role',
                                                                'gender',
                                                                'birth',
                                                                'address',
                                                                'avatarPreview',
                                                                'avatarFile',
                                                                'saveUserBtn'
                                                            ];

                                                            console.log('🔍 Kiểm tra các element trong addUserModal:');
                                                            const missingElements = [];

                                                            requiredElements.forEach(id => {
                                                                const element = document.getElementById(id);
                                                                if (element) {
                                                                    console.log(`✅ ${id}: Tồn tại`);
                                                                } else {
                                                                    console.error(`❌ ${id}: KHÔNG TỒN TẠI`);
                                                                    missingElements.push(id);
                                                                }
                                                            });

                                                            if (missingElements.length > 0) {
                                                                console.error('🚨 Các element bị thiếu trong addUserModal:', missingElements);
                                                                return false;
                                                            }

                                                            console.log('✅ Tất cả element trong addUserModal đều tồn tại!');
                                                            return true;
                                                        }

// Gọi function kiểm tra khi trang load
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            checkAddUserElements();
                                                        });
// Avatar preview function
                                                        function previewAvatar(input) {
                                                            if (input.files && input.files[0]) {
                                                                const reader = new FileReader();
                                                                reader.onload = function (e) {
                                                                    document.getElementById('avatarPreview').src = e.target.result;
                                                                };
                                                                reader.readAsDataURL(input.files[0]);
                                                            }
                                                        }

                                                        // Toggle password visibility
                                                        function togglePassword(inputId) {
                                                            const input = document.getElementById(inputId);
                                                            const button = input.nextElementSibling;
                                                            const icon = button.querySelector('i');

                                                            if (input.type === 'password') {
                                                                input.type = 'text';
                                                                icon.classList.remove('fa-eye');
                                                                icon.classList.add('fa-eye-slash');
                                                            } else {
                                                                input.type = 'password';
                                                                icon.classList.remove('fa-eye-slash');
                                                                icon.classList.add('fa-eye');
                                                            }
                                                        }

                                                        // User management functions
// Hàm viewUser gốc của bạn
                                                        function viewUser(userId) {
                                                            const contextPath = '<%= request.getContextPath() %>';

                                                            fetch(contextPath + '/userList?action=getUserDetails&id=' + userId)
                                                                    .then(response => {
                                                                        if (!response.ok) {
                                                                            return response.json().then(errorData => {
                                                                                throw new Error(errorData.error || `Lỗi HTTP: ${response.status}`);
                                                                            });
                                                                        }
                                                                        return response.json();
                                                                    })
                                                                    .then(userData => {
                                                                        console.log("📦 Dữ liệu JSON nhận được (biến userData):", userData);
                                                                        // ... (các console.log kiểm tra dữ liệu khác nếu cần)

                                                                        const avatarUrl = (userData.avatarUrl && userData.avatarUrl !== "false")
                                                                                ? contextPath + '/' + userData.avatarUrl // Sử dụng nối chuỗi
                                                                                : contextPath + '/images/user/default-avatar.png';

                                                                        // ***** ÁP DỤNG PHƯƠNG PHÁP NỐI CHUỖI ĐÃ THÀNH CÔNG *****
                                                                        const birthDate = userData.birth
                                                                                ? new Date(userData.birth).toLocaleDateString('vi-VN', {
                                                                            weekday: 'long',
                                                                            year: 'numeric',
                                                                            month: 'long',
                                                                            day: 'numeric'
                                                                        })
                                                                                : 'Chưa cập nhật';
                                                                        const userDetailsHtml =
                                                                                '<div class="row">' +
                                                                                '    <div class="col-md-4 text-center">' +
                                                                                '<img src="' + avatarUrl + '" onerror="this.src=\'' + contextPath + '/images/user/default_avatar.png\'" class="rounded-circle mb-3" alt="User Avatar" width="100" height="100">' +
                                                                                '        <h5>' + (userData.fullName || 'Không có tên') + '</h5>' +
                                                                                '        <p class="text-muted">@' + (userData.userName || '') + '</p>' +
                                                                                '    </div>' +
                                                                                '    <div class="col-md-8">' +
                                                                                '        <table class="table table-borderless">' +
                                                                                '            <tr><td><strong>ID:</strong></td><td>#' + (userData.id || 'N/A') + '</td></tr>' +
                                                                                '            <tr><td><strong>Ngày sinh:</strong></td><td>' + birthDate + '</td></tr>' +
                                                                                '            <tr><td><strong>Email:</strong></td><td>' + (userData.email || 'Chưa cập nhật') + '</td></tr>' +
                                                                                '            <tr><td><strong>Số điện thoại:</strong></td><td>' + (userData.phone || 'Chưa cập nhật') + '</td></tr>' +
                                                                                '            <tr><td><strong>Vai trò:</strong></td><td>' + (userData.role || 'Không xác định') + '</td></tr>' +
                                                                                '            <tr><td><strong>Giới tính:</strong></td><td>' + (userData.gender || 'Chưa cập nhật') + '</td></tr>' +
                                                                                '            <tr><td><strong>Địa chỉ:</strong></td><td>' + (userData.address || 'Chưa cập nhật') + '</td></tr>' +
                                                                                '        </table>' +
                                                                                '    </div>' +
                                                                                '</div>';

                                                                        console.log("📝 Chuỗi HTML được tạo ra (nối chuỗi):", userDetailsHtml);

                                                                        document.getElementById('userDetails').innerHTML = userDetailsHtml;
                                                                        new bootstrap.Modal(document.getElementById('viewUserModal')).show();
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('❌ Error khi lấy dữ liệu:', error);
                                                                        alert(`Lỗi: ${error.message || 'Không thể tải thông tin người dùng.'}`);
                                                                    });
                                                        }

                                                        function deleteUser(userId, userName) {
                                                            if (confirm(`Bạn có chắc chắn muốn xóa người dùng "${userName}"? Hành động này không thể hoàn tác.`)) {
                                                                window.location.href = 'userList?action=delete&id=' + userId;
                                                            }
                                                        }

                                                        // Auto-hide alerts
                                                        setTimeout(() => {
                                                            const alerts = document.querySelectorAll('.alert');
                                                            alerts.forEach(alert => {
                                                                const bsAlert = new bootstrap.Alert(alert);
                                                                bsAlert.close();
                                                            });
                                                        }, 5000);


                                                        function editUser(userId, button) {
                                                            const contextPath = '<%= request.getContextPath() %>';
                                                            console.log('🧪 userId =', userId);

                                                            const editBtn = button;
                                                            const originalContent = editBtn.innerHTML;
                                                            editBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                                                            editBtn.disabled = true;

                                                            fetch(contextPath + '/userList?action=getUserDetails&id=' + userId)
                                                                    .then(response => {
                                                                        if (!response.ok) {
                                                                            return response.json().then(err => {
                                                                                throw new Error(err.error || 'Lỗi khi lấy dữ liệu người dùng');
                                                                            });
                                                                        }
                                                                        return response.json();
                                                                    })
                                                                    .then(user => {
                                                                        console.log('📦 Dữ liệu user nhận được:', user);

                                                                        // ✅ Hàm helper để set value an toàn
                                                                        const setValueSafely = (elementId, value) => {
                                                                            const element = document.getElementById(elementId);
                                                                            if (element) {
                                                                                element.value = value || '';
                                                                                console.log(`✅ Set ${elementId} = ${value}`);
                                                                            } else {
                                                                                console.error(`❌ Element '${elementId}' không tồn tại!`);
                                                                            }
                                                                        };

                                                                        const setTextSafely = (elementId, text) => {
                                                                            const element = document.getElementById(elementId);
                                                                            if (element) {
                                                                                element.textContent = text || '';
                                                                                console.log(`✅ Set text ${elementId} = ${text}`);
                                                                            } else {
                                                                                console.error(`❌ Element '${elementId}' không tồn tại!`);
                                                                            }
                                                                        };

                                                                        const setSrcSafely = (elementId, src) => {
                                                                            const element = document.getElementById(elementId);
                                                                            if (element) {
                                                                                element.src = src || '';
                                                                                console.log(`✅ Set src ${elementId} = ${src}`);
                                                                            } else {
                                                                                console.error(`❌ Element '${elementId}' không tồn tại!`);
                                                                            }
                                                                        };

                                                                        // Điền dữ liệu vào form với kiểm tra an toàn
                                                                        setValueSafely('editUserId', user.id);
                                                                        setValueSafely('editFullName', user.fullName);
                                                                        setValueSafely('editUserNameInput', user.userName);
                                                                        setValueSafely('editEmail', user.email);
                                                                        setValueSafely('editPhone', user.phone);
                                                                        setValueSafely('editAddress', user.address);
                                                                        setValueSafely('editRole', user.role);
                                                                        setValueSafely('editGender', user.gender);

                                                                        // Xử lý ngày sinh
                                                                        if (user.birth) {
                                                                            try {
                                                                                const birthDate = new Date(user.birth);
                                                                                const formattedDate = birthDate.toISOString().split('T')[0];
                                                                                setValueSafely('editBirth', formattedDate);
                                                                            } catch (error) {
                                                                                console.error('❌ Lỗi format ngày sinh:', error);
                                                                                setValueSafely('editBirth', '');
                                                                            }
                                                                        } else {
                                                                            setValueSafely('editBirth', '');
                                                                        }

                                                                        // Avatar
                                                                        const avatarUrl = user.avatarUrl && user.avatarUrl !== 'false'
                                                                                ? contextPath + '/' + user.avatarUrl
                                                                                : contextPath + '/images/user/default_avatar.png';

                                                                        // Set avatar với kiểm tra
                                                                        setSrcSafely('editAvatarPreview', avatarUrl);
                                                                        setSrcSafely('editAvatarPreviewLarge', avatarUrl);

                                                                        // Fallback khi ảnh lỗi
                                                                        const avatarImg = document.getElementById('editAvatarPreview');
                                                                        const avatarImgLarge = document.getElementById('editAvatarPreviewLarge');

                                                                        if (avatarImg) {
                                                                            avatarImg.onerror = function () {
                                                                                this.onerror = null;
                                                                                this.src = contextPath + '/images/user/default_avatar.png';
                                                                            };
                                                                        }

                                                                        if (avatarImgLarge) {
                                                                            avatarImgLarge.onerror = function () {
                                                                                this.onerror = null;
                                                                                this.src = contextPath + '/images/user/default_avatar.png';
                                                                            };
                                                                        }

                                                                        // Header hiển thị
                                                                        setTextSafely('editUserDisplayName', user.fullName || 'Không có tên');
                                                                        setTextSafely('editUserUsername', '@' + (user.userName || ''));

                                                                        // Role badge
                                                                        const roleBadge = document.getElementById('editUserRole');
                                                                        if (roleBadge) {
                                                                            roleBadge.className = 'badge role-' + (user.role || '').toLowerCase();
                                                                            roleBadge.textContent = getRoleDisplayName(user.role || '');
                                                                        } else {
                                                                            console.error('❌ Element editUserRole không tồn tại!');
                                                                        }

                                                                        // ✅ Reset trạng thái validate
                                                                        const form = document.getElementById('editUserForm');
                                                                        if (form) {
                                                                            form.classList.remove('was-validated');

                                                                            form.querySelectorAll('.form-control, .form-select').forEach(input => {
                                                                                input.classList.remove('is-invalid', 'is-valid');
                                                                                // Reset custom validity
                                                                                input.setCustomValidity('');

                                                                                // Ẩn thông báo lỗi
                                                                                const container = input.closest('.mb-3') || input.closest('.input-group')?.parentNode;
                                                                                const feedbackElement = container?.querySelector('.invalid-feedback');
                                                                                if (feedbackElement) {
                                                                                    feedbackElement.style.display = 'none';
                                                                                }
                                                                            });

                                                                            // ✅ Hiện modal
                                                                            const modal = document.getElementById('editUserModal');
                                                                            if (modal) {
                                                                                new bootstrap.Modal(modal).show();
                                                                            } else {
                                                                                console.error('❌ Modal editUserModal không tồn tại!');
                                                                            }
                                                                        } else {
                                                                            console.error('❌ Form editUserForm không tồn tại!');
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('❌ Lỗi:', error);
                                                                        alert(error.message || 'Không thể tải thông tin người dùng.');
                                                                    })
                                                                    .finally(() => {
                                                                        editBtn.innerHTML = originalContent;
                                                                        editBtn.disabled = false;
                                                                    });
                                                        }
                                                        // Function để kiểm tra tất cả element cần thiết
                                                        function checkEditUserElements() {
                                                            const requiredElements = [
                                                                'editUserId',
                                                                'editFullName',
                                                                'editUserNameInput',
                                                                'editEmail',
                                                                'editPhone',
                                                                'editAddress',
                                                                'editRole',
                                                                'editGender',
                                                                'editBirth',
                                                                'editAvatarPreview',
                                                                'editAvatarPreviewLarge',
                                                                'editUserDisplayName',
                                                                'editUserUsername',
                                                                'editUserRole',
                                                                'editUserForm',
                                                                'editUserModal'
                                                            ];

                                                            console.log('🔍 Kiểm tra các element trong editUserModal:');
                                                            const missingElements = [];

                                                            requiredElements.forEach(id => {
                                                                const element = document.getElementById(id);
                                                                if (element) {
                                                                    console.log(`✅ ${id}: Tồn tại`);
                                                                } else {
                                                                    console.error(`❌ ${id}: KHÔNG TỒN TẠI`);
                                                                    missingElements.push(id);
                                                                }
                                                            });

                                                            if (missingElements.length > 0) {
                                                                console.error('🚨 Các element bị thiếu:', missingElements);
                                                                alert('Lỗi: Một số element trong form không tồn tại. Kiểm tra console để biết chi tiết.');
                                                                return false;
                                                            }

                                                            return true;
                                                        }

// Gọi function này khi trang load để kiểm tra
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            checkEditUserElements();
                                                        });
// Helper function to get role display name
                                                        function getRoleDisplayName(role) {
                                                            switch (role) {
                                                                case 'Admin':
                                                                    return 'Quản trị viên';
                                                                case 'Reception':
                                                                    return 'Nhân viên lễ tân';
                                                                case 'Customer':
                                                                    return 'Khách hàng';
                                                                default:
                                                                    return role;
                                                            }
                                                        }
// Toggle password visibility
                                                        function togglePassword(inputId) {
                                                            const input = document.getElementById(inputId);
                                                            const icon = input.nextElementSibling.querySelector('i');
                                                            if (input.type === 'password') {
                                                                input.type = 'text';
                                                                icon.classList.replace('fa-eye', 'fa-eye-slash');
                                                            } else {
                                                                input.type = 'password';
                                                                icon.classList.replace('fa-eye-slash', 'fa-eye');
                                                            }
                                                        }

                                                        // Preview avatar for edit form
                                                        function previewEditAvatar(input) {
                                                            if (input.files && input.files[0]) {
                                                                const file = input.files[0];
                                                                const maxSize = 2 * 1024 * 1024;
                                                                const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];

                                                                if (file.size > maxSize) {
                                                                    alert('Kích thước file không được vượt quá 2MB');
                                                                    input.value = '';
                                                                    return;
                                                                }

                                                                if (!allowedTypes.includes(file.type)) {
                                                                    alert('Chỉ chấp nhận file JPG, PNG hoặc GIF');
                                                                    input.value = '';
                                                                    return;
                                                                }

                                                                const reader = new FileReader();
                                                                reader.onload = function (e) {
                                                                    document.getElementById('editAvatarPreview').src = e.target.result;
                                                                    document.getElementById('editAvatarPreviewLarge').src = e.target.result;
                                                                };
                                                                reader.readAsDataURL(file);
                                                            }
                                                        }

//Validation before submit
                                                        document.getElementById('editUserForm').addEventListener('submit', function (e) {
                                                            e.preventDefault();

                                                            const form = this;
                                                            let isValid = true;

                                                            const fullName = document.getElementById('editFullName');
                                                            const userName = document.getElementById('editUserNameInput');
                                                            const birth = document.getElementById('editBirth');
                                                            const email = document.getElementById('editEmail');
                                                            const phone = document.getElementById('editPhone');
                                                            const role = document.getElementById('editRole');
                                                            const password = document.getElementById('editPassword');
                                                            const confirmPassword = document.getElementById('editConfirmPassword');

                                                            const inputs = [fullName, userName, birth, email, phone, role, password, confirmPassword];

                                                            form.classList.remove('was-validated');

                                                            inputs.forEach(input => {
                                                                if (input) {
                                                                    input.classList.remove('is-valid', 'is-invalid');
                                                                    const feedback = input.closest('.mb-3, .input-group').querySelector('.invalid-feedback');
                                                                    if (feedback)
                                                                        feedback.style.display = 'none';
                                                                }
                                                            });

                                                            const validateField = (field, condition, message) => {
                                                                const container = field.closest('.mb-3') || field.closest('.input-group').parentNode;
                                                                const feedback = container.querySelector('.invalid-feedback');

                                                                if (!condition) {
                                                                    field.classList.add('is-invalid');
                                                                    if (feedback) {
                                                                        feedback.textContent = message;
                                                                        feedback.style.display = 'block';
                                                                    }
                                                                    isValid = false;
                                                                } else {
                                                                    field.classList.add('is-valid');
                                                                    if (feedback)
                                                                        feedback.style.display = 'none';
                                                                }
                                                            };

                                                            validateField(fullName, isValidFullName(fullName.value), 'Họ và tên chỉ chứa chữ cái và khoảng trắng, tối thiểu 2 ký tự');
                                                            validateField(userName, isValidUsername(userName.value.trim()), 'Tên đăng nhập phải ≥ 8 ký tự, chỉ gồm chữ cái, số, gạch dưới');
                                                            validateField(birth, isAtLeast18YearsOld(birth.value), 'Người dùng phải đủ 18 tuổi');
                                                            validateField(email, isValidEmail(email.value.trim()), 'Email không hợp lệ');
                                                            validateField(phone, isValidPhone(phone.value.trim()), 'Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số');
                                                            validateField(role, role.value !== '', 'Vui lòng chọn vai trò');

                                                            if (password.value) {
                                                                validateField(password, isValidPassword(password.value), 'Mật khẩu phải từ 8–16 ký tự, gồm chữ hoa, thường và số');
                                                                validateField(confirmPassword, password.value === confirmPassword.value, 'Mật khẩu xác nhận không khớp');
                                                            }

                                                            if (isValid) {
                                                                const saveBtn = document.getElementById('saveEditUserBtn');
                                                                saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
                                                                saveBtn.disabled = true;
                                                                form.submit();
                                                            } else {
                                                                const firstInvalid = form.querySelector('.is-invalid');
                                                                if (firstInvalid) {
                                                                    firstInvalid.focus();
                                                                    firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                                }
                                                            }
                                                        });

//Real-time validation
                                                        document.getElementById('editUserForm').addEventListener('input', function (e) {
                                                            const input = e.target;
                                                            if (!input || !input.id)
                                                                return;

                                                            const value = input.value.trim();
                                                            const container = input.closest('.mb-3') || input.closest('.input-group')?.parentNode;
                                                            const feedback = container?.querySelector('.invalid-feedback');

                                                            input.classList.remove('is-valid', 'is-invalid');
                                                            if (!value) {
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                                return;
                                                            }

                                                            const [valid, message] = getValidationResult(input);

                                                            if (valid) {
                                                                input.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                input.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = message;
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }
                                                        });

//validate role and dob
                                                        document.getElementById('editRole').addEventListener('change', function () {
                                                            const feedback = this.closest('.mb-3')?.querySelector('.invalid-feedback');
                                                            this.classList.remove('is-valid', 'is-invalid');

                                                            if (this.value !== '') {
                                                                this.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Vui lòng chọn vai trò';
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }
                                                        });

                                                        document.getElementById('editBirth').addEventListener('change', function () {
                                                            const feedback = this.closest('.mb-3')?.querySelector('.invalid-feedback');
                                                            this.classList.remove('is-valid', 'is-invalid');

                                                            if (!this.value) {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Vui lòng chọn ngày sinh';
                                                                    feedback.style.display = 'block';
                                                                }
                                                                return;
                                                            }

                                                            if (isAtLeast18YearsOld(this.value)) {
                                                                this.classList.add('is-valid');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            } else {
                                                                this.classList.add('is-invalid');
                                                                if (feedback) {
                                                                    feedback.textContent = 'Người dùng phải đủ 18 tuổi';
                                                                    feedback.style.display = 'block';
                                                                }
                                                            }
                                                        });

// Reset form
                                                        document.getElementById('editUserModal').addEventListener('hidden.bs.modal', function () {
                                                            const form = document.getElementById('editUserForm');
                                                            form.reset();
                                                            form.classList.remove('was-validated');

                                                            const inputs = form.querySelectorAll('.form-control, .form-select');
                                                            inputs.forEach(input => {
                                                                input.classList.remove('is-valid', 'is-invalid');
                                                                const container = input.closest('.mb-3') || input.closest('.input-group')?.parentNode;
                                                                const feedback = container?.querySelector('.invalid-feedback');
                                                                if (feedback)
                                                                    feedback.style.display = 'none';
                                                            });

                                                            const saveBtn = document.getElementById('saveEditUserBtn');
                                                            saveBtn.innerHTML = '<i class="fas fa-save me-2"></i>Lưu thay đổi';
                                                            saveBtn.disabled = false;
                                                        });

        </script>
    </body>
</html>
