<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Dịch Vụ - Hotel Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .payment-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .payment-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .service-details {
            padding: 2rem;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .detail-row:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 1.2rem;
            color: #28a745;
        }
        
        .detail-label {
            color: #666;
        }
        
        .detail-value {
            font-weight: 500;
        }
        
        .btn-payment {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-payment:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            color: white;
        }
        
        .btn-back {
            background: #6c757d;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-1px);
            color: white;
        }
        
        .service-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        
        .user-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .currency {
            color: #28a745;
            font-weight: 600;
        }
        
        .note-section {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
        }
        
        .payment-methods {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #eee;
        }
        
        .payment-logo {
            height: 40px;
            margin: 0 10px;
            opacity: 0.7;
            transition: opacity 0.3s ease;
        }
        
        .payment-logo:hover {
            opacity: 1;
        }
    </style>
</head>

<body>
    <div class="payment-container">
        <div class="payment-card">
            <!-- Header -->
            <div class="card-header">
                <h2><i class="fas fa-credit-card me-2"></i>Xác Nhận Đặt Dịch Vụ</h2>
                <p class="mb-0">Vui lòng kiểm tra thông tin và hoàn tất thanh toán</p>
            </div>
            
            <!-- Service Details -->
            <div class="service-details">
                <!-- User Information -->
                <div class="user-info">
                    <h5><i class="fas fa-user me-2"></i>Thông Tin Khách Hàng</h5>
                    <p class="mb-1"><strong>Họ tên:</strong> ${user.fullName}</p>
                    <p class="mb-1"><strong>Email:</strong> ${user.email}</p>
                    <p class="mb-0"><strong>Số điện thoại:</strong> ${user.phone}</p>
                </div>
                
                <!-- Service Information -->
                <div class="row">
                    <div class="col-md-4">
                        <c:choose>
                            <c:when test="${not empty service.imageUrl}">
                                <img src="${service.imageUrl}" alt="${service.name}" class="service-image">
                            </c:when>
                            <c:otherwise>
                                <div class="service-image d-flex align-items-center justify-content-center bg-light">
                                    <i class="fas fa-concierge-bell fa-3x text-muted"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-8">
                        <h4 class="text-primary">${service.name}</h4>
                        <p class="text-muted">${service.description}</p>
                        <span class="badge bg-info">${service.typeName}</span>
                    </div>
                </div>
                
                <!-- Booking Details -->
                <div class="mt-4">
                    <h5><i class="fas fa-info-circle me-2"></i>Chi Tiết Đặt Dịch Vụ</h5>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-calendar me-2"></i>Ngày sử dụng:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${bookingDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-sort-numeric-up me-2"></i>Số lượng:</span>
                        <span class="detail-value">${quantity}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-tag me-2"></i>Giá đơn vị:</span>
                        <span class="detail-value currency">
                            <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/> VND
                        </span>
                    </div>
                    
                    <c:if test="${not empty note}">
                        <div class="note-section">
                            <h6><i class="fas fa-sticky-note me-2"></i>Ghi chú:</h6>
                            <p class="mb-0">${note}</p>
                        </div>
                    </c:if>
                    
                    <div class="detail-row">
                        <span class="detail-label"><i class="fas fa-money-bill-wave me-2"></i>Tổng tiền:</span>
                        <span class="detail-value currency">
                            <fmt:formatNumber value="${totalCost}" type="number" groupingUsed="true"/> VND
                        </span>
                    </div>
                </div>
                
                <!-- Payment Methods Info -->
                <div class="payment-methods">
                    <h6 class="text-muted mb-3">Phương thức thanh toán được hỗ trợ:</h6>
                    <div class="d-flex justify-content-center align-items-center flex-wrap">
                        <img src="https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0oxhzjmxbksr1686814746087.png" alt="VNPay" class="payment-logo">
                        <img src="https://developers.momo.vn/v3/assets/images/square-d8a51b5f.svg" alt="MoMo" class="payment-logo">
                        <i class="fab fa-cc-visa fa-2x text-primary payment-logo"></i>
                        <i class="fab fa-cc-mastercard fa-2x text-warning payment-logo"></i>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="text-center mt-4">
                    <form action="process-service-payment" method="POST" class="d-inline">
                        <input type="hidden" name="serviceId" value="${service.id}">
                        <input type="hidden" name="bookingDate" value="${bookingDate}">
                        <input type="hidden" name="quantity" value="${quantity}">
                        <input type="hidden" name="note" value="${note}">
                        <input type="hidden" name="totalAmount" value="${totalCost}">
                        <input type="hidden" name="serviceName" value="${service.name}">
                        
                        <button type="submit" class="btn btn-payment me-3">
                            <i class="fas fa-credit-card me-2"></i>Thanh Toán Ngay
                        </button>
                    </form>
                    
                    <a href="serviceDetail?id=${service.id}" class="btn btn-back">
                        <i class="fas fa-arrow-left me-2"></i>Quay Lại
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Animate card on load
            const card = document.querySelector('.payment-card');
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
            
            // Add ripple effect to buttons
            const buttons = document.querySelectorAll('.btn-payment, .btn-back');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('div');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: rgba(255,255,255,0.6);
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        pointer-events: none;
                    `;
                    
                    this.style.position = 'relative';
                    this.style.overflow = 'hidden';
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });
        });
        
        // Add CSS for ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
