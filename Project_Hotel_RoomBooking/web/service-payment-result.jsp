<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán dịch vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .result-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .result-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .result-header {
            padding: 30px;
            text-align: center;
        }
        .success-header {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
        }
        .error-header {
            background: linear-gradient(135deg, #f44336, #d32f2f);
            color: white;
        }
        .result-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        .result-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .result-message {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        .payment-details {
            padding: 30px;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        .detail-value {
            font-weight: 500;
            color: #333;
        }
        .action-buttons {
            padding: 20px 30px;
            background: #f8f9fa;
            text-align: center;
        }
        .btn-custom {
            padding: 12px 30px;
            margin: 0 10px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .btn-secondary-custom {
            background: white;
            color: #666;
            border: 2px solid #ddd;
        }
        .btn-secondary-custom:hover {
            background: #f8f9fa;
            color: #333;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="result-container">
            <div class="result-card">
                <!-- Header -->
                <div class="result-header ${paymentSuccess ? 'success-header' : 'error-header'}">
                    <div class="result-icon">
                        <c:choose>
                            <c:when test="${paymentSuccess}">
                                <i class="fas fa-check-circle"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-times-circle"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="result-title">
                        <c:choose>
                            <c:when test="${paymentSuccess}">
                                Thanh toán thành công!
                            </c:when>
                            <c:otherwise>
                                Thanh toán thất bại!
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="result-message">
                        ${message}
                    </div>
                </div>

                <!-- Payment Details -->
                <c:if test="${paymentSuccess}">
                    <div class="payment-details">
                        <h5 class="mb-4"><i class="fas fa-receipt me-2"></i>Chi tiết giao dịch</h5>
                        
                        <div class="detail-row">
                            <span class="detail-label">Mã đặt dịch vụ:</span>
                            <span class="detail-value">#SVC${serviceBookingId}</span>
                        </div>
                        
                        <c:if test="${not empty amount}">
                            <div class="detail-row">
                                <span class="detail-label">Số tiền:</span>
                                <span class="detail-value">
                                    <fmt:formatNumber value="${amount}" type="currency" currencyCode="VND" pattern="#,##0 ¤"/>
                                </span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty transactionNo}">
                            <div class="detail-row">
                                <span class="detail-label">Mã giao dịch:</span>
                                <span class="detail-value">${transactionNo}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty payDate}">
                            <div class="detail-row">
                                <span class="detail-label">Thời gian:</span>
                                <span class="detail-value">
                                    ${payDate.substring(6,8)}/${payDate.substring(4,6)}/${payDate.substring(0,4)} 
                                    ${payDate.substring(8,10)}:${payDate.substring(10,12)}:${payDate.substring(12,14)}
                                </span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty bankCode}">
                            <div class="detail-row">
                                <span class="detail-label">Ngân hàng:</span>
                                <span class="detail-value">${bankCode}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty orderInfo}">
                            <div class="detail-row">
                                <span class="detail-label">Nội dung:</span>
                                <span class="detail-value">${orderInfo}</span>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <!-- Error Details -->
                <c:if test="${not paymentSuccess}">
                    <div class="payment-details">
                        <h5 class="mb-4 text-danger"><i class="fas fa-exclamation-triangle me-2"></i>Thông tin lỗi</h5>
                        
                        <c:if test="${not empty serviceBookingId}">
                            <div class="detail-row">
                                <span class="detail-label">Mã đặt dịch vụ:</span>
                                <span class="detail-value">#SVC${serviceBookingId}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty responseCode}">
                            <div class="detail-row">
                                <span class="detail-label">Mã lỗi:</span>
                                <span class="detail-value text-danger">${responseCode}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty error}">
                            <div class="detail-row">
                                <span class="detail-label">Chi tiết lỗi:</span>
                                <span class="detail-value text-danger">${error}</span>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/service.jsp" class="btn-custom btn-primary-custom">
                        <i class="fas fa-concierge-bell me-2"></i>Xem dịch vụ khác
                    </a>
                    <a href="${pageContext.request.contextPath}/servicePayment?action=history" class="btn-custom btn-secondary-custom">
                        <i class="fas fa-history me-2"></i>Lịch sử đặt dịch vụ
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn-custom btn-secondary-custom">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <c:if test="${paymentSuccess}">
        <script>
            // Auto redirect after 30 seconds if payment successful
            setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/home';
            }, 30000);
        </script>
    </c:if>
</body>
</html> 