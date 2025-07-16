<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết dịch vụ</title>
    <link rel="stylesheet" href="css/home-enhanced.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        .btn-view-detail {
            background-color: #4CAF50; /* Green */
            color: rgb(0, 0, 0);
            border: none;
            padding: 0.5rem 1rem; /* Bootstrap spacing */
            border-radius: 0.375rem; /* Bootstrap rounded */
            text-decoration: none;
            font-weight: bold;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Bootstrap shadow-sm */
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-view-detail:hover {
            background-color: #45a049; /* Darker green on hover */
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15); /* Bootstrap shadow */
        }

        .service-card {
            border: 1px solid #ccc; /* Added border for better visual separation */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1); /* Added subtle shadow */
            overflow: hidden; /* Ensures image doesn't overflow */
        }

        .service-image img {
            width: 100%;
            height: auto; /* Maintain aspect ratio */
            object-fit: cover; /* Cover the entire container */
        }

        .service-price-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0, 128, 0, 0.7); /* Semi-transparent green background */
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
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
                    <h1 class="hero-title"><i class="fas fa-info-circle me-2"></i>Chi Tiết Dịch Vụ</h1>
                    <p class="hero-subtitle">Thông tin chi tiết về dịch vụ ${service.name}</p>
                </div>
            </div>
        </section>

        <section class="service-detail-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 animate__animated animate__fadeInLeft">
                        <div class="service-image-container">
                            <img src="${service.imageUrl}" alt="${service.name}" class="main-image img-fluid rounded shadow">
                        </div>
                    </div>

                    <div class="col-lg-6 animate__animated animate__fadeInRight">
                        <div class="service-info-container">
                            <div class="service-header">
                                <h2 class="service-title">${service.name}</h2>
                                <span class="service-type-badge">${service.typeName}</span>
                            </div>

                            <div class="service-price">
                                <i class="fas fa-tag text-success me-2"></i>
                                <span class="price-value">
                                    <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/> VND
                                </span>
                            </div>

                            <div class="service-description">
                                <h4><i class="fas fa-info-circle me-2"></i>Mô tả dịch vụ</h4>
                                <p>${service.description}</p>
                            </div>

                            <div class="booking-section mt-4">
                                <form action="${pageContext.request.contextPath}/bookService" method="POST" class="booking-form">
                                    <input type="hidden" name="serviceId" value="${service.id}">
                                    <div class="form-group mb-3">
                                        <label for="bookingDate" class="form-label"><i class="fas fa-calendar me-2"></i>Ngày sử dụng</label>
                                        <input type="date" class="form-control" id="bookingDate" name="bookingDate" required>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="quantity" class="form-label"><i class="fas fa-sort-numeric-up me-2"></i>Số lượng</label>
                                        <input type="number" class="form-control" id="quantity" name="quantity" min="1" value="1" required>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label for="note" class="form-label"><i class="fas fa-sticky-note me-2"></i>Ghi chú</label>
                                        <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-book-service w-100"><i class="fas fa-calendar-check me-2"></i>Đặt dịch vụ</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Reviews Section -->
                <section class="customer-reviews mt-5">
                    <h3 class="section-title text-center"><i class="fas fa-comments me-2"></i>Đánh giá của khách hàng</h3>
                    <div class="section-divider"></div>
                    <div class="row mt-4 justify-content-center">
                        <div class="col-12 col-lg-10">
                            <div class="bg-white rounded shadow-sm p-4">
                                <c:choose>
                                    <c:when test="${not empty reviews}">
                                        <c:forEach var="review" items="${reviews}">
                                            <div class="review-item mb-4 border-bottom pb-3">
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="fas fa-user-circle fa-2x text-secondary me-3"></i>
                                                    <span class="fw-bold">Khách hàng ẩn danh</span>
                                                    <span class="ms-auto text-warning">
                                                        <c:forEach begin="1" end="${review.quality}" var="star">
                                                            <i class="fas fa-star"></i>
                                                        </c:forEach>
                                                        <c:forEach begin="1" end="${5 - review.quality}" var="star">
                                                            <i class="far fa-star"></i>
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                                <div class="review-content">
                                                    <p class="mb-1">${review.comment}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted">Chưa có đánh giá nào cho dịch vụ này.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Related Services Section -->
                <section class="related-services mt-5">
                    <h3 class="section-title text-center"><i class="fas fa-thumbs-up me-2"></i>Dịch vụ tương tự</h3>
                    <div class="section-divider"></div>
                    <div class="row mt-4 justify-content-center">
                        <div class="col-12 col-lg-10">
                            <div class="bg-white rounded shadow-sm p-4">
                                <c:choose>
                                    <c:when test="${not empty relatedServices}">
                                        <div class="row">
                                            <c:forEach var="relatedService" items="${relatedServices}" varStatus="status">
                                                <div class="col-md-4 mb-4">
                                                    <a href="serviceDetail?id=${relatedService.id}" class="text-decoration-none">
                                                        <div class="service-card animate__animated animate__fadeInUp">
                                                            <div class="service-image">
                                                                <img src="${relatedService.imageUrl}" alt="${relatedService.name}" class="img-fluid">
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
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted">
                                            <p>Không có dịch vụ tương tự nào.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </section>
    </main>

    <jsp:include page="customer/includes/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="js/home-enhanced.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const bookingDateInput = document.getElementById('bookingDate');
            if (bookingDateInput) {
                bookingDateInput.min = new Date().toISOString().split('T')[0];
            }

            const quantityInput = document.getElementById('quantity');
            if (quantityInput) {
                const basePrice = parseFloat("${service.price}"); // Fixed property name
                quantityInput.addEventListener('change', function() {
                    const quantity = this.value;
                    document.querySelector('.price-value').textContent = new Intl.NumberFormat('vi-VN').format(basePrice * quantity) + ' VND';
                });
            }
        });
    </script>
</body>
</html>