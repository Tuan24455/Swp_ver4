<%-- 
    Document   : otp-verification
    Created on : Jul 6, 2025, 12:12:01 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% String otp = (String) session.getAttribute("otp"); %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xác minh tài khoản</title>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <form action="otpVerification" method="post">
            <h2>Xác minh otp</h2>
            <input type="hidden" name="keyword" value="${requestScope.keyword}"/>
            <input type="text" name="otp" placeholder="Nhập mã otp">
            <!-- hiển thị lỗi otp không khớp -->
            <input type="submit" name="Xác minh">
        </form>
    </body>
</html>
