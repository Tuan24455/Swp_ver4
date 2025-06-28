
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Hệ Thống Quản Lý Khách Sạn</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin-dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex" id="wrapper">
        <!-- Sidebar -->
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <div id="page-content-wrapper" class="flex-fill">
            <!-- Top Navigation -->
            <jsp:include page="includes/navbar.jsp" />

            <div class="container-fluid py-4">
                <!-- Dashboard Header -->
                <div class="dashboard-header">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="h2 mb-2">Dashboard Quản Lý Khách Sạn</h1>
                            <p class="mb-0 opacity-75">Tổng quan hoạt động kinh doanh và vận hành khách sạn</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="d-flex justify-content-end gap-2">

                            </div>
                        </div>
                    </div>
                </div>

                <!-- KPI Cards -->
                <div class="row g-4 mb-4">
                    <!-- Tổng Doanh Thu -->
                    <div class="col-xl-3 col-md-6">
                        <div class="kpi-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="kpi-icon bg-primary bg-opacity-10">
                                        <i class="fas fa-dollar-sign text-primary"></i>
                                    </div>
                                    <h3 class="h4 mb-1">15.8 tỷ VND</h3>
                                    <p class="text-muted mb-2">Tổng Doanh Thu</p>
                                    <div class="d-flex align-items-center">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tỷ Lệ Lấp Đầy -->
                    <div class="col-xl-3 col-md-6">
                        <div class="kpi-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="kpi-icon bg-success bg-opacity-10">
                                        <i class="fas fa-bed text-success"></i>
                                    </div>
                                    <h3 class="h4 mb-1">120/153 phòng</h3>
                                    <p class="text-muted mb-2">Tỷ Lệ Lấp Đầy</p>
                                    <div class="d-flex align-items-center">
                                        <small class="text-success">
                                            <i class="fas fa-arrow-up me-1"></i>85.2%
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tổng Đặt Phòng -->
                    <div class="col-xl-3 col-md-6">
                        <div class="kpi-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="kpi-icon bg-info bg-opacity-10">
                                        <i class="fas fa-calendar-check text-info"></i>
                                    </div>
                                    <h3 class="h4 mb-1">3,650</h3>
                                    <p class="text-muted mb-2">Đặt Phòng Tháng</p>
                                    <div class="d-flex align-items-center">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Đánh Giá Trung Bình -->
                    <div class="col-xl-3 col-md-6">
                        <div class="kpi-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="kpi-icon bg-warning bg-opacity-10">
                                        <i class="fas fa-star text-warning"></i>
                                    </div>
                                    <h3 class="h4 mb-1">4.8/5</h3>
                                    <p class="text-muted mb-2">Đánh Giá Trung Bình</p>
                                    <div class="d-flex align-items-center">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row g-4 mb-4">
                    <!-- Revenue Chart -->
                    <div class="col-xl-8">
                        <div class="chart-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="card-title mb-0">Phân Tích Doanh Thu & Đặt Phòng</h5>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-primary btn-period active" onclick="updateChart('weekly')">
                                        Tuần
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-period" onclick="updateChart('monthly')">
                                        Tháng
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-period" onclick="updateChart('yearly')">
                                        Năm
                                    </button>
                                </div>
                            </div>
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Room Status Chart -->
                    <div class="col-xl-4">
                        <div class="chart-card">
                            <h5 class="card-title mb-3">Trạng Thái Phòng</h5>
                            <div class="chart-container" style="height: 300px;">
                                <canvas id="roomStatusChart"></canvas>
                            </div>
                            <div class="mt-3">
                                <div class="row text-center">
                                    <div class="col-4">
                                        <div class="text-success">
                                            <strong>120</strong>
                                            <small class="d-block text-muted">Đã Đặt</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="text-primary">
                                            <strong>25</strong>
                                            <small class="d-block text-muted">Trống</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="text-warning">
                                            <strong>8</strong>
                                            <small class="d-block text-muted">Bảo Trì</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats & Recent Activity -->
                <div class="row g-4 mb-4">
                    <!-- Quick Stats -->
                    <div class="col-xl-4">
                        <div class="quick-stats">
                            <h5 class="mb-3">Thống Kê Nhanh</h5>
                            
                            <!-- Check-in Today -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h6 class="mb-1">Check-in Hôm Nay</h6>
                                    <small class="text-muted">45 khách</small>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-primary">45</span>
                                </div>
                            </div>
                            <div class="progress progress-custom mb-3">
                                <div class="progress-bar bg-primary" style="width: 75%"></div>
                            </div>

                            <!-- Check-out Today -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h6 class="mb-1">Check-out Hôm Nay</h6>
                                    <small class="text-muted">38 khách</small>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-success">38</span>
                                </div>
                            </div>
                            <div class="progress progress-custom mb-3">
                                <div class="progress-bar bg-success" style="width: 63%"></div>
                            </div>

                            <!-- Pending Requests -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h6 class="mb-1">Yêu Cầu Chờ Xử Lý</h6>
                                    <small class="text-muted">12 yêu cầu</small>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-warning">12</span>
                                </div>
                            </div>
                            <div class="progress progress-custom mb-3">
                                <div class="progress-bar bg-warning" style="width: 20%"></div>
                            </div>

                            <!-- Staff on Duty -->
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Nhân Viên Trực</h6>
                                    <small class="text-muted">28/32 nhân viên</small>
                                </div>
                                <div class="text-end">
                                    <span class="badge bg-info">28</span>
                                </div>
                            </div>
                            <div class="progress progress-custom">
                                <div class="progress-bar bg-info" style="width: 87.5%"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Bookings -->
                    <div class="col-xl-8">
                        <div class="table-card">
                            <div class="card-header bg-white border-0 pb-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Đặt Phòng Gần Đây</h5>
                                    <a href="bookings.jsp" class="btn btn-sm btn-outline-primary">Xem Tất Cả</a>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Mã Đặt</th>
                                                <th>Khách Hàng</th>
                                                <th>Phòng</th>
                                                <th>Check-in</th>
                                                <th>Trạng Thái</th>
                                                <th>Tổng Tiền</th>
                                                <th>Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>#BK001</strong></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary bg-opacity-10 rounded-circle me-2 d-flex align-items-center justify-content-center">
                                                            <i class="fas fa-user text-primary"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">Nguyễn Văn A</div>
                                                            <small class="text-muted">nguyenvana@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Deluxe 101</td>
                                                <td>25/12/2024</td>
                                                <td><span class="status-badge bg-success text-white">Đã Xác Nhận</span></td>
                                                <td><strong>2,500,000 VND</strong></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-primary" title="Xem Chi Tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-success" title="Check-in">
                                                            <i class="fas fa-sign-in-alt"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>#BK002</strong></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-info bg-opacity-10 rounded-circle me-2 d-flex align-items-center justify-content-center">
                                                            <i class="fas fa-user text-info"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">Trần Thị B</div>
                                                            <small class="text-muted">tranthib@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Standard 205</td>
                                                <td>26/12/2024</td>
                                                <td><span class="status-badge bg-warning text-dark">Chờ Xác Nhận</span></td>
                                                <td><strong>1,800,000 VND</strong></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-primary" title="Xem Chi Tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-success" title="Xác Nhận">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>#BK003</strong></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-success bg-opacity-10 rounded-circle me-2 d-flex align-items-center justify-content-center">
                                                            <i class="fas fa-user text-success"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">Lê Văn C</div>
                                                            <small class="text-muted">levanc@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Suite 301</td>
                                                <td>24/12/2024</td>
                                                <td><span class="status-badge bg-primary text-white">Đang Ở</span></td>
                                                <td><strong>4,200,000 VND</strong></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-primary" title="Xem Chi Tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger" title="Check-out">
                                                            <i class="fas fa-sign-out-alt"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="notificationToast" class="toast" role="alert">
            <div class="toast-header">
                <i class="fas fa-bell text-primary me-2"></i>
                <strong class="me-auto">Thông Báo</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body" id="toastMessage">
                <!-- Toast message will be inserted here -->
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom Dashboard JavaScript -->
    <script src="${pageContext.request.contextPath}/admin/js/dashboard.js"></script>
</body>
</html>