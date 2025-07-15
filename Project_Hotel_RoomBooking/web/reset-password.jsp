<%-- 
    Document   : forgot-password
    Created on : Jul 6, 2025, 7:51:35 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt lại mật khẩu</title>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <form action="otpVerification" method="post">
            <h2>Đặt lại mật khẩu</h2>
            <input type="hidden" name="keyword" value="${requestScope.keyword}"/>
            <input type="text" name="newpassword" placeholder="Nhập mật khẩu mới">
            <input type="text" name="confirmpassword" placeholder="Xác nhận mật khẩu mới">
            <!-- hiển thị lỗi mật khẩu không đúng quy định hoặ không khớp -->
            <input type="submit" name="Lưu thay đổi">
        </form>
    </body>
</html>
