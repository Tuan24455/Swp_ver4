<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo Đánh Giá - Hotel Management System</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="${pageContext.request.contextPath}/css/style.css"
      rel="stylesheet"
    />
    <style>
      body {
        margin: 0;
        padding: 0;
        overflow-x: hidden;
      }
      .container-fluid {
        padding: 0 !important;
        margin: 0 !important;
        max-width: 100% !important;
      }

      .col-md-9.col-lg-10 {
        padding-left: 0 !important;
        padding-right: 0 !important;
        /*margin-left: 0 !important;*/
      }
      .main-content {
        padding: 1rem;
        width: 86%;
        min-height: 100vh;
        margin-left: 250px !important; /* Force margin */
        padding-left: 1px !important;
        padding-right: 1px !important;
      }
      .kpi-card {
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        border: none;
        border-radius: 12px;
      }
      .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
      }
      .page-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 0;
        padding: 2rem 1rem;
        margin-bottom: 2rem;
        margin-left: 0;
        margin-right: 0;
      }
      .breadcrumb {
        background: rgba(255,255,255,0.1);
        border-radius: 8px;
        padding: 0.5rem 1rem;
      }
      .breadcrumb-item a {
        color: rgba(255,255,255,0.8);
        text-decoration: none;
      }
      .breadcrumb-item.active {
        color: white;
      }
      .star-rating {
        color: #ffc107;
      }
      .table-responsive {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin: 0 1rem;
      }
      .table th {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
        font-weight: 600;
      }
      .filter-card {
        background: #f8f9fa;
        border-radius: 0;
        padding: 1.5rem 1rem;
        margin-bottom: 2rem;
        margin-left: 0;
        margin-right: 0;
      }
      .content-section {
        padding: 0 1rem;
      }
      
      @media (min-width: 576px) {
        .ms-sm-auto {
          margin-left: 250px !important;
        }
      }
      
      @media (min-width: 768px) {
        .px-md-4 {
          padding-right: 1px !important;
          padding-left: 1px !important;
        }
      }
      
      /* Navbar positioning */
      .navbar {
        margin-left: 257px !important;
        width: calc(100% - 250px) !important;
      }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="includes/sidebar.jsp" />
            
            <!-- Navbar -->
            <jsp:include page="includes/navbar.jsp" />
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ms-sm-auto main-content">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h2 mb-2">
                                <i class="fas fa-star me-2"></i>Báo Cáo Đánh Giá
                            </h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="fas fa-home"></i> Dashboard
                                        </a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Báo Cáo Đánh Giá
                                    </li>
                                </ol>
                            </nav>
                        </div>
                        <div class="text-end">
                            <small class="opacity-75">
                                <i class="fas fa-clock me-1"></i>
                                Cập nhật: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm" />
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-card">
                    <form method="get" action="${pageContext.request.contextPath}/admin/ratingreport">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="filterType" class="form-label">Loại Đánh Giá</label>
                                <select class="form-select" id="filterType" name="filterType">
                                    <option value="all" ${currentFilterType == 'all' || empty currentFilterType ? 'selected' : ''}>Tất Cả</option>
                                    <option value="room" ${currentFilterType == 'room' ? 'selected' : ''}>Đánh Giá Phòng</option>
                                    <option value="service" ${currentFilterType == 'service' ? 'selected' : ''}>Đánh Giá Dịch Vụ</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="quality" class="form-label">Mức Chất Lượng</label>
                                <select class="form-select" id="quality" name="quality">
                                    <option value="">Tất Cả Mức</option>
                                    <option value="5" ${currentQuality == '5' ? 'selected' : ''}>5 Sao - Xuất Sắc</option>
                                    <option value="4" ${currentQuality == '4' ? 'selected' : ''}>4 Sao - Tốt</option>
                                    <option value="3" ${currentQuality == '3' ? 'selected' : ''}>3 Sao - Trung Bình</option>
                                    <option value="2" ${currentQuality == '2' ? 'selected' : ''}>2 Sao - Kém</option>
                                    <option value="1" ${currentQuality == '1' ? 'selected' : ''}>1 Sao - Rất Kém</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-filter me-1"></i>Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/ratingreport" class="btn btn-outline-secondary">
                                    <i class="fas fa-refresh me-1"></i>Đặt Lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Summary Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card kpi-card shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="d-flex align-items-center justify-content-center mb-2">
                                    <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                                        <i class="fas fa-star text-primary fs-4"></i>
                                    </div>
                                </div>
                                <h3 class="card-title text-primary mb-1">
                                    <fmt:formatNumber value="${summary.avgRating}" pattern="#.##" />
                                </h3>
                                <p class="card-text text-muted mb-0">Điểm Trung Bình</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card kpi-card shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="d-flex align-items-center justify-content-center mb-2">
                                    <div class="rounded-circle bg-success bg-opacity-10 p-3">
                                        <i class="fas fa-comments text-success fs-4"></i>
                                    </div>
                                </div>
                                <h3 class="card-title text-success mb-1">${summary.totalReviews}</h3>
                                <p class="card-text text-muted mb-0">Tổng Đánh Giá</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card kpi-card shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="d-flex align-items-center justify-content-center mb-2">
                                    <div class="rounded-circle bg-info bg-opacity-10 p-3">
                                        <i class="fas fa-bed text-info fs-4"></i>
                                    </div>
                                </div>
                                <h3 class="card-title text-info mb-1">${summary.totalRoomReviews}</h3>
                                <p class="card-text text-muted mb-0">Đánh Giá Phòng</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card kpi-card shadow-sm h-100">
                            <div class="card-body text-center">
                                <div class="d-flex align-items-center justify-content-center mb-2">
                                    <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                                        <i class="fas fa-concierge-bell text-warning fs-4"></i>
                                    </div>
                                </div>
                                <h3 class="card-title text-warning mb-1">${summary.totalServiceReviews}</h3>
                                <p class="card-text text-muted mb-0">Đánh Giá Dịch Vụ</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Room Reviews Table -->
                <c:if test="${currentFilterType == 'all' || currentFilterType == 'room' || empty currentFilterType}">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-bed me-2"></i>Đánh Giá Phòng
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Phòng</th>
                                        <th>Chất Lượng</th>
                                        <th>Bình Luận</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty roomReviews}">
                                            <c:forEach var="review" items="${roomReviews}">
                                                <tr>
                                                    <td>${review.id}</td>
                                                    <td>
                                                        <span class="badge bg-info">
                                                            <c:choose>
                                                                <c:when test="${not empty roomMap[review.roomId]}">
                                                                    Phòng ${roomMap[review.roomId]}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Phòng ${review.roomId}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="star-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star ${i <= review.quality ? '' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                            <span class="ms-1">(${review.quality}/5)</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty review.comment}">
                                                                ${review.comment}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted fst-italic">Không có bình luận</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-4">
                                                    <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                    Không có đánh giá phòng nào
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </c:if>

                <!-- Service Reviews Table -->
                <c:if test="${currentFilterType == 'all' || currentFilterType == 'service' || empty currentFilterType}">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">
                            <i class="fas fa-concierge-bell me-2"></i>Đánh Giá Dịch Vụ
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Dịch Vụ</th>
                                        <th>Chất Lượng</th>
                                        <th>Bình Luận</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty serviceReviews}">
                                            <c:forEach var="review" items="${serviceReviews}">
                                                <tr>
                                                    <td>${review.id}</td>
                                                    <td>
                                                        <span class="badge bg-warning text-dark">
                                                            <c:choose>
                                                                <c:when test="${not empty serviceMap[review.serviceId]}">
                                                                    ${serviceMap[review.serviceId]}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Dịch Vụ ${review.serviceId}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="star-rating">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star ${i <= review.quality ? '' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                            <span class="ms-1">(${review.quality}/5)</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty review.comment}">
                                                                ${review.comment}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted fst-italic">Không có bình luận</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-4">
                                                    <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                    Không có đánh giá dịch vụ nào
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </c:if>


            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Sidebar toggle functionality
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.querySelector('.sidebar');
            
            if (sidebarToggle && sidebar) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('collapsed');
                });
            }
        });
    </script>
</body>
</html>
