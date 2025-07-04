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
</head>
<body>
    
    <div class="container">
        <!-- Left side - Booking Form -->
        <div class="booking-form">
            <h2>Thông tin liên hệ</h2>
            <c:if test="${sessionScope.user == null}">
                <div class="error-message">
                    Vui lòng <a href="login.jsp">đăng nhập</a> để tiếp tục đặt phòng
                </div>
            </c:if>
            <c:if test="${sessionScope.user != null}">
                <form action="BookingServlet" method="POST">
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
                    

                    <div class="requirements">
                        <h3>Bạn yêu cầu nào không?</h3>
                        <div class="checkbox-group">
                            <input type="checkbox" id="noSmoke" name="requirements" value="noSmoke">
                            <label for="noSmoke">Phòng không hút thuốc</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" id="highFloor" name="requirements" value="highFloor">
                            <label for="highFloor">Tầng lầu</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" id="earlyCheckin" name="requirements" value="earlyCheckin">
                            <label for="earlyCheckin">Giờ nhận phòng</label>
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" id="lateCheckout" name="requirements" value="lateCheckout">
                            <label for="lateCheckout">Giờ trả phòng</label>
                        </div>
                    </div>
                    
                    <input type="hidden" name="roomId" value="${room.id}">
                    <input type="hidden" name="checkIn" value="${param.checkIn}">
                    <input type="hidden" name="checkOut" value="${param.checkOut}">
                    <input type="hidden" name="nights" value="${param.nights}">
                    <button type="submit" class="submit-btn">Xác nhận đặt phòng</button>
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
                <p>${nights} đêm x <fmt:formatNumber value="${param.pricePerNight}" pattern="#,###"/>đ/đêm</p>
                <div class="total-price" id="totalPrice">
                    Tổng cộng: <fmt:formatNumber value="${param.pricePerNight * nights}" pattern="#,###"/>đ
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
            var stayNights = parseInt('${nights}', 10);
            var pricePerNight = parseInt('${param.pricePerNight}', 10);
            var totalPrice = pricePerNight * stayNights;
            
            function formatPrice(price) {
                return new Intl.NumberFormat('vi-VN').format(price);
            }
            
            document.getElementById('totalPrice').textContent = 'Tổng cộng: ' + formatPrice(totalPrice) + 'đ';
        });
    </script>
</body>
</html>