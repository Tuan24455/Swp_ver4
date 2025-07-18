<%--
    Document   : find-account
    Created on : Jul 6, 2025, 12:11:41 PM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt lại mật khẩu</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/auth-form.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="fas fa-key"></i>
                    </div>
                    <h2>Đặt lại mật khẩu</h2>
                    <p>Tạo mật khẩu mới cho tài khoản của bạn</p>
                </div>

                <form action="resetPassword" method="post" class="auth-form">
                    <input type="hidden" name="keyword" value="${requestScope.keyword}"/>

                    <!-- New Password -->
                    <div class="form-group">
                        <div class="password-group">
                            <input type="password" name="newpassword" class="form-input" placeholder="Nhập mật khẩu mới" required>
                            <button type="button" class="password-toggle">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-requirements">
                            <small>
                                <i class="fas fa-info-circle"></i>
                                Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số
                            </small>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <div class="password-group">
                            <input type="password" name="confirmpassword" class="form-input" placeholder="Xác nhận mật khẩu mới" required>
                            <button type="button" class="password-toggle">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Error message -->
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${requestScope.error}
                    </div>
                    <% } %>

                    <!-- Submit button -->
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i>
                        Lưu thay đổi
                    </button>

                    <!-- Back to login link -->
                    <div class="resend-link">
                        <a href="login.jsp" class="auth-link">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại đăng nhập
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>

        <!-- Password toggle JS (inline) -->
        <script defer>
            document.addEventListener('DOMContentLoaded', () => {
                const toggleButtons = document.querySelectorAll('.password-toggle');
                toggleButtons.forEach((button) => {
                    button.addEventListener('click', (e) => {
                        e.preventDefault();
                        const input = button.closest('.password-group').querySelector('input');
                        const icon = button.querySelector('i');
                        if (input.type === 'password') {
                            input.type = 'text';
                            icon.classList.replace('fa-eye', 'fa-eye-slash');
                        } else {
                            input.type = 'password';
                            icon.classList.replace('fa-eye-slash', 'fa-eye');
                        }
                    });
                });
            });
        </script>

        <style>
            .password-requirements {
                margin-top: 0.5rem;
                padding: 0.75rem;
                background: #f0f9ff;
                border-radius: 6px;
                border-left: 3px solid #0ea5e9;
            }

            .password-requirements small {
                color: #0369a1;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
        </style>
    </body>
</html>
