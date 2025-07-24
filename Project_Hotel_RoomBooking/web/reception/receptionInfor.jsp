<%-- 
    Document   : receptionInfor
    Created on : Jun 29, 2025, 10:19:17 AM
    Author     : ADMIN
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<%@ page import="valid.Encrypt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Định nghĩa biến JavaScript CONTEXT_PATH
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Cài đặt tài khoản - ${user.fullName}</title>
        <!-- Include the CSS and JS files -->
        <link rel="stylesheet" href="css/reception-profile.css">
        <!-- CSS Libraries -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

        <script>
            // Biến JavaScript để lưu context path của ứng dụng
            const CONTEXT_PATH = "<%= contextPath %>";
        </script>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <div id="sidebar-wrapper">
                <jsp:include page="includes/sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard" />
                </jsp:include>
            </div>

            <!-- Updated HTML structure for the profile page content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Profile Header -->
                <div class="profile-header">
                    <h1><i class="fas fa-user-circle"></i> Thông tin cá nhân</h1>
                    <p>Quản lý thông tin tài khoản và cài đặt cá nhân</p>
                </div>

                <!-- Avatar Section -->
                <div class="avatar-section">
                    <div class="avatar-container">
                        <img src="${empty user.avatarUrl ? 'images/user/default_avatar.png' : user.avatarUrl}" 
                             alt="Ảnh đại diện" class="avatar-image" />
                        <button type="button" class="avatar-upload-btn" id="avatarUploadBtn" title="Thay đổi ảnh đại diện">
                            <i class="fas fa-camera"></i>
                        </button>
                        <input type="file" id="avatarInput" accept="image/*" style="display: none;" />
                    </div>
                    <div class="user-name">${user.fullName}</div>
                    <div class="user-email">${user.email}</div>
                </div>

                <!-- Personal Information Section -->
                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-id-card"></i>
                            Thông tin cá nhân
                        </h2>
                        <button type="button" class="edit-toggle-btn" id="editToggleBtn">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                    </div>


                    <form id="personalInfoForm" action="receptionInfor" method="post" class="profile-form">
                        <div class="form-group">
                            <label for="fullName">Họ và tên</label>
                            <input type="text" id="fullName" name="fullName" value="${user.fullName}" readonly required />
                        </div>

                        <div class="form-group">
                            <label for="userName">Tên đăng nhập</label>
                            <input type="text" id="userName" name="userName" value="${user.userName}" readonly disabled />
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" readonly required />
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" value="${user.phone}" readonly />
                        </div>

                        <div class="form-group">
                            <label for="birth">Ngày sinh</label>
                            <fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd" var="birthFormatted" />
                            <input type="date" id="birth" name="birth" value="${birthFormatted}" readonly />
                        </div>

                        <div class="form-group">
                            <label for="gender">Giới tính</label>
                            <select id="gender" name="gender" disable>
                                <option value="Nam" ${user.gender == 'Nam' || user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${user.gender == 'Nữ' || user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${user.gender == 'Khác' || user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="address">Địa chỉ</label>
                            <textarea id="address" name="address" rows="3" readonly>${user.address}</textarea>
                        </div>

                        <% String mess = (String) request.getAttribute("error"); %>
                        <% if (mess != null && !mess.isEmpty()) { %>
                        <div class="error-message" style="grid-column: 1 / -1;">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= mess %>
                        </div>
                        <% } %>
                        <div class="form-actions" style="grid-column: 1 / -1; display: none;">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Password Security Section -->
                <div class="form-section password-section">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-shield-alt"></i>
                            Bảo mật tài khoản
                        </h2>
                    </div>

                    <form id="passwordForm" action="changeReceptionPassword" method="post" class="profile-form">
                        <% String currentUserPassword = Encrypt.decrypt(user.getPass()); %>
                        <input type="hidden" id="currentUserPassword" value="<%= currentUserPassword %>">

                        <div class="form-group">
                            <label for="currentPassword">Mật khẩu hiện tại</label>
                            <input type="password" id="currentPassword" name="currentPassword" 
                                   placeholder="Nhập mật khẩu hiện tại" required />
                        </div>

                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới</label>
                            <input type="password" id="newPassword" name="newPassword" 
                                   placeholder="Nhập mật khẩu mới" required />
                            <div class="password-strength">
                                <div class="password-strength-bar"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới" required />
                        </div>

                        <div class="form-actions" style="grid-column: 1 / -1;">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-key"></i> Đổi mật khẩu
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Include the CSS and JS files -->
            <script src="${pageContext.request.contextPath}/js/reception-profile.js"></script>
    </body>
</html>
