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
    <style>
        .services-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            font-size: 0.9em;
        }
        .checkbox-group {
            margin-bottom: 5px;
        }
        .checkbox-group label {
            font-size: 0.9em;
            color: #333;
        }
        .requirements h3 {
            margin-bottom: 15px;
            font-size: 1.1em;
            color: #2c3e50;
        }
    </style>
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
                <form id="bookingForm" onsubmit="submitBooking(event)">
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
                        <h3>Bạn có muốn sử dụng thêm dịch vụ gì không?</h3>
                        <jsp:useBean id="serviceDao" class="dao.ServiceDao" />
                        <div class="services-grid">
                            <c:forEach var="service" items="${serviceDao.allServices}">
                                <div class="checkbox-group">
                                    <input type="checkbox" id="service_${service.id}" name="selectedServices" value="${service.id}" data-price="${service.servicePrice}" onchange="updateTotalPrice()">
                                    <label for="service_${service.id}">
                                        ${service.serviceName} - <fmt:formatNumber value="${service.servicePrice}" pattern="#,###"/>đ
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <input type="hidden" name="roomId" value="${param.roomId}">
                    <input type="hidden" name="checkIn" value="${param.checkIn}">
                    <input type="hidden" name="checkOut" value="${param.checkOut}">
                    <input type="hidden" name="nights" value="${param.nights}">
                    <input type="hidden" name="pricePerNight" value="${param.pricePerNight}">
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
        let basePrice = 0;
        let selectedServicesTotal = 0;

        document.addEventListener('DOMContentLoaded', function() {
            var stayNights = parseInt('${nights}', 10);
            var pricePerNight = parseInt('${param.pricePerNight}', 10);
            basePrice = pricePerNight * stayNights;
            updateTotalPrice();

            // Handle form submission
            document.getElementById('bookingForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Log form data before sending
                const formData = new FormData(this);
                for (let pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }

                fetch(this.action, {
                    method: 'POST',
                    body: new FormData(this)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        Swal.fire({
                            title: 'Thành công!',
                            text: data.message,
                            icon: 'success',
                            showConfirmButton: false,
                            timer: 1500
                        }).then(() => {
                            window.location.href = '${pageContext.request.contextPath}/home.jsp';
                        });
                    } else {
                        Swal.fire({
                            title: 'Lỗi!',
                            text: data.message,
                            icon: 'error'
                        });
                    }
                })
                .catch(() => {
                    Swal.fire({
                        title: 'Lỗi!',
                        text: 'Có lỗi xảy ra. Vui lòng thử lại!',
                        icon: 'error'
                    });
                });
            });
        });

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN').format(price);
        }

        function updateTotalPrice() {
            selectedServicesTotal = 0;
            const checkboxes = document.querySelectorAll('input[name="selectedServices"]');
            
            checkboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    selectedServicesTotal += parseFloat(checkbox.dataset.price);
                }
            });

            const finalTotal = basePrice + selectedServicesTotal;
            document.getElementById('totalPrice').textContent = 'Tổng cộng: ' + formatPrice(finalTotal) + 'đ';
        }
    </script>
<script>
function submitBooking(event) {
    event.preventDefault();
    
    const form = document.getElementById('bookingForm');
    const formData = new FormData(form);
    
    // Convert FormData to URL-encoded string
    const data = new URLSearchParams(formData);
    
    fetch('${pageContext.request.contextPath}/booking', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: data.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            Swal.fire({
                title: 'Thành công!',
                text: data.message,
                icon: 'success',
                confirmButtonText: 'OK'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/home';
                }
            });
        } else {
            Swal.fire({
                title: 'Lỗi!',
                text: data.message,
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    })
    .catch(error => {
        Swal.fire({
            title: 'Lỗi!',
            text: 'Đã xảy ra lỗi khi xử lý yêu cầu',
            icon: 'error',
            confirmButtonText: 'OK'
        });
    });
}
</script>
</body>
</html>