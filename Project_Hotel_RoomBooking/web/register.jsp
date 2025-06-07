<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng Ký</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="components/component.css" />
    </head>
    <body>
        <jsp:include page="components/header.jsp"/>
        <div class="form-container">
            <div class="register-container" id="formContainer">
                <div class="form-wrapper">
                    <div class="form-section">
                        <h2>Tạo tài khoản</h2>
                        <form action="register" method="post">
                            <input type="text" name="username" placeholder="Tên đăng nhập..." value="${requestScope.username}" required />
                            <input type="password" name="password" placeholder="Mật khẩu..." value="${requestScope.password}" required />
                            <input type="password" name="confirm_password" placeholder="Xác nhận mật khẩu..." value="${requestScope.confirm_password}" required />
                            <i style="color: red">${requestScope.error}</i>
                            <button type="submit">Tiếp tục</button>
                            <p>Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
