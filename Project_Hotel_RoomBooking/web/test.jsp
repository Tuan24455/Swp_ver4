<%-- 
    Document   : test
    Created on : Jul 18, 2025, 3:47:27 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Test Show Password</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <script defer>
    document.addEventListener('DOMContentLoaded', () => {
      const toggleButtons = document.querySelectorAll('.password-toggle');

      toggleButtons.forEach((button) => {
        button.addEventListener('click', (e) => {
          e.preventDefault();
          const input = button.closest('.password-group').querySelector('input');
          const icon = button.querySelector('i');
          if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
          } else {
            input.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
          }
        });
      });
    });
  </script>
</head>
<body>
  <div class="password-group">
    <input type="password" placeholder="Mật khẩu">
    <button type="button" class="password-toggle">
      <i class="fas fa-eye"></i>
    </button>
  </div>
</body>
</html>
