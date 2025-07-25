<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng - ${room.roomTypeName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room-detail.css">
    <meta name="description" content="Chi tiết phòng ${room.roomTypeName} - Khách sạn cao cấp với đầy đủ tiện nghi">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="customer/includes/header.jsp" />

    <!-- Room Detail Section -->
    <div class="room-detail-section">
        <div class="container">
            <!-- Top Row: Room Image and Booking Form -->
            <div class="row mb-4 container-fluid">
                <!-- Room Images -->
                <div class="col-lg-7 col-md-12">
                    <div class="room-detail-card">
                        <div class="carousel-container">
                            <div id="roomImages" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
                                <div class="carousel-inner">
                                    <div class="carousel-item active">
                                        <img src="${room.imageUrl}" class="d-block w-100" alt="${room.roomTypeName}" loading="lazy">
                                    </div>
                                </div>
                                <button class="carousel-control-prev" type="button" data-bs-target="#roomImages" data-bs-slide="prev" aria-label="Ảnh trước">
                                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#roomImages" data-bs-slide="next" aria-label="Ảnh tiếp theo">
                                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Booking Section -->
                <div class="col-lg-5 col-md-12">
                    <div class="booking-section">
                        <h3 class="booking-title">Đặt phòng ngay</h3>
                        <c:if test="${param.error eq 'unavailable'}">                            
                            <div class="alert alert-danger mb-3">
                                Rất tiếc, phòng này đã được đặt trong khoảng thời gian bạn chọn. Vui lòng chọn phòng khác hoặc thay đổi ngày đặt.
                            </div>
                        </c:if>
                        <c:if test="${param.error eq 'invalid'}">                            
                            <div class="alert alert-danger mb-3">
                                Vui lòng chọn ngày nhận phòng và trả phòng khác.
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/booking-confirmation" method="POST" class="booking-form" novalidate onsubmit="return debugForm(this)">
                            <input type="hidden" name="roomId" value="${room.id}">
                            <input type="hidden" name="roomNumber" value="${room.roomNumber}">
                            <input type="hidden" name="roomType" value="${room.roomTypeName}">
                            <input type="hidden" name="maxGuests" value="${room.capacity}">
                            <input type="hidden" name="floor" value="${room.floor}">
                            <input type="hidden" name="pricePerNight" value="${room.roomPrice}">
                            <input type="hidden" name="imageUrl" value="${room.imageUrl}">
                            <input type="hidden" name="discountCodeSelected" id="discountCodeSelected" value="">
                            <input type="hidden" name="type" value="room">
                            <input type="hidden" name="id" value="${room.id}">
                            <input type="hidden" name="amount" value="${room.roomPrice}">
                            <div class="form-group mb-3">
                                <label for="checkIn" class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn" value="${param.checkIn}" required>
                            </div>
                            <div class="form-group mb-3">
                                <label for="checkOut" class="form-label">Ngày trả phòng</label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut" value="${param.checkOut}" required>
                            </div>
                            <div class="form-group mb-3">
                                <label for="discountCode" class="form-label">Mã giảm giá</label>
                                <div class="discount-container">
                                    <select class="form-select" id="discountCode" name="discountCode">
                                        <option value="">Chọn mã giảm giá (tùy chọn)</option>
                                        <!-- Debug: Check if activePromotions exists -->
                                        <c:if test="${empty activePromotions}">
                                            <option value="" disabled>Không có mã giảm giá nào</option>
                                        </c:if>
                                        <c:forEach var="promotion" items="${activePromotions}">
                                            <option value="${promotion.title}" 
                                                    data-discount="${promotion.percentage}" 
                                                    data-type="percent"
                                                    data-description="${promotion.description}">
                                                ${promotion.title} - Giảm ${promotion.percentage}%
                                                <c:if test="${not empty promotion.description}"> - ${promotion.description}</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="discount-info" id="discountInfo" style="display: none;">
                                        <small class="text-success">
                                            <i class="fas fa-check-circle me-1"></i>
                                            <span id="discountDescription"></span>
                                        </small>
                                    </div>
                                    
                                    <!-- Availability Status -->
                                    <div class="availability-status mt-3" id="availabilityStatus" style="display: none;">
                                        <div class="alert mb-0" id="availabilityMessage" role="alert">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <span id="availabilityText"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group mb-3">
                                <div class="total-price-container">
                                    <div class="price-breakdown">
                                        <div class="price-row">
                                            <span class="price-label">Số đêm:</span>
                                            <span class="price-value" id="totalNights">0 đêm</span>
                                        </div>
                                        <div class="price-row">
                                            <span class="price-label">Giá mỗi đêm:</span>
                                            <span class="price-value" id="pricePerNightDisplay"><fmt:formatNumber value="${room.roomPrice}" pattern="#,###" /> VND</span>
                                        </div>
                                        <div class="price-row" id="subtotalRow" style="display: none;">
                                            <span class="price-label">Tạm tính:</span>
                                            <span class="price-value" id="subtotalAmount">0 VND</span>
                                        </div>
                                        <div class="price-row discount-row" id="discountRow" style="display: none;">
                                            <span class="price-label">Mã giảm giá:</span>
                                            <span class="price-value discount-amount" id="discountAmount">-0 VND</span>
                                        </div>
                                        <div class="price-row total-row">
                                            <span class="price-label"><strong>Tổng tiền:</strong></span>
                                            <span class="price-value total-amount" id="totalAmount">0 VND</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn-book">Đặt phòng ngay</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Middle Row: Room Info and Amenities -->
            <div class="row mb-4">

                <!-- Room Details -->
                <div class="col-lg-6 col-md-12">
                    <div class="room-info-section">
                        <h1 class="room-title">Phòng ${room.roomNumber}</h1>
                        
                        <div class="room-details">
                            <div class="detail-item">
                                <i class="fas fa-users" aria-hidden="true"></i>
                                <span>Sức chứa: ${room.capacity} người</span>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-bed" aria-hidden="true"></i>
                                <span>Loại phòng: ${room.roomTypeName}</span>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-dollar-sign" aria-hidden="true"></i>
                                <span>Giá: <fmt:formatNumber value="${room.roomPrice}" pattern="#,###" />đ/đêm</span>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-building" aria-hidden="true"></i>
                                <span>Tầng: ${room.floor}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Amenities Section -->
                <div class="col-lg-6 col-md-12">
                    <div class="amenities-section">
                        <h2 class="section-title">Tiện nghi cao cấp</h2>
                        <div class="amenities-grid">
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-wifi" aria-hidden="true"></i>
                                </div>
                                <span>Wifi miễn phí</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-tv" aria-hidden="true"></i>
                                </div>
                                <span>Smart TV</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-snowflake" aria-hidden="true"></i>
                                </div>
                                <span>Điều hòa nhiệt độ</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-bath" aria-hidden="true"></i>
                                </div>
                                <span>Phòng tắm riêng</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-coffee" aria-hidden="true"></i>
                                </div>
                                <span>Mini bar & Cà phê</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-concierge-bell" aria-hidden="true"></i>
                                </div>
                                <span>Dịch vụ phòng 24/7</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-bed" aria-hidden="true"></i>
                                </div>
                                <span>Nệm cao cấp</span>
                            </div>
                            <div class="amenity-item">
                                <div class="amenity-icon">
                                    <i class="fas fa-door-closed" aria-hidden="true"></i>
                                </div>
                                <span>Két sắt an toàn</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Row: Room Description -->
            <div class="row container-fluid">
                <div class="col-12">
                    <div class="room-description">
                        <h2 class="section-title">Mô tả phòng</h2>
                        <p class="description-text">${room.description}</p> <!-- Tuấn: dùng thẻ C để mở > -->
                    </div>
                </div>
            </div>
    <!-- Include Footer -->
    <jsp:include page="customer/includes/footer.jsp" />

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/room-detail.js"></script>
    
    <script>
                 // script để tính toán tổng tiền
         document.addEventListener('DOMContentLoaded', function() {
             const checkInInput = document.getElementById('checkIn');
             const checkOutInput = document.getElementById('checkOut');
             const discountSelect = document.getElementById('discountCode');
             const totalNightsElement = document.getElementById('totalNights');
             const totalAmountElement = document.getElementById('totalAmount');
             const subtotalElement = document.getElementById('subtotalAmount');
             const discountAmountElement = document.getElementById('discountAmount');
             const discountInfo = document.getElementById('discountInfo');
             const discountDescription = document.getElementById('discountDescription');
             const subtotalRow = document.getElementById('subtotalRow');
             const discountRow = document.getElementById('discountRow');
             const pricePerNight = parseFloat('${room.roomPrice}'); // Get price from server
             
             // Debug: Check if elements exist
             console.log('Form elements check:');
             console.log('checkInInput:', checkInInput);
             console.log('checkOutInput:', checkOutInput);
             console.log('Room price:', pricePerNight);
             
             if (!checkInInput || !checkOutInput) {
                 console.error('Critical form elements not found!');
                 return;
             }
            
            // Set minimum dates to today
            const today = new Date().toISOString().split('T')[0];
            checkInInput.min = today;
            checkOutInput.min = today;
            
                         // Function to calculate total price
             function calculateTotal() {
                 const checkInDate = new Date(checkInInput.value);
                 const checkOutDate = new Date(checkOutInput.value);
                 
                 // Reset if no dates selected
                 if (!checkInInput.value || !checkOutInput.value) {
                     totalNightsElement.textContent = '0 đêm';
                     totalAmountElement.textContent = '0 VND';
                     hideDiscountRows();
                     return;
                 }
                 
                 // Calculate number of nights
                 const timeDifference = checkOutDate.getTime() - checkInDate.getTime();
                 const nights = Math.ceil(timeDifference / (1000 * 3600 * 24));
                 
                 // Validate dates
                 if (nights <= 0) {
                     totalNightsElement.textContent = '0 đêm';
                     totalAmountElement.textContent = '0 VND';
                     hideDiscountRows();
                     return;
                 }
                 
                 // Calculate subtotal
                 const subtotal = nights * pricePerNight;
                 
                 // Get discount information
                 const selectedOption = discountSelect.options[discountSelect.selectedIndex];
                 let discountAmount = 0;
                 let finalTotal = subtotal;
                 
                 if (selectedOption.value && selectedOption.dataset.discount) {
                     const discountValue = parseFloat(selectedOption.dataset.discount);
                     const discountType = selectedOption.dataset.type || 'percent'; // Default to percent from database
                     
                     // All promotions from database are percentage-based
                     if (discountType === 'percent') {
                         discountAmount = (subtotal * discountValue) / 100;
                     } else {
                         discountAmount = discountValue;
                     }
                     
                     // Ensure discount doesn't exceed subtotal
                     discountAmount = Math.min(discountAmount, subtotal);
                     finalTotal = subtotal - discountAmount;
                     showDiscountRows(subtotal, discountAmount);
                 } else {
                     hideDiscountRows();
                 }
                 
                 // Add animation class
                 totalNightsElement.classList.add('updating');
                 totalAmountElement.classList.add('updating');
                 if (discountAmount > 0) {
                     subtotalElement.classList.add('updating');
                     discountAmountElement.classList.add('updating');
                 }
                 
                 // Update display with animation
                 setTimeout(() => {
                     totalNightsElement.textContent = nights + ' đêm';
                     totalAmountElement.textContent = new Intl.NumberFormat('vi-VN').format(finalTotal) + ' VND';
                     
                     if (discountAmount > 0) {
                         subtotalElement.textContent = new Intl.NumberFormat('vi-VN').format(subtotal) + ' VND';
                         discountAmountElement.textContent = '-' + new Intl.NumberFormat('vi-VN').format(discountAmount) + ' VND';
                     }
                     
                     // Remove animation class
                     setTimeout(() => {
                         totalNightsElement.classList.remove('updating');
                         totalAmountElement.classList.remove('updating');
                         if (discountAmount > 0) {
                             subtotalElement.classList.remove('updating');
                             discountAmountElement.classList.remove('updating');
                         }
                     }, 300);
                 }, 100);
             }
             
             // Function to show discount rows
             function showDiscountRows(subtotal, discountAmount) {
                 subtotalRow.style.display = 'flex';
                 discountRow.style.display = 'flex';
             }
             
             // Function to hide discount rows
             function hideDiscountRows() {
                 subtotalRow.style.display = 'none';
                 discountRow.style.display = 'none';
             }
             
             // Function to update discount info
             function updateDiscountInfo() {
                 const selectedOption = discountSelect.options[discountSelect.selectedIndex];
                 
                 if (selectedOption.value) {
                     const discountText = selectedOption.textContent;
                     const description = selectedOption.dataset.description;
                     
                     if (description && description.trim() !== '') {
                         discountDescription.textContent = 'Áp dụng: ' + discountText + ' - ' + description;
                     } else {
                         discountDescription.textContent = 'Áp dụng: ' + discountText;
                     }
                     
                     discountInfo.style.display = 'block';
                     discountInfo.className = 'discount-info text-success';
                 } else {
                     discountInfo.style.display = 'none';
                 }
             }
             
             // Function to calculate nights
             function calculateNights() {
                 if (!checkInInput.value || !checkOutInput.value) return 0;
                 const checkInDate = new Date(checkInInput.value);
                 const checkOutDate = new Date(checkOutInput.value);
                 const timeDifference = checkOutDate.getTime() - checkInDate.getTime();
                 const nights = Math.ceil(timeDifference / (1000 * 3600 * 24));
                 return nights > 0 ? nights : 0;
             }
             
             // Function to check room availability
             async function checkAvailability() {
                 const availabilityStatus = document.getElementById('availabilityStatus');
                 const availabilityMessage = document.getElementById('availabilityMessage');
                 const availabilityText = document.getElementById('availabilityText');
                 const bookButton = document.querySelector('.btn-book');
                 
                 // Get room ID
                 const roomIdElement = document.querySelector('input[name="roomId"]');
                 if (!roomIdElement) {
                     console.error('Room ID input not found');
                     return;
                 }
                 const roomId = roomIdElement.value;
                 
                 // Hide availability status if dates are not selected
                 if (!checkInInput.value || !checkOutInput.value || !roomId) {
                     console.log('Skipping availability check - missing values:', {
                         checkIn: checkInInput.value,
                         checkOut: checkOutInput.value,
                         roomId: roomId
                     });
                     availabilityStatus.style.display = 'none';
                     if (bookButton) bookButton.disabled = false;
                     return;
                 }
                 
                 console.log('=== AVAILABILITY CHECK START ===');
                 console.log('Checking availability for:', {
                     roomId: roomId,
                     checkIn: checkInInput.value,
                     checkOut: checkOutInput.value
                 });
                 
                 // Validate all values are present
                 if (!roomId || roomId.trim() === '') {
                     console.error('Room ID is empty:', roomId);
                     return;
                 }
                 if (!checkInInput.value || checkInInput.value.trim() === '') {
                     console.error('Check-in date is empty:', checkInInput.value);
                     return;
                 }
                 if (!checkOutInput.value || checkOutInput.value.trim() === '') {
                     console.error('Check-out date is empty:', checkOutInput.value);
                     return;
                 }
                 
                 // Show loading state
                 availabilityStatus.style.display = 'block';
                 availabilityMessage.className = 'alert alert-info mb-0';
                 availabilityText.textContent = 'Đang kiểm tra tình trạng phòng...';
                 bookButton.disabled = true;
                 
                 try {
                     const contextPath = '${pageContext.request.contextPath}';
                     console.log('Context path from JSP:', contextPath);
                     
                     // Force use Project_Hotel_RoomBooking for now
                     const finalContextPath = '/Project_Hotel_RoomBooking';
                     console.log('Using hardcoded context path:', finalContextPath);
                     
                     // Store values in local variables to avoid scope issues
                     const checkInValue = checkInInput.value;
                     const checkOutValue = checkOutInput.value;
                     const roomIdValue = roomId;
                     
                     console.log('Building URL with values:');
                     console.log('  roomId:', roomIdValue);
                     console.log('  checkIn value:', checkInValue);
                     console.log('  checkOut value:', checkOutValue);
                     
                     // Final validation before making request
                     if (!roomIdValue || !checkInValue || !checkOutValue) {
                         console.error('ERROR: Empty values detected before API call!');
                         console.log('roomIdValue:', roomIdValue);
                         console.log('checkInValue:', checkInValue);
                         console.log('checkOutValue:', checkOutValue);
                         return;
                     }
                     
                     // Build URL step by step to debug
                     const baseUrl = finalContextPath + '/api/check-availability-simple';
                     const params = '?roomId=' + roomIdValue + '&checkIn=' + checkInValue + '&checkOut=' + checkOutValue;
                     const apiUrl = baseUrl + params;
                     
                     console.log('URL building steps:');
                     console.log('  baseUrl:', baseUrl);
                     console.log('  params:', params);
                     console.log('  Final API URL:', apiUrl);
                     
                     console.log('Making fetch request to:', apiUrl);
                     const response = await fetch(apiUrl);
                     console.log('Response status:', response.status);
                     console.log('Response headers:', response.headers);
                     
                     if (!response.ok) {
                         console.error('Response not OK. Status:', response.status);
                         throw new Error(`HTTP error! status: ${response.status}`);
                     }
                     
                     const responseText = await response.text();
                     console.log('Response text:', responseText);
                     
                     const data = JSON.parse(responseText);
                     console.log('Parsed data:', data);
                     
                     if (data.available) {
                         availabilityMessage.className = 'alert alert-success mb-0';
                         availabilityText.textContent = data.message;
                         bookButton.disabled = false;
                     } else {
                         availabilityMessage.className = 'alert alert-danger mb-0';
                         availabilityText.textContent = data.message;
                         bookButton.disabled = true;
                     }
                     
                 } catch (error) {
                     console.error('Error checking availability:', error);
                     availabilityMessage.className = 'alert alert-danger mb-0';
                     availabilityText.textContent = 'Lỗi khi kiểm tra tình trạng phòng. Vui lòng thử lại.';
                     bookButton.disabled = true;
                 }
             }
            
            // Update checkout min date when checkin changes
            checkInInput.addEventListener('change', function() {
                console.log('Check-in changed to:', this.value);
                const checkInDate = new Date(this.value);
                const nextDay = new Date(checkInDate);
                nextDay.setDate(nextDay.getDate() + 1);
                checkOutInput.min = nextDay.toISOString().split('T')[0];
                
                // Reset checkout if it's before new min date
                if (checkOutInput.value && new Date(checkOutInput.value) <= checkInDate) {
                    checkOutInput.value = '';
                }
                
                calculateTotal();
                // Only check availability if both dates are selected
                if (this.value && checkOutInput.value) {
                    setTimeout(checkAvailability, 100);
                }
            });
            
                         // Calculate when checkout date changes
             checkOutInput.addEventListener('change', function() {
                 console.log('Check-out changed to:', this.value);
                 calculateTotal();
                 // Only check availability if both dates are selected
                 if (checkInInput.value && this.value) {
                     setTimeout(checkAvailability, 100);
                 }
             });
             
             // Handle discount code selection
             discountSelect.addEventListener('change', function() {
                 updateDiscountInfo();
                 calculateTotal();
                 // Update hidden input for form submission
                 document.getElementById('discountCodeSelected').value = this.value;
             });
             
                      // Initial calculation if dates are already set
         calculateTotal();
         updateDiscountInfo();
         
         // Add manual test function for debugging
         window.testAvailability = function() {
             console.log('Manual test triggered');
             checkAvailability();
         };
         
         console.log('Script loaded. You can test with: testAvailability()');
    });
    
    // Debug function for form submission
    function debugForm(form) {
        console.log('=== FORM SUBMISSION DEBUG ===');
        console.log('Action:', form.action);
        console.log('Method:', form.method);
        
        // Check required fields
        const checkIn = form.checkIn.value;
        const checkOut = form.checkOut.value;
        
        console.log('Check-in:', checkIn);
        console.log('Check-out:', checkOut);
        console.log('Room ID:', form.roomId.value);
        console.log('Price per night:', form.pricePerNight.value);
        console.log('Discount code:', form.discountCodeSelected.value);
        
        if (!checkIn || !checkOut) {
            alert('Vui lòng chọn ngày nhận phòng và trả phòng!');
            return false;
        }
        
        if (new Date(checkOut) <= new Date(checkIn)) {
            alert('Ngày trả phòng phải sau ngày nhận phòng!');
            return false;
        }
        
        // Check if book button is disabled (room not available)
        const bookButton = document.querySelector('.btn-book');
        if (bookButton.disabled) {
            alert('Phòng không có sẵn trong thời gian này. Vui lòng chọn ngày khác!');
            return false;
        }
        
        console.log('✓ Form validation passed, submitting...');
        return true;
    }
    </script>
</body>
</html>
