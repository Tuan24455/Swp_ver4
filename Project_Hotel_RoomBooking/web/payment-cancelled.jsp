<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Thanh toán đã bị hủy</title>
    <link rel="stylesheet" href="css/booking-detail.css" />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    />
    <style>
      body {
        background: #f8f9fa;
      }
      .cancel-container {
        max-width: 500px;
        margin: 60px auto;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
        padding: 40px 32px 32px 32px;
        text-align: center;
      }
      .cancel-container .icon {
        font-size: 3.5rem;
        color: #dc3545;
        margin-bottom: 18px;
      }
      .cancel-container h2 {
        color: #dc3545;
        margin-bottom: 12px;
      }
      .cancel-container .vnp-code {
        font-size: 1.1rem;
        color: #6c757d;
        margin-bottom: 18px;
      }
      .cancel-container .btn {
        margin-top: 18px;
      }
    </style>
  </head>
  <body>
    <div class="cancel-container">
      <div class="icon">
        <i class="fas fa-times-circle"></i>
      </div>
      <h2>Thanh toán đã bị hủy</h2>
      <div class="vnp-code">
        <b>Mã lỗi VNPay:</b> <span>${vnp_ResponseCode}</span>
      </div>
      <p>
        Hóa đơn của bạn đã được cập nhật trạng thái <b>Đã hủy</b>.<br />Vui lòng
        thanh toán lại nếu muốn tiếp tục đặt phòng.
      </p>
      <a href="home.jsp" class="btn btn-primary">Trở về trang chủ</a>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
  </body>
</html>
