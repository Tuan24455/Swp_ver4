<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết dịch vụ - ${service.name}</title>
    <link rel="stylesheet" href="css/home-enhanced.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        
        .product-detail-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin: 20px 0;
            overflow: hidden;
        }
        
        .product-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-sku {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .price-section {
            margin-bottom: 20px;
        }
        

        
        .current-price {
            color: #d63384;
            font-size: 24px;
            font-weight: bold;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
            font-weight: 500;
        }
        
        .stock-status {
            color: #28a745;
            font-weight: bold;
        }
        
        .shipping-info {
            color: #0066cc;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            margin: 20px 0;
        }
        
        .quantity-label {
            margin-right: 15px;
            font-weight: 500;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .quantity-btn {
            background: #f8f9fa;
            border: none;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .quantity-btn:hover {
            background: #e9ecef;
        }
        
        .quantity-input {
            border: none;
            width: 60px;
            height: 35px;
            text-align: center;
            font-weight: bold;
        }
        

        
        .add-to-cart-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
            margin-top: 15px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .add-to-cart-btn:hover {
            background: #c82333;
        }
        
        .section-tabs {
            margin-top: 30px;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
        
        .tab-header {
            display: flex;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }
        
        .tab-item {
            padding: 10px 20px;
            cursor: pointer;
            font-weight: 500;
            color: #666;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }
        
        .tab-item.active {
            color: #dc3545;
            border-bottom-color: #dc3545;
        }
        
        .tab-content {
            display: none;
            padding: 20px 0;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 0;
            margin-bottom: 0;
        }
        
        .hero-title {
            color: white;
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        
        .hero-subtitle {
            color: rgba(255,255,255,0.9);
            font-size: 1.2rem;
        }
        
        .related-services .service-card {
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            background: white;
        }
        
        .related-services .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .service-image img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .service-content {
            padding: 15px;
        }
        
        .service-name {
            color: #333;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .service-brief {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .service-price-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .review-item {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: #f8f9fa;
        }
        
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="background-overlay"></div>
    <jsp:include page="customer/includes/header.jsp"/>
    
    <main class="main-content">
        <section class="hero-section animate__animated animate__fadeInDown">
            <div class="container">
                <div class="hero-content text-center">
                    <h1 class="hero-title"><i class="fas fa-concierge-bell me-2"></i>Chi Tiết Dịch Vụ</h1>
                    <p class="hero-subtitle">Khám phá chi tiết dịch vụ ${service.name}</p>
                </div>
            </div>
        </section>

        <!-- Error/Success Messages -->
        <div class="container">
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <c:choose>
                        <c:when test="${param.error == 'invalidDate'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Ngày sử dụng không hợp lệ!
                        </c:when>
                        <c:when test="${param.error == 'invalidQuantity'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Số lượng không hợp lệ!
                        </c:when>
                        <c:when test="${param.error == 'pastDate'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Ngày sử dụng phải từ hôm nay trở đi!
                        </c:when>
                        <c:when test="${param.error == 'serviceNotFound'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Dịch vụ không tồn tại!
                        </c:when>
                        <c:when test="${param.error == 'bookingFailed'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Đặt dịch vụ thất bại. Vui lòng thử lại!
                        </c:when>
                        <c:when test="${param.error == 'invalidInput'}">
                            <i class="fas fa-exclamation-triangle me-2"></i>Dữ liệu nhập vào không hợp lệ!
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-exclamation-triangle me-2"></i>Có lỗi xảy ra. Vui lòng thử lại!
                        </c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Đặt dịch vụ thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>

        <!-- Product Detail Section -->
        <section class="service-detail-section">
            <div class="container">
                <div class="product-detail-container">
                    <div class="row">
                        <!-- Product Image -->
                        <div class="col-lg-6">
                            <div class="p-3">
                                <img src="${service.imageUrl}" alt="${service.name}" class="product-image">
                            </div>
                        </div>
                        
                        <!-- Product Information -->
                        <div class="col-lg-6">
                            <div class="product-info">
                                <h1 class="product-title">${service.name}</h1>
                                <p class="product-sku">SKU: SV${service.id}</p>
                                
                                <!-- Price Section -->
                                <div class="price-section">
                                    <span class="current-price" id="displayPrice">
                                        <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND" pattern="#,##0 ¤"/>
                                    </span>
                                </div>
                                
                                <!-- Product Information -->
                                <div class="info-row">
                                    <span class="info-label">Tình trạng</span>
                                    <span class="info-value stock-status">Còn hàng</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Vận chuyển</span>
                                    <span class="info-value shipping-info">Miễn phí giao hàng cho đơn từ 300.000₫<br>Giao hàng trong 2 giờ.</span>
                                </div>
                                
                                <form id="paymentForm" action="servicePayment" method="post">
                                    <input type="hidden" name="serviceId" value="${service.id}">
                                    
                                    <!-- Usage Date -->
                                    <div class="info-row">
                                        <span class="info-label">Ngày sử dụng</span>
                                        <input type="date" class="form-control" id="usageDate" name="usageDate" required style="width: auto;">
                                    </div>
                                    
                                    <!-- Quantity Selector -->
                                    <div class="quantity-selector">
                                        <span class="quantity-label">Số lượng</span>
                                        <div class="quantity-controls">
                                            <button type="button" class="quantity-btn" onclick="decreaseQuantity()">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" class="quantity-input" id="quantity" name="quantity" value="1" min="1" readonly>
                                            <button type="button" class="quantity-btn" onclick="increaseQuantity()">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="action-buttons">
                                        <button type="submit" class="add-to-cart-btn">
                                            <i class="fas fa-credit-card me-2"></i>THANH TOÁN
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Information Tabs -->
                <div class="product-detail-container">
                    <div class="section-tabs">
                        <div class="tab-header">
                            <div class="tab-item active" onclick="showTab('description')">Mô tả</div>
                            <div class="tab-item" onclick="showTab('reviews')">Đánh giá</div>
                        </div>
                        
                        <div id="description-tab" class="tab-content active">
                            <h4>Mô tả dịch vụ</h4>
                            <p>${service.description}</p>
                        </div>
                        

                        
                        <div id="reviews-tab" class="tab-content">
                            <h4>Đánh giá khách hàng</h4>
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach var="review" items="${reviews}">
                                        <div class="review-item">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="fas fa-user-circle fa-2x text-secondary me-3"></i>
                                                <div>
                                                    <div class="fw-bold">Khách hàng ẩn danh</div>
                                                    <div class="text-warning">
                                                        <c:forEach begin="1" end="${review.quality}" var="star">
                                                            <i class="fas fa-star"></i>
                                                        </c:forEach>
                                                        <c:forEach begin="1" end="${5 - review.quality}" var="star">
                                                            <i class="far fa-star"></i>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            <p class="mb-0">${review.comment}</p>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-4">
                                        <i class="fas fa-comments fa-3x mb-3"></i>
                                        <p>Chưa có đánh giá nào cho dịch vụ này.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <!-- Related Services -->
                <c:if test="${not empty relatedServices}">
                    <div class="product-detail-container">
                        <div class="p-4">
                            <h3 class="text-center mb-4"><i class="fas fa-thumbs-up me-2"></i>Dịch vụ tương tự</h3>
                            <div class="row">
                                <c:forEach var="relatedService" items="${relatedServices}">
                                    <div class="col-md-4 mb-4">
                                        <a href="serviceDetail?id=${relatedService.id}" class="text-decoration-none">
                                            <div class="service-card position-relative">
                                                <div class="service-image">
                                                    <img src="${relatedService.imageUrl}" alt="${relatedService.name}">
                                                    <div class="service-price-badge">
                                                        <fmt:formatNumber value="${relatedService.price}" type="number" groupingUsed="true"/> VND
                                                    </div>
                                                </div>
                                                <div class="service-content">
                                                    <h5 class="service-name">${relatedService.name}</h5>
                                                    <p class="service-brief">
                                                        <c:choose>
                                                            <c:when test="${fn:length(relatedService.description) > 50}">
                                                                ${fn:substring(relatedService.description, 0, 50)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${relatedService.description}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </main>
    
    <jsp:include page="customer/includes/footer.jsp"/>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/home-enhanced.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set minimum date to today
            const usageDateInput = document.getElementById('usageDate');
            if (usageDateInput) {
                usageDateInput.min = new Date().toISOString().split('T')[0];
            }
        });

        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            quantityInput.value = currentValue + 1;
            updatePrice();
        }

        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
                updatePrice();
            }
        }

        function updatePrice() {
            const quantity = parseInt(document.getElementById('quantity').value);
            const servicePrice = parseFloat("${service.price}");
            const totalPrice = servicePrice * quantity;
            const priceDisplay = document.getElementById('displayPrice');
            priceDisplay.innerHTML = new Intl.NumberFormat('vi-VN').format(totalPrice) + ' ₫';
        }

        function showTab(tabName) {
            // Hide all tabs
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Remove active class from all tab items
            const tabItems = document.querySelectorAll('.tab-item');
            tabItems.forEach(item => item.classList.remove('active'));
            
            // Show selected tab
            document.getElementById(tabName + '-tab').classList.add('active');
            event.target.classList.add('active');
        }

        // Form validation
        document.getElementById('paymentForm').addEventListener('submit', function(event) {
            const usageDate = document.getElementById('usageDate').value;
            const quantity = document.getElementById('quantity').value;
            
            if (!usageDate) {
                event.preventDefault();
                alert('Vui lòng chọn ngày sử dụng dịch vụ!');
                return;
            }
            
            if (!quantity || quantity < 1) {
                event.preventDefault();
                alert('Vui lòng nhập số lượng hợp lệ!');
                return;
            }
            
            const selectedDate = new Date(usageDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                event.preventDefault();
                alert('Ngày sử dụng phải từ hôm nay trở đi!');
                return;
            }
        });
    </script>
</body>
</html>