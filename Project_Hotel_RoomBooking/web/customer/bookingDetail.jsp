<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Calculate number of nights - use parameter if available, otherwise calculate
    String nightsParam = request.getParameter("nights");
    long nights = 0;
    
    if (nightsParam != null && !nightsParam.isEmpty()) {
        // Use nights from parameter (calculated in servlet)
        nights = Long.parseLong(nightsParam);
    } else {
        // Fallback: calculate from dates
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        
        if (checkIn != null && checkOut != null) {
            java.time.LocalDate dateIn = java.time.LocalDate.parse(checkIn);
            java.time.LocalDate dateOut = java.time.LocalDate.parse(checkOut);
            nights = java.time.temporal.ChronoUnit.DAYS.between(dateIn, dateOut);
        }
    }
    
    request.setAttribute("nights", nights);
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
                    


                    
                    <input type="hidden" name="roomId" value="${param.roomId}">
                    <input type="hidden" name="checkIn" value="${param.checkIn}">
                    <input type="hidden" name="checkOut" value="${param.checkOut}">
                    <input type="hidden" name="nights" value="${param.nights}">
                    <input type="hidden" name="pricePerNight" value="${param.pricePerNight}">
                    <input type="hidden" name="totalAmount" id="totalAmountInput" value="0">
                    
                    <button type="submit" class="payment-button">Xác nhận và Thanh toán</button>

                </form>
            </c:if>
        </div>

        <!-- Right side - Room Details -->
        <div class="room-details">
            <img src="${param.imageUrl}" alt="Room Image" class="room-image">
            <div class="room-info">
                <h3>Phòng ${param.roomNumber}</h3>
                <p><i class="fas fa-user"></i> Sức chứa: ${param.maxGuests} người</p>
                <p><i class="fas fa-bed"></i> Loại phòng: ${param.roomType}</p>
                <p><i class="fas fa-utensils"></i> Bao gồm bữa sáng</p>
                <p><i class="fas fa-building"></i> Tầng: ${param.floor}</p>
            </div>

            <div class="price-details">
                <h3>Chi tiết giá</h3>
                <p>${param.nights} đêm x <fmt:formatNumber value="${param.pricePerNight}" pattern="#,###"/>đ/đêm</p>
                
                <!-- Subtotal -->
                <div class="price-row">
                    <span>Tạm tính:</span>
                    <span><fmt:formatNumber value="${param.originalTotal}" pattern="#,###"/>đ</span>
                </div>
                
                <!-- Discount section (if applicable) -->
                <c:if test="${not empty param.discountCode and param.discountAmount > 0}">
                    <div class="price-row discount-row">
                        <span>Mã giảm giá (${param.discountCode} - ${param.discountPercentage}%):</span>
                        <span class="discount-amount">-<fmt:formatNumber value="${param.discountAmount}" pattern="#,###"/>đ</span>
                    </div>
                </c:if>
                
                <!-- Total -->
                <div class="total-price" id="totalPrice">
                    Tổng cộng: <fmt:formatNumber value="${param.finalTotal}" pattern="#,###"/>đ
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
        document.addEventListener('DOMContentLoaded', function() {
            // Use the final total that already includes discount calculation
            var finalTotal = parseFloat('${param.finalTotal}' || '0');
            
            // Update total amount input for form submission
            document.getElementById('totalAmountInput').value = finalTotal;
            
            // Update display (already handled by JSP formatting, but ensure consistency)
            if (finalTotal > 0) {
                document.getElementById('totalPrice').textContent = 'Tổng cộng: ' + new Intl.NumberFormat('vi-VN').format(finalTotal) + 'đ';
            }
        });
    </script>

</body>
</html>