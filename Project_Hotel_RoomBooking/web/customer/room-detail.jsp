<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/customer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="includes/header.jsp" />

    <!-- Room Detail Section -->
    <div class="container my-5">
        <div class="row">
            <!-- Room Images -->
            <div class="col-md-6">
                <div id="roomImages" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="${room.imageUrl}" class="d-block w-100 rounded" alt="${room.roomTypeName}">
                        </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#roomImages" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#roomImages" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    </button>
                </div>
            </div>

            <!-- Room Details -->
            <div class="col-md-6">
                <h2 class="mb-4">Phòng ${room.roomNumber}</h2>
                <div class="room-details">
                    <div class="detail-item mb-3">
                        <i class="fas fa-users"></i>
                        <span>Sức chứa: ${room.capacity} người</span>
                    </div>
                    <div class="detail-item mb-3">
                        <i class="fas fa-bed"></i>
                        <span>Loại phòng: ${room.roomTypeName}</span>
                    </div>
                    <div class="detail-item mb-3">
                        <i class="fas fa-dollar-sign"></i>
                        <span>Giá: ${room.roomPrice}đ/đêm</span>
                    </div>
                    <div class="detail-item mb-3">
                        <i class="fas fa-vector-square"></i>
                        <span>Tầng: ${room.floor}</span>
                    </div>
                </div>

                <div class="room-description mt-4">
                    <h4>Mô tả phòng</h4>
                    <p>${room.description}</p>
                </div>

                <div class="room-amenities mt-4">
                    <h4>Tiện nghi</h4>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-wifi text-success"></i> Wifi miễn phí</li>
                        <li><i class="fas fa-tv text-success"></i> TV màn hình phẳng</li>
                        <li><i class="fas fa-snowflake text-success"></i> Điều hòa nhiệt độ</li>
                        <li><i class="fas fa-bath text-success"></i> Phòng tắm riêng</li>
                    </ul>
                </div>

                <div class="booking-section mt-4">
                    <form action="booking" method="POST">
                        <input type="hidden" name="roomId" value="${room.id}">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="checkIn" class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn" required>
                            </div>
                            <div class="col-md-6">
                                <label for="checkOut" class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mt-4">Book Now</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set minimum dates for check-in and check-out
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('checkIn').min = today;
        document.getElementById('checkOut').min = today;

        // Update check-out minimum date when check-in is selected
        document.getElementById('checkIn').addEventListener('change', function() {
            document.getElementById('checkOut').min = this.value;
        });
    </script>
</body>
</html>
