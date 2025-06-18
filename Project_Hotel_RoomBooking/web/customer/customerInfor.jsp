<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp"); // hoặc "/login"
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thông tin cá nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="customer/includes/component.css"/>
</head>
<body>
<jsp:include page="includes/header.jsp"/>
<div class="d-flex" id="wrapper">
    <div id="page-content-wrapper" class="flex-fill">
        <div class="container-fluid py-4">

            <!-- Tiêu đề trang -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">Cài đặt tài khoản</h1>
            </div>

            <div class="row g-4">
                <!-- Ảnh đại diện -->
                <div class="col-lg-4">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">
                                <i class="fas fa-camera me-2"></i>Ảnh đại diện
                            </h5>
                        </div>
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <img
                                    src="${empty user.avatarUrl ? 'images/user/default_avatar.png' : user.avatarUrl}"
                                    class="rounded-circle img-fluid border"
                                    alt="Ảnh đại diện"
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
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="uploadProfilePicture()">
                                <i class="fas fa-upload me-2"></i>Tải ảnh lên
                            </button>
                            <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeProfilePicture()">
                                <i class="fas fa-trash me-2"></i>Xóa ảnh
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Thông tin cá nhân -->
                <div class="col-lg-8">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">
                                <i class="fas fa-user me-2"></i>Thông tin cá nhân
                            </h5>
                        </div>
                        <div class="card-body">
                            <form id="profileForm">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Họ và tên</label>
                                        <input type="text" class="form-control" value="${user.fullName}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Tên đăng nhập</label>
                                        <input type="text" class="form-control" value="${user.userName}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" value="${user.email}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" value="${user.phone}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Ngày sinh</label>
                                        <fmt:formatDate value="${user.birth}" pattern="dd/MM/yyyy" var="birthFormatted" />
                                        <input type="text" class="form-control" value="${birthFormatted}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Giới tính</label>
                                        <input type="text" class="form-control" value="${user.gender}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Vai trò</label>
                                        <input type="text" class="form-control" value="${user.role}" readonly />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Địa chỉ</label>
                                        <input type="text" class="form-control" value="${user.address}" readonly />
                                    </div>
                                </div>
                                <div class="mt-3 text-end">
                                    <button type="button" class="btn btn-outline-secondary">
                                        <i class="fas fa-pen me-2"></i>Chỉnh sửa thông tin
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Toast thông báo -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <i class="fas fa-check-circle text-success me-2"></i>
            <strong class="me-auto">Thành công</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Đóng"></button>
        </div>
        <div class="toast-body" id="toastMessage">
            Cập nhật thông tin thành công!
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
