<%-- 
    Document   : RoleAuth
    Created on : Jul 4, 2025, 11:41:11 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Không có quyền truy cập</title>
        <link rel="stylesheet" href="css/auth-pages.css">
    </head>
    <body>
        <div class="auth-container role-auth">
            <div class="auth-icon role-auth-icon">
                ⚠️
            </div>
            <h1 class="auth-title">Không có quyền truy cập!</h1>
            <p class="auth-message">
                Bạn không có quyền để truy cập vào trang này. Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là lỗi.
            </p>
            <a href="home" class="auth-button">
                Quay về trang chủ
            </a>
        </div>
    </body>
</html>
