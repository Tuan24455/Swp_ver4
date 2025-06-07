<%-- 
    Document   : registerdetail
    Created on : May 31, 2025, 1:17:43 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Detail</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="components/component.css" />
    </head>
    <body>
        <jsp:include page="components/header.jsp"/>
        <div class="form-container">
            <div class="register-container" id="formContainer">
                <div class="form-wrapper">
                    <div class="form-section">
                        <h2>Thông tin cá nhân</h2>
                        <form action="registerdetail" method="POST">
                            <!-- Hidden fields from step 1 -->
                            <input type="hidden" name="username" value="${username}"/>
                            <input type="hidden" name="password" value="${password}"/>

                            <input type="text" name="fullName" placeholder="Họ và tên..." required />
                            <input type="date" name="birth" required />
                            <select name="gender" required>
                                <option value="">Chọn giới tính</option>
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                                <option value="Bê đê">Khác</option>
                            </select>
                            <input type="email" name="email" placeholder="Email @gmail.com" pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$" required />
                            <input type="text" name="phone" placeholder="Số điện thoại..." required />
                            <input type="text" name="address" placeholder="Địa chỉ..." required />

                            <input type="hidden" name="role" value="customer" />
                            <input type="hidden" name="isDeleted" value="false" />

                            <button type="submit">Tạo tài khoản</button>
                        </form>

                        <!-- Nút quay lại nằm ngoài form, để không bị lỗi lồng form -->
                        <form action="registerdetail" method="GET">
                            <input type="hidden" name="username" value="${username}" />
                            <input type="hidden" name="password" value="${password}" />
                            <button type="submit">Quay lại</button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
