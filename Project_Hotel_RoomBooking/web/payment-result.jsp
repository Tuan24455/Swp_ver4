<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kết quả thanh toán</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body text-center">
                            <% if ((Boolean)request.getAttribute("paymentSuccess")) { %>
                                <h1 class="text-success">Thanh toán thành công!</h1>
                                <p>Đơn đặt phòng của bạn đã được xác nhận.</p>
                                <i class="fas fa-check-circle text-success" style="font-size: 48px;"></i>
                            <% } else { %>
                                <h1 class="text-danger">Thanh toán thất bại!</h1>
                                <p>Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.</p>
                                <i class="fas fa-times-circle text-danger" style="font-size: 48px;"></i>
                            <% } %>
                            
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Về trang chủ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://kit.fontawesome.com/your-code.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
