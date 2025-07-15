<%--
    Document   : find-account
    Created on : Jul 6, 2025, 12:11:41 PM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm tài khoản</title>
        <link rel="stylesheet" href="css/find-account.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <main class="main-container">
            <div class="form-container">
                <div class="form-header">
                    <div class="icon-wrapper">
                        <i class="fas fa-search"></i>
                    </div>
                    <h1>Tìm tài khoản</h1>
                    <p class="form-description">
                        Nhập email hoặc tên đăng nhập để tìm kiếm tài khoản của bạn
                    </p>
                </div>

                <form id="findAccountForm" action="findAccount" method="post" class="find-account-form">
                    <div class="input-group">
                        <label for="keyword" class="input-label">Email hoặc tên đăng nhập</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user input-icon" id="inputIcon"></i>
                            <input 
                                type="text" 
                                id="keyword" 
                                name="keyword" 
                                placeholder="Nhập email hoặc username"
                                class="form-input"
                                autocomplete="username"
                                >
                        </div>
                        <div class="error-message" id="errorMessage" style="display: none;">
                            <i class="fas fa-exclamation-circle"></i>
                            <span id="errorText"></span>
                        </div>
                    </div>

                    <!-- Display server error if exists -->
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message server-error" id="serverErrorMessage">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                    <% } %>

                    <button type="submit" class="submit-btn" id="submitBtn">
                        <i class="fas fa-search"></i>
                        <span class="btn-text">Tìm kiếm</span>
                        <div class="loading-spinner" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i>
                        </div>
                    </button>
                </form>

                <div class="form-footer">
                    <p>Nhớ mật khẩu? <a href="login.jsp" class="link">Đăng nhập ngay</a></p>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>

        <script src="js/find-account.js"></script>
    </body>
</html>
