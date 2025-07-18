<%-- 
    Document   : otp-verification
    Created on : Jul 6, 2025, 12:12:01 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác minh tài khoản</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/auth-form.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>
        <% String otp = (String) session.getAttribute("otp"); %>
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h2>Xác minh OTP</h2>
                    <p>Nhập mã xác minh 8 chữ số đã được gửi đến email của bạn</p>
                </div>

                <form action="otpVerification" method="post" class="auth-form">
                    <input type="hidden" name="keyword" value="${requestScope.keyword}"/>

                    <!-- OTP Input Field -->
                    <div class="otp-group">
                        <input type="text" 
                               name="otp" 
                               class="otp-input-single form-input" 
                               placeholder="Nhập mã OTP 8 chữ số"
                               maxlength="8"
                               pattern="\d{8}"
                               inputmode="numeric"
                               required
                               autocomplete="one-time-code">
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
                        <i class="fas fa-check"></i>
                        Xác minh
                    </button>

                    <!-- Resend link -->
                    <div class="resend-link">
                        <p>Không nhận được mã?</p>
                        <a href="otpVerification?keyword=${requestScope.keyword}" class="auth-link">
                            <i class="fas fa-redo"></i>
                            Gửi lại mã OTP
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>

        <script src="js/auth-form.js"></script>
    </body>
</html>
