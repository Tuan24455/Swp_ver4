<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết dịch vụ</title>
        <link rel="stylesheet" href="css/home-enhanced.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    </head>
    <body>
        <!-- Background -->
        <div class="background-overlay"></div>

        <jsp:include page="customer/includes/header.jsp"/>

        <main class="main-content">
            <!-- Hero Section -->
            <section class="hero-section animate__animated animate__fadeInDown">
                <div class="container">
                    <div class="hero-content text-center">
                        <h1 class="hero-title">
                            <i class="fas fa-info-circle me-2"></i>
                            Chi Tiết Dịch Vụ
                        </h1>
                        <p class="hero-subtitle">Thông tin chi tiết về dịch vụ ${service.serviceName}</p>
                    </div>
                </div>
            </section>

            <!-- Service Detail Section -->
            <section class="service-detail-section">
                <div class="container">
                    <div class="row">
                        <!-- Service Images -->
                        <div class="col-lg-6 animate__animated animate__fadeInLeft">
                            <div class="service-image-container">
                                <img src="${service.imageUrl}" alt="${service.serviceName}" class="main-image img-fluid rounded shadow"/>
                            </div>
                        </div>

                        <!-- Service Information -->
                        <div class="col-lg-6 animate__animated animate__fadeInRight">
                            <div class="service-info-container">
                                <div class="service-header">
                                    <h2 class="service-title">${service.serviceName}</h2>
                                    <span class="service-type-badge">${service.serviceTypeName}</span>
                                </div>

                                <div class="service-price">
                                    <i class="fas fa-tag text-success me-2"></i>
                                    <span class="price-value">
                                        <fmt:formatNumber value="${service.servicePrice}" type="number" groupingUsed="true"/> VND
                                    </span>
                                </div>

                                <div class="service-description">
                                    <h4><i class="fas fa-info-circle me-2"></i>Mô tả dịch vụ</h4>
                                    <p>${service.description}</p>
                                </div>

                                <div class="service-status">
                                    <h4><i class="fas fa-clock me-2"></i>Trạng thái</h4>
                                    <span class="status-badge ${service.status == 1 ? 'available' : 'unavailable'}">
                                        ${service.status == 1 ? 'Đang phục vụ' : 'Tạm ngưng'}
                                    </span>
                                </div>

                                <!-- Booking Section -->
                                <div class="booking-section mt-4">
                                    <c:if test="${service.status == 1}">
                                        <form action="bookService" method="POST" class="booking-form">
                                            <input type="hidden" name="serviceId" value="${service.id}"/>
                                            <div class="form-group mb-3">
                                                <label for="bookingDate" class="form-label">
                                                    <i class="fas fa-calendar me-2"></i>Ngày sử dụng
                                                </label>
                                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" required/>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="quantity" class="form-label">
                                                    <i class="fas fa-sort-numeric-up me-2"></i>Số lượng
                                                </label>
                                                <input type="number" class="form-control" id="quantity" name="quantity" 
                                                       min="1" value="1" required/>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="note" class="form-label">
                                                    <i class="fas fa-sticky-note me-2"></i>Ghi chú
                                                </label>
                                                <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-book-service w-100">
                                                <i class="fas fa-calendar-check me-2"></i>Đặt dịch vụ
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${service.status != 1}">
                                        <div class="unavailable-notice">
                                            <i class="fas fa-exclamation-circle me-2"></i>
                                            Dịch vụ hiện không khả dụng
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Related Services -->
                    <section class="related-services mt-5">
                        <h3 class="section-title text-center">
                            <i class="fas fa-thumbs-up me-2"></i>
                            Dịch vụ tương tự
                        </h3>
                        <div class="section-divider"></div>
                        <div class="row mt-4 justify-content-center">
                            <div class="col-12 col-lg-10">
                                <div class="bg-white rounded shadow-sm p-4">
                                    <div class="row">
                                        <c:forEach var="relatedService" items="${relatedServices}">
                                            <div class="col-md-4 mb-4">
                                                <div class="service-card animate__animated animate__fadeInUp">
                                                    <div class="service-image">
                                                        <img src="${relatedService.imageUrl}" alt="${relatedService.serviceName}" class="img-fluid"/>
                                                        <div class="service-price-badge">
                                                            <fmt:formatNumber value="${relatedService.servicePrice}" type="number" groupingUsed="true"/> VND
                                                        </div>
                                                    </div>
                                                    <div class="service-content">
                                                        <h5 class="service-name">${relatedService.serviceName}</h5>
                                                        <p class="service-brief">
                                                            ${fn:substring(relatedService.description, 0, 100)}...
                                                        </p>
                                                        <a href="serviceDetail?id=${relatedService.id}" class="btn btn-view-detail">
                                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </section>
        </main>

        <jsp:include page="customer/includes/footer.jsp"/>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/home-enhanced.js"></script>
        <script>
            // Validate booking date to prevent past dates
            document.addEventListener('DOMContentLoaded', function() {
                const bookingDateInput = document.getElementById('bookingDate');
                if (bookingDateInput) {
                    const today = new Date();
                    const dd = String(today.getDate()).padStart(2, '0');
                    const mm = String(today.getMonth() + 1).padStart(2, '0');
                    const yyyy = today.getFullYear();
                    const minDate = yyyy + '-' + mm + '-' + dd;
                    
                    bookingDateInput.setAttribute('min', minDate);
                }
            });
            
            // Calculate and update total price based on quantity
            const quantityInput = document.getElementById('quantity');
            if (quantityInput) {
                quantityInput.addEventListener('change', function() {
                    const basePrice = ${service.servicePrice};
                    const quantity = this.value;
                    const totalPrice = basePrice * quantity;
                    document.querySelector('.price-value').textContent = 
                        new Intl.NumberFormat('vi-VN').format(totalPrice) + ' VND';
                });
            }
        </script>
    </body>
</html>