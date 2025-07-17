<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lỗi - Hotel Management System</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <style>
      body {
        background-color: #f8f9fa;
        min-height: 100vh;
        display: flex;
        align-items: center;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      .error-container {
        max-width: 600px;
        margin: 0 auto;
        padding: 2rem;
      }

      .error-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        padding: 2rem;
        text-align: center;
      }

      .error-icon {
        font-size: 4rem;
        color: #dc3545;
        margin-bottom: 1.5rem;
      }

      .error-title {
        font-size: 1.5rem;
        color: #343a40;
        margin-bottom: 1rem;
      }

      .error-message {
        color: #6c757d;
        margin-bottom: 2rem;
      }

      .btn-back {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        color: white;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.3s ease;
        display: inline-block;
      }

      .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        color: white;
      }
    </style>
  </head>

  <body>
    <div class="error-container">
      <div class="error-card">
        <i class="fas fa-exclamation-circle error-icon"></i>
        <h1 class="error-title">Đã xảy ra lỗi</h1>
        <p class="error-message">
          ${not empty param.message ? param.message : 'Đã có lỗi xảy ra trong
          quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau.'}
        </p>
        <a href="home" class="btn-back">
          <i class="fas fa-home me-2"></i>Về Trang Chủ
        </a>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
