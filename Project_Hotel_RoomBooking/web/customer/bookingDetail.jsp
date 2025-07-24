<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Calculate number of nights
    String checkIn = request.getParameter("checkIn");
    String checkOut = request.getParameter("checkOut");
    
    // Parse dates to calculate nights
    if (checkIn != null && checkOut != null) {
        java.time.LocalDate dateIn = java.time.LocalDate.parse(checkIn);
        java.time.LocalDate dateOut = java.time.LocalDate.parse(checkOut);
        long nights = java.time.temporal.ChronoUnit.DAYS.between(dateIn, dateOut);
        request.setAttribute("nights", nights);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Detail</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/booking-detail.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    
    <div class="container">
        <!-- Left side - Booking Form -->
        <div class="booking-form">
            <h2>Thông tin liên hệ</h2>
            <c:if test="${sessionScope.user == null}">
                <div class="error-message">
                    <% 
                        String currentUrl = request.getRequestURL().toString();
                        String queryString = request.getQueryString();
                        String fullUrl = queryString != null ? currentUrl + "?" + queryString : currentUrl;
                    %>
                    Vui lòng <a href="${pageContext.request.contextPath}/login.jsp?redirectUrl=<%=java.net.URLEncoder.encode(fullUrl, "UTF-8")%>">đăng nhập</a> để tiếp tục đặt phòng
                </div>
            </c:if>
            <c:if test="${sessionScope.user != null}">
                <form id="bookingForm" action="${pageContext.request.contextPath}/booking" method="POST">
                    <div class="form-group">
                        <label>Tên đầy đủ</label>
                        <input type="text" name="fullName" value="${sessionScope.user.fullName}" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>E-mail</label>
                        <input type="email" name="email" value="${sessionScope.user.email}" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="tel" name="phone" value="${sessionScope.user.phone}" class="form-control" required>
                    </div>
                    


                    
                    <input type="hidden" name="roomId" value="${roomId}">
                    <input type="hidden" name="checkIn" value="${checkIn}">
                    <input type="hidden" name="checkOut" value="${checkOut}">
                    <input type="hidden" name="nights" value="${nights}">
                    <input type="hidden" name="pricePerNight" value="${pricePerNight}">
                    <input type="hidden" name="totalAmount" id="totalAmountInput" value="0">
                    <input type="hidden" name="promotionId" id="promotionIdInput" value="">
                    
                    <!-- Promotion Selection Section -->
                    <div class="promotion-selection-section">
                        <h4 class="promotion-section-title">
                            <i class="fas fa-gift"></i>
                            Mã khuyến mãi
                        </h4>
                        
                        <c:if test="${not empty validPromotions}">
                            <div class="promotion-input-group">
                                <select id="promotionSelect" name="promotionCode" class="form-control promotion-select">
                                    <option value="" data-percentage="0">Chọn mã khuyến mãi</option>
                                    <c:forEach var="promotion" items="${validPromotions}">
                                        <option value="${promotion.id}" 
                                                data-percentage="${promotion.percentage}" 
                                                data-title="${promotion.title}"
                                                data-description="${promotion.description}">
                                            ${promotion.title} - Giảm ${promotion.percentage}%
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="button" id="applyPromotionBtn" class="btn-apply-promotion">
                                    <i class="fas fa-check"></i>
                                    Áp dụng
                                </button>
                            </div>
                            
                            <!-- Promotion Details Display -->
                            <div id="promotionDetails" class="promotion-details" style="display: none;">
                                <div class="promotion-info">
                                    <div class="promotion-badge">
                                        <span id="promotionPercentage">0</span>% GIẢM GIÁ
                                    </div>
                                    <div class="promotion-text">
                                        <strong id="promotionTitle"></strong>
                                        <p id="promotionDescription"></p>
                                    </div>
                                    <button type="button" id="removePromotionBtn" class="btn-remove-promotion">
                                        <i class="fas fa-times"></i>
                                        Bỏ mã
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Discount Display -->
                            <div id="discountDisplay" class="discount-display" style="display: none;">
                                <div class="discount-item">
                                    <span>Giảm giá:</span>
                                    <span id="discountAmount" class="discount-amount">-0đ</span>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty validPromotions}">
                            <p class="no-promotions">Hiện tại không có mã khuyến mãi nào khả dụng.</p>
                        </c:if>
                    </div>
                    
                    <!-- Service Selection Section -->
                    <div class="service-selection-section">
                        <h4 class="service-section-title">
                            <i class="fas fa-concierge-bell"></i>
                            Dịch vụ bổ sung
                        </h4>
                        
                        <c:if test="${not empty availableServices}">
                            <div class="service-list">
                                <c:forEach var="service" items="${availableServices}">
                                    <div class="service-item">
                                        <label class="service-checkbox-label">
                                            <input type="checkbox" 
                                                   class="service-checkbox" 
                                                   name="selectedServices" 
                                                   value="${service.id}"
                                                   data-price="${service.price}"
                                                   data-name="${service.name}">
                                            <div class="service-info">
                                                <div class="service-details">
                                                    <span class="service-name">${service.name}</span>
                                                    <span class="service-type">${service.typeName}</span>
                                                    <c:if test="${not empty service.description}">
                                                        <span class="service-description">${service.description}</span>
                                                    </c:if>
                                                </div>
                                                <div class="service-price">
                                                    <fmt:formatNumber value="${service.price}" pattern="#,###"/>đ
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Selected Services Summary -->
                            <div id="selectedServicesDisplay" class="selected-services-display" style="display: none;">
                                <h5>Dịch vụ đã chọn:</h5>
                                <div id="selectedServicesList" class="selected-services-list"></div>
                                <div class="service-total">
                                    <span>Tổng tiền dịch vụ:</span>
                                    <span id="serviceTotalAmount" class="service-total-amount">0đ</span>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty availableServices}">
                            <p class="no-services">Hiện tại không có dịch vụ bổ sung nào.</p>
                        </c:if>
                    </div>
                    <!-- Promotion Section -->
                        <c:if test="${not empty currentPromotion}">
                            <div class="promotion-section mb-3">
                                <div class="promotion-card">
                                    <div class="promotion-header">
                                        <i class="fas fa-gift promotion-icon"></i>
                                        <h4 class="promotion-title">Khuyến mãi</h4>
                                    </div>
                                    <div class="promotion-content">
                                        <h5 class="promotion-name">${currentPromotion.title}</h5>
                                        <div class="promotion-discount">
                                            <span class="discount-percentage">${currentPromotion.percentage}%</span>
                                            <span class="discount-text">GIẢM GIÁ</span>
                                        </div>
                                        <p class="promotion-description">${currentPromotion.description}</p>
                                        <div class="promotion-validity">
                                            <i class="fas fa-calendar-alt"></i>
                                            <span>Có hiệu lực: <fmt:formatDate value="${currentPromotion.startAt}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${currentPromotion.endAt}" pattern="dd/MM/yyyy" /></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                    <button type="submit" class="payment-button">Xác nhận và Thanh toán</button>

                </form>
            </c:if>
        </div>

        <!-- Right side - Room Details -->
        <div class="room-details">
            <img src="${imageUrl}" alt="Room Image" class="room-image">
            <div class="room-info">
                <h3>Phòng ${roomNumber}</h3>
                <p><i class="fas fa-user"></i> Sức chứa: ${maxGuests} người</p>
                <p><i class="fas fa-bed"></i> Loại phòng: ${roomType}</p>
                <p><i class="fas fa-utensils"></i> Bao gồm bữa sáng</p>
                <p><i class="fas fa-building"></i> Tầng: ${floor}</p>
            </div>

            <div class="price-details">
                <h3>Chi tiết giá</h3>
                <p>${nights} đêm x <fmt:formatNumber value="${pricePerNight}" pattern="#,###"/>đ/đêm</p>
                <div class="total-price" id="totalPrice">
                    Tổng cộng: <fmt:formatNumber value="${pricePerNight * nights}" pattern="#,###"/>đ
                </div>
            </div>

            <div class="booking-policy">
                <h4>Chính sách hủy và đổi lịch</h4>
                <p>Đặt phòng này không được hoàn tiền.</p>
                <p>Không thể thay đổi lịch</p>
            </div>
        </div>
    </div>
    <script>
        let basePrice = 0;
        let currentDiscount = 0;
        let appliedPromotionId = null;
        let selectedServices = [];
        let totalServicePrice = 0;
        
        document.addEventListener('DOMContentLoaded', function() {
            var stayNights = parseInt('${nights}', 10);
            var pricePerNight = parseInt('${pricePerNight}', 10);
            basePrice = pricePerNight * stayNights;
            
            updateTotalPrice();
            
            // Promotion selection handlers
            const promotionSelect = document.getElementById('promotionSelect');
            const applyBtn = document.getElementById('applyPromotionBtn');
            const removeBtn = document.getElementById('removePromotionBtn');
            
            if (applyBtn) {
                applyBtn.addEventListener('click', function() {
                    const selectedOption = promotionSelect.options[promotionSelect.selectedIndex];
                    if (selectedOption.value) {
                        applyPromotion(selectedOption);
                    } else {
                        Swal.fire({
                            icon: 'warning',
                            title: 'Chưa chọn mã khuyến mãi',
                            text: 'Vui lòng chọn một mã khuyến mãi để áp dụng.'
                        });
                    }
                });
            }
            
            if (removeBtn) {
                removeBtn.addEventListener('click', function() {
                    removePromotion();
                });
            }
            
            // Service selection handlers
            const serviceCheckboxes = document.querySelectorAll('.service-checkbox');
            serviceCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    updateSelectedServices();
                });
            });
        });
        
        function applyPromotion(selectedOption) {
            const promotionId = selectedOption.value;
            const percentage = parseFloat(selectedOption.dataset.percentage);
            const title = selectedOption.dataset.title;
            const description = selectedOption.dataset.description;
            
            // Calculate discount
            currentDiscount = Math.round(basePrice * (percentage / 100));
            appliedPromotionId = promotionId;
            
            // Update UI
            document.getElementById('promotionPercentage').textContent = percentage;
            document.getElementById('promotionTitle').textContent = title;
            document.getElementById('promotionDescription').textContent = description;
            document.getElementById('discountAmount').textContent = '-' + new Intl.NumberFormat('vi-VN').format(currentDiscount) + 'đ';
            
            // Show promotion details and discount
            document.getElementById('promotionDetails').style.display = 'block';
            document.getElementById('discountDisplay').style.display = 'block';
            
            // Hide select and apply button
            document.querySelector('.promotion-input-group').style.display = 'none';
            
            // Update hidden input
            document.getElementById('promotionIdInput').value = promotionId;
            
            // Update total price
            updateTotalPrice();
            
            Swal.fire({
                icon: 'success',
                title: 'Áp dụng thành công!',
                text: "Bạn đã được giảm " + new Intl.NumberFormat('vi-VN').format(currentDiscount) + "đ",
                timer: 2000,
                showConfirmButton: false
            });
        }
        
        function removePromotion() {
            currentDiscount = 0;
            appliedPromotionId = null;
            
            // Hide promotion details and discount
            document.getElementById('promotionDetails').style.display = 'none';
            document.getElementById('discountDisplay').style.display = 'none';
            
            // Show select and apply button
            document.querySelector('.promotion-input-group').style.display = 'flex';
            
            // Reset select
            document.getElementById('promotionSelect').selectedIndex = 0;
            
            // Clear hidden input
            document.getElementById('promotionIdInput').value = '';
            
            // Update total price
            updateTotalPrice();
        }
        
        function updateSelectedServices() {
            const checkboxes = document.querySelectorAll('.service-checkbox:checked');
            selectedServices = [];
            totalServicePrice = 0;
            
            checkboxes.forEach(checkbox => {
                const serviceId = checkbox.value;
                const serviceName = checkbox.dataset.name;
                const servicePrice = parseFloat(checkbox.dataset.price);
                
                selectedServices.push({
                    id: serviceId,
                    name: serviceName,
                    price: servicePrice
                });
                
                totalServicePrice += servicePrice;
            });
            
            updateSelectedServicesDisplay();
            updateTotalPrice();
        }
        
        function updateSelectedServicesDisplay() {
            const display = document.getElementById('selectedServicesDisplay');
            const list = document.getElementById('selectedServicesList');
            const totalAmount = document.getElementById('serviceTotalAmount');
            
            if (selectedServices.length > 0) {
                display.style.display = 'block';
                
                let listHTML = '';
                selectedServices.forEach(service => {
                    listHTML += '<div class="selected-service-item">';
                    listHTML += '<span class="selected-service-name">' + service.name + '</span>';
                    listHTML += '<span class="selected-service-price">' + new Intl.NumberFormat('vi-VN').format(service.price) + 'đ</span>';
                    listHTML += '</div>';
                });
                
                list.innerHTML = listHTML;
                totalAmount.textContent = new Intl.NumberFormat('vi-VN').format(totalServicePrice) + 'đ';
            } else {
                display.style.display = 'none';
            }
        }
        
        function updateTotalPrice() {
            const roomPrice = basePrice - currentDiscount;
            const finalPrice = roomPrice + totalServicePrice;
            
            let priceHTML = '';
            
            // Hiển thị giá phòng
            if (currentDiscount > 0) {
                priceHTML += '<div class="price-breakdown">';
                priceHTML += '<div class="price-item"><span>Giá phòng gốc:</span><span>' + new Intl.NumberFormat('vi-VN').format(basePrice) + 'đ</span></div>';
                priceHTML += '<div class="price-item discount"><span>Giảm giá:</span><span>-' + new Intl.NumberFormat('vi-VN').format(currentDiscount) + 'đ</span></div>';
                priceHTML += '<div class="price-item"><span>Giá phòng sau giảm:</span><span>' + new Intl.NumberFormat('vi-VN').format(roomPrice) + 'đ</span></div>';
            } else {
                priceHTML += '<div class="price-breakdown">';
                priceHTML += '<div class="price-item"><span>Giá phòng:</span><span>' + new Intl.NumberFormat('vi-VN').format(basePrice) + 'đ</span></div>';
            }
            
            // Hiển thị giá dịch vụ nếu có
            if (totalServicePrice > 0) {
                priceHTML += '<div class="price-item"><span>Dịch vụ bổ sung:</span><span>' + new Intl.NumberFormat('vi-VN').format(totalServicePrice) + 'đ</span></div>';
            }
            
            priceHTML += '<div class="price-item total"><span>Tổng cộng:</span><span>' + new Intl.NumberFormat('vi-VN').format(finalPrice) + 'đ</span></div>';
            priceHTML += '</div>';
            
            document.getElementById('totalPrice').innerHTML = priceHTML;
            document.getElementById('totalAmountInput').value = Math.round(finalPrice);
        }
    </script>

</body>
</html>