<%-- 
    Document   : registerdetail
    Created on : May 31, 2025, 1:17:43 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết đăng ký</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="customer/includes/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body style="background-image: url(images/system/Background.jpg)">
        <jsp:include page="customer/includes/header.jsp"/>
        <section class="py-3 py-md-5 py-xl-8">
            <div class="container login-form">
                <div class="row">
                    <div class="col-12">
                        <div class="mb-5">
                            <h2 class="display-5 fw-bold text-center">Chi tiết đăng ký</h2>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-10 col-xl-8">
                        <div class="row gy-5 justify-content-center">
                            <div class="col-12 col-lg-7">
                                <form action="registerDetail" method="post">
                                    <!-- Hidden fields from step 1 -->
                                    <input type="hidden" name="userName" value="${userName}"/>
                                    <input type="hidden" name="password" value="${password}"/>
                                    <div class="row g-3">
                                        <!-- Họ -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="fName" id="firstName" placeholder="Họ" required>
                                                <label for="firstName">Họ</label>
                                            </div>
                                        </div>

                                        <!-- Tên -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="lName" id="lastName" placeholder="Tên" required>
                                                <label for="lastName">Tên</label>
                                            </div>
                                        </div>

                                        <!-- Ngày sinh -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="date" class="form-control" name="birth" id="birth" placeholder="Ngày sinh" required>
                                                <label for="birth">Ngày sinh</label>
                                            </div>
                                        </div>

                                        <!-- Giới tính -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <select class="form-select" name="gender" id="gender" required>
                                                    <option value="" disabled selected>Chọn giới tính</option>
                                                    <option value="Nam">Nam</option>
                                                    <option value="Nữ">Nữ</option>
                                                    <option value="Khác">Khác</option>
                                                </select>
                                                <label for="gender">Giới tính</label>
                                            </div>
                                        </div>

                                        <!-- Email -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="email" class="form-control" name="email" id="email" placeholder="Email @gmail.com"
                                                       pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$" required>
                                                <label for="email">Email @gmail.com</label>
                                            </div>
                                        </div>

                                        <!-- Số điện thoại -->
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="phone" id="phone" placeholder="Số điện thoại..." required>
                                                <label for="phone">Số điện thoại</label>
                                            </div>
                                        </div>

                                        <!-- Địa chỉ (full width) -->
                                        <div class="col-12">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="address" id="address" placeholder="Địa chỉ..." required>
                                                <label for="address">Địa chỉ</label>
                                            </div>
                                        </div>

                                        <!-- Lỗi -->
                                        <div class="col-12">
                                            <i style="color: red">${requestScope.error}</i>
                                        </div>

                                        <!-- Nút đăng ký -->
                                        <div class="col-12 text-center">
                                            <button class="btn btn-primary btn-lg px-5" type="submit">Đăng ký</button>
                                        </div>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
