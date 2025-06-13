<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng Ký</title>
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
                            <h2 class="display-5 fw-bold text-center">Đăng ký</h2>
                            <p class="text-center m-0">Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-10 col-xl-8">
                        <div class="row gy-5 justify-content-center">
                            <div class="col-12 col-lg-7">
                                <form action="register" method="post">
                                    <div class="row gy-3 overflow-hidden">
                                        <div class="col-12">
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control border-1 border-bottom rounded-0" name="userName" id="stringlog" placeholder="Tên đăng nhập, email hoặc sđt" required>
                                                <label for="stringlog" class="form-label">Tên tài khoản</label>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="form-floating mb-3">
                                                <input type="password" class="form-control border-1 border-bottom rounded-0" name="password" id="password" value="" placeholder="Nhập mật khẩu..." required>
                                                <label for="password" class="form-label">Mật khẩu</label>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="form-floating mb-3">
                                                <input type="password" class="form-control border-1 border-bottom rounded-0" name="confirmPassword" id="password" value="" placeholder="Nhập lại mật khẩu..." required>
                                                <label for="password" class="form-label">Xác nhận mật khẩu</label>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <i style="color: red">${requestScope.error}</i>
                                        </div>
                                        <div class="col-12 d-flex justify-content-center">
                                            <div class="col-4">
                                                <button class="btn btn-primary btn-lg" type="submit">Đăng ký</button>
                                            </div>
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
