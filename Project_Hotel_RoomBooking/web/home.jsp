<%-- 
    Document   : home.jsp
    Created on : May 22, 2025
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ - Hệ thống quản lý khách sạn</title>

        <!-- CSS Files -->
        <!--<link rel="stylesheet" href="customer/customer.css" />-->
        <link rel="stylesheet" href="css/home-enhanced.css" />

        <!-- External Libraries -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Animate.css for smooth animations -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    </head>
    <body>
        <!-- Background overlay for better readability -->
        <div class="background-overlay"></div>

        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <main class="main-content">
            <!-- Hero Section -->
            <section class="hero-section animate__animated animate__fadeInDown">
                <div class="container">
                    <div class="hero-content text-center">
                        <h1 class="hero-title">
                            <i class="fas fa-hotel me-3"></i>
                            Khám Phá Phòng Nghỉ Tuyệt Vời
                        </h1>
                        <p class="hero-subtitle">Tìm kiếm và đặt phòng khách sạn phù hợp với nhu cầu của bạn</p>
                    </div>
                </div>
            </section>

            <!-- Filter Section -->
            <section class="filter-section">
                <div class="container">
                    <div class="text-center mb-4">
                        <button type="button" class="filter-toggle-btn animate__animated animate__pulse animate__infinite" onclick="toggleFilter()">
                            <i class="fas fa-filter me-2"></i>
                            <span>Lọc phòng</span>
                            <i class="fas fa-chevron-down ms-2 filter-arrow"></i>
                        </button>
                    </div>

                    <!-- Enhanced Filter Modal -->
                    <div id="filterModal" class="filter-modal">
                        <div class="filter-modal-content animate__animated">
                            <div class="filter-header">
                                <h3><i class="fas fa-sliders-h me-2"></i>Bộ lọc tìm kiếm</h3>
                                <button type="button" class="filter-close-btn" onclick="toggleFilter()">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>

                            <form method="post" action="home" class="filter-form">
                                <div class="filter-grid">
                                    <!-- Room Type Filter -->
                                    <div class="filter-group">
                                        <div class="filter-group-header">
                                            <i class="fas fa-bed"></i>
                                            <label>Loại phòng</label>
                                        </div>
                                        <div class="checkbox-container">
                                            <c:forEach var="type" items="${requestScope.roomtypelist}">
                                                <div class="checkbox-item">
                                                    <input type="checkbox" 
                                                           id="roomType_${type.getId()}"
                                                           name="roomType" 
                                                           value="${type.getId()}"
                                                           <c:if test="${selectedRoomTypeIds != null && selectedRoomTypeIds.contains(type.getId())}">checked</c:if> />
                                                    <label for="roomType_${type.getId()}" class="checkbox-label">
                                                        ${type.getRoomType()}
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Date Filter -->
                                    <div class="filter-group">
                                        <div class="filter-group-header">
                                            <i class="fas fa-calendar-alt"></i>
                                            <label>Thời gian</label>
                                        </div>
                                        <div class="date-inputs">
                                            <!-- Ngày nhận phòng -->
                                            <div class="input-group">
                                                <label class="input-label">Ngày nhận phòng</label>
                                                <input type="date" name="checkin" class="form-input"
                                                       value="${param.checkin != null ? param.checkin : checkin}" />
                                            </div>

                                            <!-- Ngày trả phòng -->
                                            <div class="input-group">
                                                <label class="input-label">Ngày trả phòng</label>
                                                <input type="date" name="checkout" class="form-input"
                                                       value="${param.checkout != null ? param.checkout : checkout}" />
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Price Filter -->
                                    <div class="filter-group">
                                        <div class="filter-group-header">
                                            <i class="fas fa-money-bill-wave"></i>
                                            <label>Khoảng giá</label>
                                        </div>
                                        <div class="price-inputs">
                                            <div class="input-group">
                                                <label class="input-label">Từ (VND)</label>
                                                <input type="number" name="priceFrom" value="${param.priceFrom}" 
                                                       min="0" class="form-input" placeholder="0">
                                            </div>
                                            <div class="input-group">
                                                <label class="input-label">Đến (VND)</label>
                                                <input type="number" name="priceTo" value="${param.priceTo}" 
                                                       min="0" class="form-input" placeholder="Không giới hạn">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Capacity Filter -->
                                    <div class="filter-group">
                                        <div class="filter-group-header">
                                            <i class="fas fa-users"></i>
                                            <label>Sức chứa</label>
                                        </div>
                                        <div class="input-group">
                                            <input type="number" name="capacity" value="${param.capacity}" 
                                                   min="1" max="10" class="form-input" placeholder="Số người">
                                        </div>
                                    </div>

                                    <!-- Sort Filter -->
                                    <div class="filter-group">
                                        <div class="filter-group-header">
                                            <i class="fas fa-sort-amount-down"></i>
                                            <label>Sắp xếp</label>
                                        </div>
                                        <select name="sort" class="form-select">
                                            <option value="">-- Mặc định --</option>
                                            <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Giá tăng dần</option>
                                            <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Giá giảm dần</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Hiển thị lỗi nếu có -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger text-center mb-3" role="alert">
                                        ${error}
                                    </div>
                                </c:if>

                                <!-- Filter Actions -->
                                <div class="filter-actions">
                                    <button type="button" class="btn btn-reset" onclick="resetFilter()">
                                        <i class="fas fa-undo me-2"></i>Đặt lại
                                    </button>
                                    <button type="submit" class="btn btn-apply">
                                        <i class="fas fa-search me-2"></i>Áp dụng lọc
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Room List Section -->
            <section class="room-list-section">
                <div class="container">
                    <!-- Section Header -->
                    <div class="section-header text-center mb-5">
                        <h2 class="section-title animate__animated animate__fadeInUp">
                            <i class="fas fa-list me-3"></i>Danh Sách Phòng
                        </h2>
                        <div class="section-divider"></div>
                        <c:if test="${not empty roomlist}">
                            <p class="section-subtitle">
                                Tìm thấy <strong>${fn:length(roomlist)}</strong> phòng phù hợp
                            </p>
                        </c:if>
                    </div>

                    <!-- Room Grid -->
                    <div class="room-grid">
                        <c:choose>
                            <c:when test="${not empty roomlist}">
                                <c:forEach var="room" items="${roomlist}" varStatus="status">
                                    <div class="room-card animate__animated animate__fadeInUp" 
                                         style="animation-delay: ${status.index * 0.1}s">
                                        <div class="room-image-container">
                                            <img src="${room.getImageUrl()}" alt="Phòng ${room.getRoomNumber()}" class="room-image">
                                            <div class="room-overlay">
                                                <div class="room-price-badge">
                                                    <fmt:formatNumber value="${room.getRoomPrice()}" type="number" groupingUsed="true"/> VND
                                                </div>
                                            </div>
                                        </div>

                                        <div class="room-content">
                                            <div class="room-header">
                                                <h5 class="room-number">
                                                    <i class="fas fa-door-open me-2"></i>Phòng ${room.getRoomNumber()}
                                                </h5>
                                                <div class="room-type-badge">${room.getRoomTypeName()}</div>
                                            </div>

                                            <div class="room-details">
                                                <div class="room-detail-item">
                                                    <i class="fas fa-users text-primary"></i>
                                                    <span>${room.getCapacity()} người</span>
                                                </div>
                                                <div class="room-detail-item">
                                                    <i class="fas fa-tag text-success"></i>
                                                    <span class="room-price">
                                                        <fmt:formatNumber value="${room.getRoomPrice()}" type="number" groupingUsed="true"/> VND
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="room-description">
                                                <c:choose>
                                                    <c:when test="${fn:length(room.getDescription()) > 80}">
                                                        <p>${fn:substring(room.getDescription(), 0, 80)}...</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p>${room.getDescription()}</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="room-actions">
                                                <a href="room-detail?id=${room.getId()}" class="btn btn-view-detail">
                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-rooms-found">
                                    <div class="no-rooms-icon">
                                        <i class="fas fa-search"></i>
                                    </div>
                                    <h3>Không tìm thấy phòng phù hợp</h3>
                                    <p>Vui lòng thử điều chỉnh bộ lọc tìm kiếm</p>
                                    <button type="button" class="btn btn-reset" onclick="resetFilter()">
                                        <i class="fas fa-undo me-2"></i>Đặt lại bộ lọc
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- Enhanced Pagination -->
            <c:if test="${totalPages > 1}">
                <section class="pagination-section">
                    <div class="container">
                        <nav class="pagination-nav" aria-label="Phân trang">
                            <ul class="pagination-list">
                                <!-- Previous Button -->
                                <li class="pagination-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <button class="pagination-link" type="button" 
                                            onclick="goToPage(${currentPage - 1})"
                                            ${currentPage == 1 ? 'disabled' : ''}>
                                        <i class="fas fa-chevron-left"></i>
                                        <span class="d-none d-sm-inline ms-1">Trước</span>
                                    </button>
                                </li>

                                <!-- Page Numbers -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="pagination-item ${i == currentPage ? 'active' : ''}">
                                        <button class="pagination-link" type="button" onclick="goToPage(${i})">
                                            ${i}
                                        </button>
                                    </li>
                                </c:forEach>

                                <!-- Next Button -->
                                <li class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <button class="pagination-link" type="button" 
                                            onclick="goToPage(${currentPage + 1})"
                                            ${currentPage == totalPages ? 'disabled' : ''}>
                                        <span class="d-none d-sm-inline me-1">Sau</span>
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </li>
                            </ul>
                        </nav>

                        <!-- Pagination Info -->
                        <div class="pagination-info text-center mt-3">
                            <span class="pagination-text">
                                Trang ${currentPage} / ${totalPages}
                            </span>
                        </div>
                    </div>
                </section>
            </c:if>
        </main>

        <!-- Hidden Pagination Form -->
        <form id="paginationForm" method="post" action="home" style="display: none;">
            <input type="hidden" name="page" id="paginationPage" />
            <c:forEach var="entry" items="${paramValues}">
                <c:if test="${entry.key != 'page'}">
                    <c:forEach var="v" items="${entry.value}">
                        <input type="hidden" name="${entry.key}" value="${v}" />
                    </c:forEach>
                </c:if>
            </c:forEach>
        </form>

        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="js/home-enhanced.js"></script>
        
        <!-- Show payment result message if exists -->
        <c:if test="${not empty param.message}">    
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    Swal.fire({
                        title: '${param.status == "success" ? "Thành công!" : "Thất bại!"}',
                        text: '${param.message}',
                        icon: '${param.status}',
                        confirmButtonText: 'OK'
                    });
                });
            </script>
        </c:if>
    </body>
</html>
