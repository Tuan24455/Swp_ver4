<%-- 
    Document   : LoginAuth
    Created on : Jul 4, 2025, 11:39:21 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Yêu cầu đăng nhập</title>
        <link rel="stylesheet" href="css/auth-pages.css">
    </head>
    <body>
        <div class="auth-container login-auth">
            <div class="auth-icon login-auth-icon">
                🔒
            </div>
            <h1 class="auth-title">Bạn chưa đăng nhập!</h1>
            <p class="auth-message">
                Để truy cập trang này, bạn cần đăng nhập vào hệ thống trước.
            </p>
            <a href="login.jsp" class="auth-button">
                Quay về trang đăng nhập
            </a>
        </div>
    </body>
</html>
