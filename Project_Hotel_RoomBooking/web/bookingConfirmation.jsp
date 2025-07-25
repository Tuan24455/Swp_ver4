<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đặt phòng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --success-color: #27ae60;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --light-bg: #f8f9fa;
            --border-radius: 12px;
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
        }

        .confirmation-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header-section h1 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
        }

        .header-section p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }

        .content-section {
            padding: 30px;
        }

        .info-card {
            background: var(--light-bg);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 25px;
            border-left: 4px solid var(--secondary-color);
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: var(--primary-color);
            display: flex;
            align-items: center;
        }

        .info-label i {
            margin-right: 8px;
            width: 20px;
            text-align: center;
        }

        .info-value {
            font-weight: 500;
            color: #555;
        }

        .price-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: var(--border-radius);
            padding: 25px;
            margin: 25px 0;
            border: 2px solid var(--secondary-color);
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #ddd;
        }

        .price-row:last-child {
            border-bottom: none;
        }

        .discount-row {
            background: linear-gradient(135deg, rgba(39, 174, 96, 0.1) 0%, rgba(39, 174, 96, 0.05) 100%);
            border-radius: 8px;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid rgba(39, 174, 96, 0.2);
        }

        .discount-amount {
            color: var(--success-color);
            font-weight: 700;
        }

        .total-row {
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1) 0%, rgba(52, 152, 219, 0.05) 100%);
            border-radius: 8px;
            padding: 15px 12px;
            margin-top: 15px;
            border: 2px solid var(--secondary-color);
        }

        .total-amount {
            color: var(--danger-color);
            font-size: 1.5rem;
            font-weight: 800;
        }

        .button-section {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn-custom {
            padding: 15px 30px;
            border-radius: var(--border-radius);
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            min-width: 200px;
            justify-content: center;
        }

        .btn-payment {
            background: linear-gradient(135deg, var(--success-color), #2ecc71);
            color: white;
        }

        .btn-payment:hover {
            background: linear-gradient(135deg, #2ecc71, var(--success-color));
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.3);
            color: white;
        }

        .btn-cancel {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn-cancel:hover {
            background: linear-gradient(135deg, #7f8c8d, #95a5a6);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(127, 140, 141, 0.3);
            color: white;
        }

        .room-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
        }

        .customer-info {
            background: linear-gradient(135deg, #fff3cd 0%, #fef9e7 100%);
            border-left: 4px solid var(--warning-color);
        }        /* Payment Method Styles */
        .payment-method-section {
            margin: 30px 0;
            padding: 25px;
            background: var(--light-bg);
            border-radius: var(--border-radius);
            border: 1px solid #e3e6f0;
        }

        .payment-method-section h5 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 20px;
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .payment-option {
            position: relative;
        }

        .payment-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .payment-label {
            display: block;
            padding: 20px;
            background: white;
            border: 2px solid #e3e6f0;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }

        .payment-label:hover {
            border-color: var(--secondary-color);
            box-shadow: 0 2px 10px rgba(52, 152, 219, 0.1);
        }

        .payment-option input[type="radio"]:checked + .payment-label {
            border-color: var(--secondary-color);
            background: linear-gradient(135deg, #e3f2fd, #f8f9fa);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.2);
        }

        .payment-option input[type="radio"]:checked + .payment-label::after {
            content: '';
            position: absolute;
            top: 15px;
            right: 15px;
            width: 20px;
            height: 20px;
            background: var(--secondary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .payment-option input[type="radio"]:checked + .payment-label::before {
            content: '✓';
            position: absolute;
            top: 19px;
            right: 19px;
            color: white;
            font-size: 12px;
            font-weight: bold;
            z-index: 1;
        }

        .payment-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .payment-info i {
            font-size: 1.5rem;
            width: 30px;
            text-align: center;
        }

        .payment-info span {
            font-weight: 600;
            color: var(--primary-color);
        }

        .payment-info small {
            display: block;
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 2px;
        }

        @media (max-width: 768px) {
            .confirmation-container {
                margin: 10px;
            }

            .content-section {
                padding: 20px;
            }

            .button-section {
                flex-direction: column;
            }

            .btn-custom {
                min-width: 100%;
            }

            .payment-options {
                gap: 10px;
            }

            .payment-label {
                padding: 15px;
            }

            .payment-info {
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <!-- Header Section -->
        <div class="header-section">
            <h1><i class="fas fa-check-circle me-3"></i>Xác Nhận Đặt Phòng</h1>
            <p>Vui lòng kiểm tra thông tin đặt phòng trước khi thanh toán</p>
        </div>

        <!-- Content Section -->
        <div class="content-section">
            <!-- Customer Information -->
            <div class="info-card customer-info">
                <h3><i class="fas fa-user me-2"></i>Thông tin khách hàng</h3>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-id-card"></i>Họ tên:</span>
                    <span class="info-value">${user.fullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-envelope"></i>Email:</span>
                    <span class="info-value">${user.email}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-phone"></i>Số điện thoại:</span>
                    <span class="info-value">${user.phone}</span>
                </div>
            </div>

            <!-- Room Information -->
            <div class="info-card">
                <h3><i class="fas fa-bed me-2"></i>Thông tin phòng</h3>
                
                <c:if test="${not empty imageUrl}">
                    <img src="${imageUrl}" alt="Room Image" class="room-image">
                </c:if>
                
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-door-open"></i>Số phòng:</span>
                    <span class="info-value">${roomNumber}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-home"></i>Loại phòng:</span>
                    <span class="info-value">${roomType}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-users"></i>Sức chứa:</span>
                    <span class="info-value">${maxGuests} người</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-building"></i>Tầng:</span>
                    <span class="info-value">Tầng ${floor}</span>
                </div>
            </div>

            <!-- Booking Details -->
            <div class="info-card">
                <h3><i class="fas fa-calendar-alt me-2"></i>Chi tiết đặt phòng</h3>
                                 <div class="info-row">
                     <span class="info-label"><i class="fas fa-calendar-check"></i>Ngày nhận phòng:</span>
                     <span class="info-value">${checkIn}</span>
                 </div>
                 <div class="info-row">
                     <span class="info-label"><i class="fas fa-calendar-times"></i>Ngày trả phòng:</span>
                     <span class="info-value">${checkOut}</span>
                 </div>
                <div class="info-row">
                    <span class="info-label"><i class="fas fa-moon"></i>Số đêm:</span>
                    <span class="info-value">${nights} đêm</span>
                </div>
            </div>

            <!-- Price Details -->
            <div class="price-section">
                <h3><i class="fas fa-money-bill-wave me-2"></i>Chi tiết giá</h3>
                
                <div class="price-row">
                    <span>${nights} đêm × <fmt:formatNumber value="${pricePerNight}" pattern="#,###" />₫/đêm</span>
                    <span><fmt:formatNumber value="${originalTotal}" pattern="#,###" />₫</span>
                </div>

                <!-- Discount Section (if applicable) -->
                <c:if test="${not empty discountCode and discountAmount > 0}">
                    <div class="price-row discount-row">
                        <span>
                            <i class="fas fa-tag me-2"></i>
                            Mã giảm giá: ${discountCode} (${discountPercentage}%)
                            <c:if test="${not empty discountDescription}">
                                <br><small class="text-muted">${discountDescription}</small>
                            </c:if>
                        </span>
                        <span class="discount-amount">-<fmt:formatNumber value="${discountAmount}" pattern="#,###" />₫</span>
                    </div>
                </c:if>

                <!-- Total -->
                <div class="price-row total-row">
                    <span><strong>Tổng cộng:</strong></span>
                    <span class="total-amount"><fmt:formatNumber value="${finalTotal}" pattern="#,###" />₫</span>
                </div>            </div>
            
            <!-- Note about using VNPay for payment -->
            <div class="alert alert-primary mb-4">
                <i class="fas fa-info-circle me-2"></i>
                <strong>Thông báo:</strong> Tất cả các giao dịch thanh toán được xử lý qua VNPay.
            </div>

            <!-- Action Buttons -->
            <div class="button-section">
                <form id="paymentForm" action="${pageContext.request.contextPath}/vnpay-payment" method="post" style="display: inline;">
                    <input type="hidden" name="roomId" value="${roomId}">
                    <input type="hidden" name="checkIn" value="${checkIn}">
                    <input type="hidden" name="checkOut" value="${checkOut}">
                    <input type="hidden" name="nights" value="${nights}">
                    <input type="hidden" name="totalAmount" value="${finalTotal}">
                    <input type="hidden" name="discountCode" value="${discountCode}">
                    <input type="hidden" name="discountAmount" value="${discountAmount}">
                    <input type="hidden" name="type" value="room">
                    <input type="hidden" name="id" value="${roomId}">
                    <input type="hidden" name="amount" value="${finalTotal}">
                    <input type="hidden" id="selectedPaymentMethod" name="paymentMethod" value="vnpay">
                      <button type="submit" class="btn-custom btn-payment">
                        <i class="fas fa-credit-card"></i>
                        <span id="paymentButtonText">Xác nhận đặt phòng và thanh toán</span>
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/home" class="btn-custom btn-cancel">
                    <i class="fas fa-times"></i>
                    Hủy đặt phòng
                </a>
            </div>

            <!-- Terms Notice -->
            <div class="alert alert-info mt-4" role="alert">
                <i class="fas fa-info-circle me-2"></i>
                <strong>Lưu ý:</strong> 
                <ul class="mb-0 mt-2">
                    <li>Giờ nhận phòng: <strong>12:00 Trưa</strong></li>
                    <li>Giờ trả phòng: <strong>11:00 Sáng</strong></li>
                    
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>    <script>
        // Simple loading state for VNPay payment
        document.addEventListener('DOMContentLoaded', function() {
            // Form submission handling
            document.getElementById('paymentForm').addEventListener('submit', function(e) {
                // Show loading state
                const submitButton = this.querySelector('button[type="submit"]');
                const originalText = submitButton.innerHTML;
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                
                // Re-enable button after 10 seconds in case of issues
                setTimeout(() => {
                    submitButton.disabled = false;
                    submitButton.innerHTML = originalText;
                }, 10000);
            });
        });
    </script>
</body>
</html>