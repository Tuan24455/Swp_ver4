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
            <div class="row mb-4">
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
                        <form action="booking" method="POST" class="booking-form" novalidate>
                            <input type="hidden" name="roomId" value="${room.id}">
                            <div class="form-group mb-3">
                                <label for="checkIn" class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn" required>
                            </div>
                            <div class="form-group mb-3">
                                <label for="checkOut" class="form-label">Ngày trả phòng</label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut" required>
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
                                <i class="fas fa-wifi" aria-hidden="true"></i>
                                <span>Wifi tốc độ cao miễn phí</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-tv" aria-hidden="true"></i>
                                <span>Smart TV màn hình phẳng</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-snowflake" aria-hidden="true"></i>
                                <span>Điều hòa nhiệt độ thông minh</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-bath" aria-hidden="true"></i>
                                <span>Phòng tắm riêng sang trọng</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-coffee" aria-hidden="true"></i>
                                <span>Mini bar & Máy pha cà phê</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-concierge-bell" aria-hidden="true"></i>
                                <span>Dịch vụ phòng 24/7</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-bed" aria-hidden="true"></i>
                                <span>Nệm cao cấp êm ái</span>
                            </div>
                            <div class="amenity-item">
                                <i class="fas fa-door-closed" aria-hidden="true"></i>
                                <span>Két sắt an toàn</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Row: Room Description -->
            <div class="row">
                <div class="col-12">
                    <div class="room-description">
                        <h2 class="section-title">Mô tả phòng</h2>
                        <p class="description-text">${room.description}</p>
                    </div>
                </div>
            </div>

                        <div class="room-description">
                            <h4><i class="fas fa-info-circle"></i> Mô tả phòng</h4>
                            <p>${room.description}</p>
                        </div>

                        <div class="room-amenities">
                            <h4><i class="fas fa-star"></i> Tiện nghi cao cấp</h4>
                            <div class="amenities-grid">
                                <div class="amenity-item">
                                    <i class="fas fa-wifi" aria-hidden="true"></i>
                                    <span>Wifi tốc độ cao miễn phí</span>
                                </div>
                                <div class="amenity-item">
                                    <i class="fas fa-tv" aria-hidden="true"></i>
                                    <span>Smart TV màn hình phẳng</span>
                                </div>
                                <div class="amenity-item">
                                    <i class="fas fa-snowflake" aria-hidden="true"></i>
                                    <span>Điều hòa nhiệt độ thông minh</span>
                                </div>
                                <div class="amenity-item">
                                    <i class="fas fa-bath" aria-hidden="true"></i>
                                    <span>Phòng tắm riêng sang trọng</span>
                                </div>
                            </div>
                        </div>

                        <div class="booking-section">
                            <h3 class="booking-title"><i class="fas fa-calendar-check"></i> Đặt phòng ngay</h3>
                            <form action="booking" method="POST" class="booking-form" novalidate>
                                <input type="hidden" name="roomId" value="${room.id}">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="checkIn" class="form-label">
                                                <i class="fas fa-calendar-plus"></i> Ngày nhận phòng
                                            </label>
                                            <input type="date" class="form-control" id="checkIn" name="checkIn" required aria-describedby="checkInHelp">
                                            <small id="checkInHelp" class="form-text text-muted">Chọn ngày bạn muốn nhận phòng</small>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="checkOut" class="form-label">
                                                <i class="fas fa-calendar-minus"></i> Ngày trả phòng
                                            </label>
                                            <input type="date" class="form-control" id="checkOut" name="checkOut" required aria-describedby="checkOutHelp">
                                            <small id="checkOutHelp" class="form-text text-muted">Chọn ngày bạn muốn trả phòng</small>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn-book">
                                    <i class="fas fa-bed"></i> Đặt phòng ngay
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="customer/includes/footer.jsp" />

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/room-detail.js"></script>
</body>
</html>
