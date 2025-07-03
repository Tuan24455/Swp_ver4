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
                        <form action="${pageContext.request.contextPath}/check-availability" method="POST" class="booking-form" novalidate>
                            <input type="hidden" name="roomId" value="${room.id}">
                            <input type="hidden" name="roomNumber" value="${room.roomNumber}">
                            <input type="hidden" name="roomType" value="${room.roomTypeName}">
                            <input type="hidden" name="maxGuests" value="${room.capacity}">
                            <input type="hidden" name="floor" value="${room.floor}">
                            <input type="hidden" name="pricePerNight" value="${room.roomPrice}">
                            <input type="hidden" name="imageUrl" value="${room.imageUrl}">
                            <div class="form-group mb-3">
                                <label for="checkIn" class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn" value="${param.checkIn}" required>
                            </div>
                            <div class="form-group mb-3">
                                <label for="checkOut" class="form-label">Ngày trả phòng</label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut" value="${param.checkOut}" required>
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
</body>
</html>
