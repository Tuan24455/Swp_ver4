<%-- 
    Document   : contact
    Created on : May 22, 2025, 3:28:03 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên Hệ - Hệ thống quản lý khách sạn</title>

        <!-- CSS Libraries -->
        <!--<link rel="stylesheet" href="customer/customer.css" />-->
        <!--<link rel="stylesheet" href="customer/includes/component.css" />-->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/contact-enhanced.css"/>
    </head>
    <body>
        <!-- Background overlay -->
        <div class="contact-background"></div>

        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <!-- Main Content -->
        <main class="contact-main">
            <div class="container">

                <!-- Page Header -->
                <section class="contact-header animate__animated animate__fadeInDown">
                    <div class="header-content">
                        <h1 class="page-title">
                            <i class="fas fa-envelope me-3"></i>
                            Liên hệ với chúng tôi
                        </h1>
                        <p class="page-subtitle">
                            Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn. Hãy để lại thông tin và chúng tôi sẽ phản hồi sớm nhất.
                        </p>
                    </div>
                </section>

                <div class="contact-content">
                    <div class="row g-4">

                        <!-- Contact Information -->
                        <div class="col-lg-4 contact-left-col">
                            <div class="contact-info-section animate__animated animate__fadeInLeft">

                                <!-- Contact Info Card -->
                                <div class="info-card">
                                    <div class="info-card-header">
                                        <h3><i class="fas fa-info-circle me-2"></i>Thông tin liên hệ</h3>
                                    </div>
                                    <div class="info-card-body">
                                        <div class="contact-items">
                                            <div class="contact-item">
                                                <div class="contact-icon">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                </div>
                                                <div class="contact-details">
                                                    <h6>Địa chỉ</h6>
                                                    <p>123 Đường ABC, Quận XYZ<br>Thành phố Hồ Chí Minh</p>
                                                </div>
                                            </div>

                                            <div class="contact-item">
                                                <div class="contact-icon">
                                                    <i class="fas fa-phone"></i>
                                                </div>
                                                <div class="contact-details">
                                                    <h6>Điện thoại</h6>
                                                    <p>+84 123 456 789<br>+84 987 654 321</p>
                                                </div>
                                            </div>

                                            <div class="contact-item">
                                                <div class="contact-icon">
                                                    <i class="fas fa-envelope"></i>
                                                </div>
                                                <div class="contact-details">
                                                    <h6>Email</h6>
                                                    <p>info@hotel.com<br>support@hotel.com</p>
                                                </div>
                                            </div>

                                            <div class="contact-item">
                                                <div class="contact-icon">
                                                    <i class="fas fa-clock"></i>
                                                </div>
                                                <div class="contact-details">
                                                    <h6>Giờ làm việc</h6>
                                                    <p>Thứ 2 - Chủ nhật<br>24/7 - Luôn sẵn sàng phục vụ</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Social Media Card -->
                                <div class="social-card">
                                    <div class="social-card-header">
                                        <h4><i class="fas fa-share-alt me-2"></i>Kết nối với chúng tôi</h4>
                                    </div>
                                    <div class="social-links">
                                        <a href="#" class="social-link facebook" title="Facebook">
                                            <i class="fab fa-facebook-f"></i>
                                        </a>
                                        <a href="#" class="social-link twitter" title="Twitter">
                                            <i class="fab fa-twitter"></i>
                                        </a>
                                        <a href="#" class="social-link instagram" title="Instagram">
                                            <i class="fab fa-instagram"></i>
                                        </a>
                                        <a href="#" class="social-link linkedin" title="LinkedIn">
                                            <i class="fab fa-linkedin-in"></i>
                                        </a>
                                        <a href="#" class="social-link youtube" title="YouTube">
                                            <i class="fab fa-youtube"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Form -->
                        <div class="col-lg-8">
                            <div class="contact-form-section animate__animated animate__fadeInRight">
                                <div class="form-card">
                                    <div class="form-card-header">
                                        <h3><i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn</h3>
                                        <p>Điền thông tin bên dưới và chúng tôi sẽ liên hệ lại với bạn trong thời gian sớm nhất</p>
                                    </div>

                                    <div class="form-card-body">

                                        <!-- Message Display -->
                                        <c:if test="${not empty requestScope.message}">
                                            <div class="alert alert-${requestScope.messageType == 'success' ? 'success' : 'danger'} animate__animated animate__fadeInDown" role="alert">
                                                <i class="fas fa-${requestScope.messageType == 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
                                                ${requestScope.message}
                                                <c:if test="${not empty requestScope.errorMessageDetail}">
                                                    <br><small>${requestScope.errorMessageDetail}</small>
                                                </c:if>
                                            </div>
                                        </c:if>

                                        <!-- Contact Form -->
                                        <form id="contactForm" action="contact" method="post" class="contact-form" novalidate>
                                            <div class="form-grid">

                                                <!-- Name Field -->
                                                <div class="form-group">
                                                    <label for="name" class="form-label">
                                                        <i class="fas fa-user me-2"></i>Tên của bạn
                                                        <span class="required">*</span>
                                                    </label>
                                                    <input type="text" 
                                                           id="name" 
                                                           name="name" 
                                                           class="form-control" 
                                                           placeholder="Nhập họ và tên của bạn"
                                                           required>
                                                    <div class="invalid-feedback"></div>
                                                </div>

                                                <!-- Email Field -->
                                                <div class="form-group">
                                                    <label for="email" class="form-label">
                                                        <i class="fas fa-envelope me-2"></i>Email
                                                        <span class="required">*</span>
                                                    </label>
                                                    <input type="email" 
                                                           id="email" 
                                                           name="email" 
                                                           class="form-control" 
                                                           value="${sessionScope.user.getEmail()}"
                                                           placeholder="example@email.com"
                                                           required>
                                                    <div class="invalid-feedback"></div>
                                                </div>

                                                <!-- Phone Field -->
                                                <div class="form-group">
                                                    <label for="phone" class="form-label">
                                                        <i class="fas fa-phone me-2"></i>Số điện thoại
                                                    </label>
                                                    <input type="tel" 
                                                           id="phone" 
                                                           name="phone" 
                                                           class="form-control" 
                                                           value="${sessionScope.user.getPhone()}"
                                                           placeholder="0123 456 789">
                                                    <div class="invalid-feedback"></div>
                                                </div>

                                                <!-- Subject Field -->
                                                <div class="form-group">
                                                    <label for="subject" class="form-label">
                                                        <i class="fas fa-tag me-2"></i>Chủ đề
                                                        <span class="required">*</span>
                                                    </label>
                                                    <select id="subject" name="subject" class="form-control" required>
                                                        <option value="">Chọn chủ đề</option>
                                                        <option value="booking">Đặt phòng</option>
                                                        <option value="complaint">Khiếu nại</option>
                                                        <option value="suggestion">Góp ý</option>
                                                        <option value="support">Hỗ trợ kỹ thuật</option>
                                                        <option value="other">Khác</option>
                                                    </select>
                                                    <div class="invalid-feedback"></div>
                                                </div>

                                                <!-- Message Field -->
                                                <div class="form-group full-width">
                                                    <label for="message" class="form-label">
                                                        <i class="fas fa-comment me-2"></i>Nội dung tin nhắn
                                                        <span class="required">*</span>
                                                    </label>
                                                    <textarea id="message" 
                                                              name="message" 
                                                              class="form-control" 
                                                              rows="6" 
                                                              placeholder="Nhập nội dung tin nhắn của bạn..."
                                                              required></textarea>
                                                    <div class="invalid-feedback"></div>
                                                    <div class="character-count">
                                                        <span id="charCount">0</span>/500 ký tự
                                                    </div>
                                                </div>

                                                <!-- Privacy Policy -->
                                                <div class="form-group full-width">
                                                    <div class="form-check">
                                                        <input type="checkbox" 
                                                               id="privacy" 
                                                               name="privacy" 
                                                               class="form-check-input" 
                                                               required>
                                                        <label for="privacy" class="form-check-label">
                                                            Tôi đồng ý với <a href="#" class="privacy-link">chính sách bảo mật</a> 
                                                            và cho phép xử lý thông tin cá nhân
                                                            <span class="required">*</span>
                                                        </label>
                                                        <div class="invalid-feedback"></div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Button -->
                                            <div class="form-actions">
                                                <button type="reset" class="btn btn-reset">
                                                    <i class="fas fa-undo me-2"></i>Đặt lại
                                                </button>
                                                <button type="submit" class="btn btn-submit" id="submitBtn" style="color: white;">
                                                    <i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>

        <!-- Scripts -->
        <script src="js/contact-enhanced.js"></script>
    </body>
</html>
