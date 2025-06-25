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
                                    <i class="fas fa-plus me-2"></i>Thêm người dùng mới
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
                                        <select class="form-select" name="status" onchange="this.form.submit()">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <input type="date" class="form-control" name="dateFrom" value="${dateFrom}" placeholder="Từ ngày" />
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
                                            <th>
                                                <input type="checkbox" class="form-check-input" id="selectAll" />
                                            </th>
                                            <th>ID</th>
                                            <th>Avatar</th>
                                            <th>Tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Vai trò</th>
                                            <th>Giới tính</th>
                                            <th>Ngày sinh</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty userList}">
                                                <c:forEach var="user" items="${userList}" varStatus="status">
                                                    <tr class="user-row">
                                                        <td>
                                                            <input type="checkbox" class="form-check-input row-checkbox" 
                                                                   data-user-id="${user.id}" />
                                                        </td>
                                                        <td><strong>#${user.id}</strong></td>
                                                        <td>
                                                            <div class="user-avatar">
                                                                <c:choose>
                                                                    <c:when test="${not empty user.avatarUrl}">
                                                                        <img src="${pageContext.request.contextPath}/${user.avatarUrl}" 
                                                                             alt="Avatar" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="Default Avatar" />
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
                                                            <c:choose>
                                                                <c:when test="${not empty user.birth}">
                                                                    <fmt:formatDate value="${user.birth}" pattern="dd/MM/yyyy" />
                                                                    <br><small class="text-muted">
                                                                        <fmt:formatDate value="${user.birth}" pattern="yyyy" var="birthYear" />
                                                                        <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy" var="currentYear" />
                                                                        ${currentYear - birthYear} tuổi
                                                                    </small>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa cập nhật</span>
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
                                                                        onclick="editUser(${user.id})">
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
                                                            <p class="text-muted">Hãy thêm người dùng mới hoặc thay đổi bộ lọc</p>
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
                                            <img id="avatarPreview" src="${pageContext.request.contextPath}/images/default-avatar.png" 
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
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                    <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="userName" class="form-label">
                                        <i class="fas fa-at me-1"></i>Tên đăng nhập <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="userName" name="userName" required>
                                    <div class="invalid-feedback">Vui lòng nhập tên đăng nhập</div>
                                    <small class="form-text text-muted">Chỉ chứa chữ cái, số và dấu gạch dưới</small>
                                </div>

                                <div class="col-md-6">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-1"></i>Email <span class="text-danger">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="phone" class="form-label">
                                        <i class="fas fa-phone me-1"></i>Số điện thoại
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone" pattern="[0-9]{10,11}">
                                    <div class="invalid-feedback">Số điện thoại phải có 10-11 chữ số</div>
                                </div>

                                <!-- Password Section -->
                                <div class="col-md-6">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-1"></i>Mật khẩu <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" required minlength="6">
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
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
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
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="">Chọn vai trò</option>
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
                                        <i class="fas fa-birthday-cake me-1"></i>Ngày sinh
                                    </label>
                                    <input type="date" class="form-control" id="birth" name="birth">
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

                                <div class="col-12">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="requirePasswordChange" name="requirePasswordChange">
                                        <label class="form-check-label" for="requirePasswordChange">
                                            <i class="fas fa-key me-1"></i>Yêu cầu đổi mật khẩu khi đăng nhập lần đầu
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
            // Avatar preview function
            function previewAvatar(input) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
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

            // Form validation
            document.getElementById('addUserForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const form = this;
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                // Check password match
                if (password !== confirmPassword) {
                    document.getElementById('confirmPassword').setCustomValidity('Mật khẩu xác nhận không khớp');
                } else {
                    document.getElementById('confirmPassword').setCustomValidity('');
                }
                
                if (form.checkValidity()) {
                    // Show loading state
                    const saveBtn = document.getElementById('saveUserBtn');
                    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
                    saveBtn.disabled = true;
                    
                    // Submit form
                    form.submit();
                } else {
                    form.classList.add('was-validated');
                }
            });

            // User management functions
            function viewUser(userId) {
                // Fetch user details via AJAX
                fetch('userList?action=getUserDetails&id=' + userId)
                        .then(response => response.json())
                        .then(user => {
                            document.getElementById('userDetails').innerHTML = `
                            <div class="row">
                                <div class="col-md-4 text-center">
                                    <img src="${user.avatarUrl || '${pageContext.request.contextPath}/images/default-avatar.png'}" 
                                         class="rounded-circle mb-3" alt="User Avatar" width="100" height="100">
                                    <h5>${user.fullName}</h5>
                                    <p class="text-muted">@${user.userName}</p>
                                </div>
                                <div class="col-md-8">
                                    <table class="table table-borderless">
                                        <tr><td><strong>ID:</strong></td><td>#${user.id}</td></tr>
                                        <tr><td><strong>Email:</strong></td><td>${user.email}</td></tr>
                                        <tr><td><strong>Số điện thoại:</strong></td><td>${user.phone || 'Chưa cập nhật'}</td></tr>
                                        <tr><td><strong>Vai trò:</strong></td><td>${user.role}</td></tr>
                                        <tr><td><strong>Giới tính:</strong></td><td>${user.gender}</td></tr>
                                        <tr><td><strong>Địa chỉ:</strong></td><td>${user.address || 'Chưa cập nhật'}</td></tr>
                                    </table>
                                </div>
                            </div>
                        `;
                            new bootstrap.Modal(document.getElementById('viewUserModal')).show();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Không thể tải thông tin người dùng');
                        });
            }

            function editUser(userId) {
                window.location.href = 'editUser?id=' + userId;
            }

            function deleteUser(userId, userName) {
                if (confirm(`Bạn có chắc chắn muốn xóa người dùng "${userName}"? Hành động này không thể hoàn tác.`)) {
                    window.location.href = 'userList?action=delete&id=' + userId;
                }
            }

            function exportUsers() {
                window.location.href = 'exportUsers';
            }

            // Select all functionality
            document.getElementById('selectAll')?.addEventListener('change', function () {
                const checkboxes = document.querySelectorAll('.row-checkbox');
                checkboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
            });

            // Auto-hide alerts
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);

            // Reset form when modal is hidden
            document.getElementById('addUserModal').addEventListener('hidden.bs.modal', function () {
                const form = document.getElementById('addUserForm');
                form.reset();
                form.classList.remove('was-validated');
                document.getElementById('avatarPreview').src = '${pageContext.request.contextPath}/images/default-avatar.png';
                
                // Reset save button
                const saveBtn = document.getElementById('saveUserBtn');
                saveBtn.innerHTML = '<i class="fas fa-save me-2"></i>Lưu người dùng';
                saveBtn.disabled = false;
            });
        </script>
    </body>
</html>
