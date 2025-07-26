<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Room Status - Hotel Management System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link
            href="${pageContext.request.contextPath}/css/style.css"
            rel="stylesheet"
            />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">


        <style>
            .room-card {
                transition: transform 0.2s;
                cursor: pointer;
            }
            .room-card:hover {
                transform: translateY(-2px);
            }
            .room-available {
                border-left: 4px solid #28a745;
            }
            .room-occupied {
                border-left: 4px solid #ffc107;
            }
            .room-maintenance {
                border-left: 4px solid #dc3545;
            }
            .room-cleaning {
                border-left: 4px solid #17a2b8;
            }
            .floor-section {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }


        </style>
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="roomstatus" />
            </jsp:include>

            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <nav
                    class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
                    >
                    <div class="container-fluid">
                        <div class="d-flex align-items-center gap-3">
                            <span id="current-date" class="fw-semibold text-muted">Thứ Ba, 24 tháng 6, 2025</span>
                            <span id="current-time" class="fw-semibold">16:56:28</span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid py-4">
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/reception/dashboard.jsp">
                                    <i class="fas fa-home me-1"></i>Home
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Danh sách phòng
                            </li>
                        </ol>
                    </nav>


                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h3 mb-0"></h1>
                    </div>

                    <!-- Room Statistics Cards -->
                    <div class="row g-4 mb-4">



                        <div class="col-xl-3 col-md-6">
                            <div class="card border border-success rounded-4 shadow-sm">
                                <div class="card-body">
                                    <h6 class="text-muted">Tổng số phòng </h6>
                                    <h2 class="text-success fw-bold">
                                        ${countAll}
                                    </h2>
                                    <div class="text-success">
                                        <i class="fas fa-door-open me-2"></i> Sẵn sàng đặt
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Phòng trống -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card border border-success rounded-4 shadow-sm">
                                <div class="card-body">
                                    <h6 class="text-muted">Phòng trống</h6>
                                    <h2 class="text-success fw-bold">
                                        ${statusCounts['Available'] != null ? statusCounts['Available'] : 0}
                                    </h2>
                                    <div class="text-success">
                                        <i class="fas fa-door-open me-2"></i> Sẵn sàng đặt
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Có khách -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card border border-warning rounded-4 shadow-sm">
                                <div class="card-body">
                                    <h6 class="text-muted">Có khách</h6>
                                    <h2 class="text-warning fw-bold">
                                        ${statusCounts['Occupied'] != null ? statusCounts['Occupied'] : 0}
                                    </h2>
                                    <div class="text-warning">
                                        <i class="fas fa-user-check me-2"></i> Đang sử dụng
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Bảo trì -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card border border-danger rounded-4 shadow-sm">
                                <div class="card-body">
                                    <h6 class="text-muted">Bảo trì</h6>
                                    <h2 class="text-danger fw-bold">
                                        ${statusCounts['Maintenance'] != null ? statusCounts['Maintenance'] : 0}
                                    </h2>
                                    <div class="text-danger">
                                        <i class="fas fa-tools me-2"></i> Đang bảo trì
                                    </div>
                                </div>
                            </div>
                        </div>

                        
                    </div>


                    <!-- Filter Options -->
                    <div class="card shadow-sm mb-4 border-0 bg-transparent">
                        <div class="card-body rounded-4 text-white" style="background-color: blanchedalmond;">
                            <h5 class="mb-3 fw-semibold">
                                <i class="fas fa-filter me-2 text-primary"></i> Bộ lọc phòng
                            </h5>
                            <div class="row g-4">
                                <!-- Filter by Status -->
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-info-circle me-1"></i> Trạng thái
                                    </label>
                                    <select class="form-select rounded-pill" id="statusFilter" onchange="filterRooms()">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="Available">Trống</option>
                                        <option value="Occupied">Có khách</option>
                                        <option value="Maintenance">Bảo trì</option>
                                        <option value="Cleaning">Dọn dẹp</option>
                                    </select>
                                </div>

                                <!-- Filter by Floor -->
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-building me-1"></i> Tầng
                                    </label>
                                    <select class="form-select rounded-pill" id="floorFilter" onchange="filterRooms()">
                                        <option value="">Tất cả các tầng</option>
                                        <option value="1">Tầng 1</option>
                                        <option value="2">Tầng 2</option>
                                        <option value="3">Tầng 3</option>
                                        <option value="4">Tầng 4</option>
                                        <option value="5">Tầng 5</option>
                                    </select>
                                </div>

                                <!-- Filter by Type -->
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold text-secondary">
                                        <i class="fas fa-bed me-1"></i> Loại phòng
                                    </label>
                                    <select class="form-select rounded-pill" id="typeFilter" onchange="filterRooms()">
                                        <option value="">Tất cả loại phòng</option>
                                        <option value="Standard Room">Standard</option>
                                        <option value="Deluxe Room">Deluxe</option>
                                        <option value="Suite">Suite</option>
                                        <option value="Presidential Suite">Presidential</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>



                    <!-- Floor 1 -->
                    <div class="floor-section">
                        <h5 class="mb-3"><i class="fas fa-building me-2"></i>Tầng 1</h5>
                        <div class="row g-3" id="floor1">
                            <c:forEach var="r" items="${room1}">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div
                                        class="card room-card shadow-sm
                                        <c:choose>
                                            <c:when test="${r.roomTypeName == 'Standard Room'}">border-primary bg-light</c:when>
                                            <c:when test="${r.roomTypeName == 'Deluxe Room'}">border-success bg-light</c:when>
                                            <c:when test="${r.roomTypeName == 'Suite'}">border-danger bg-light</c:when>
                                            <c:when test="${r.roomTypeName == 'Presidential Suite'}">border-warning bg-light</c:when>
                                            <c:otherwise>border-secondary</c:otherwise>
                                        </c:choose>"
                                        data-room="${r.roomNumber}"
                                        data-status="${r.roomStatus}"
                                        data-floor="2"
                                        data-type="${r.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <!-- Số phòng + trạng thái -->
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="card-title mb-0">${r.roomNumber}</h6>
                                                <c:choose>
                                                    <c:when test="${r.roomStatus == 'Available'}">
                                                        <span class="badge bg-success">Đang trống</span>
                                                    </c:when>
                                                    <c:when test="${r.roomStatus == 'Occupied'}">
                                                        <span class="badge bg-danger">Đang có khách</span>
                                                    </c:when>
                                                    <c:when test="${r.roomStatus == 'Maintenance'}">
                                                        <span class="badge bg-warning text-dark">Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${r.roomStatus == 'Cleaning'}">
                                                        <span class="badge bg-info text-dark">Đang dọn dẹp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Loại phòng (icon & màu) -->
                                            <p class="card-text fw-bold mb-2">
                                                <c:choose>
                                                    <c:when test="${r.roomTypeName == 'Standard Room'}">
                                                        <i class="fas fa-bed text-primary me-1"></i>
                                                        <span class="text-primary">${r.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r.roomTypeName == 'Deluxe Room'}">
                                                        <i class="fas fa-bath text-success me-1"></i>
                                                        <span class="text-success">${r.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r.roomTypeName == 'Suite'}">
                                                        <i class="fas fa-couch text-danger me-1"></i>
                                                        <span class="text-danger">${r.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r.roomTypeName == 'Presidential Suite'}">
                                                        <i class="fas fa-crown text-warning me-1"></i>
                                                        <span class="text-warning">${r.roomTypeName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle text-muted me-1"></i>
                                                        <span class="text-muted">${r.roomTypeName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>

                                            <!-- Nút xem -->
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r.id}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <!-- Modal để Xem và Cập nhật Trạng thái phòng -->
                                <div class="modal fade" id="viewRoomModal${r.id}" tabindex="-1" aria-labelledby="viewRoomLabel${r.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!-- Header -->
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewRoomLabel${r.id}">
                                                    <i class="fas fa-door-open me-2"></i> Chi tiết phòng ${r.roomNumber}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <!-- Body -->
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <!-- Số phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Số phòng</label>
                                                        <input type="text" class="form-control text-primary fw-bold" value="${r.roomNumber}" readonly>
                                                    </div>

                                                    <!-- Loại phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Loại phòng</label>
                                                        <input type="text" class="form-control" value="${r.roomTypeName}" readonly>
                                                    </div>

                                                    <!-- Tầng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Tầng</label>
                                                        <input type="text" class="form-control" value="${r.floor}" readonly>
                                                    </div>

                                                    <!-- Sức chứa -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Sức chứa</label>
                                                        <input type="text" class="form-control" value="${r.capacity} khách" readonly>
                                                    </div>

                                                    <!-- Giá phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Giá phòng</label>
                                                        <input type="text" class="form-control text-success fw-bold" value="${r.roomPrice} VNĐ" readonly>
                                                    </div>

                                                    <!-- Trạng thái -->
                                                    <!-- Trạng thái -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Trạng thái</label>
                                                        <input type="text" class="form-control fw-bold
                                                               ${r.roomStatus == 'Occupied' ? 'text-danger' : 
                                                                 (r.roomStatus == 'Available' ? 'text-success' : 
                                                                 (r.roomStatus == 'Maintenance' ? 'text-warning' : 'text-primary'))}" 
                                                               value="${r.roomStatus == 'Occupied' ? 'Đang có khách' : 
                                                                        (r.roomStatus == 'Available' ? 'Đang trống' : 
                                                                        (r.roomStatus == 'Maintenance' ? 'Bảo trì' : 'Đang dọn dẹp'))}" 
                                                               readonly>
                                                    </div>


                                                    <!-- Hình ảnh -->
                                                    <div class="col-md-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Hình ảnh</label>
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${r.imageUrl}" width="150" class="rounded shadow-sm border" />
                                                        </div>
                                                    </div>

                                                    <!-- Mô tả -->
                                                    <div class="col-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Mô tả</label>
                                                        <div class="border rounded p-2" style="min-height: 100px;">
                                                            <c:out value="${r.description}" escapeXml="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>            
                        </div>
                    </div>

                    <!-- Floor 2 -->
                    <div class="floor-section">
                        <h5 class="mb-3"><i class="fas fa-building me-2"></i>2nd Floor</h5>
                        <div class="row g-3" id="floor2">
                            <c:forEach var="r2" items="${room2}">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div
                                        class="card room-card shadow-sm
                                        <c:choose>
                                            <c:when test="${r2.roomTypeName == 'Standard Room'}">border-primary bg-light</c:when>
                                            <c:when test="${r2.roomTypeName == 'Deluxe Room'}">border-success bg-light</c:when>
                                            <c:when test="${r2.roomTypeName == 'Suite'}">border-danger bg-light</c:when>
                                            <c:when test="${r2.roomTypeName == 'Presidential Suite'}">border-warning bg-light</c:when>
                                            <c:otherwise>border-secondary</c:otherwise>
                                        </c:choose>"
                                        data-room="${r2.roomNumber}"
                                        data-status="${r2.roomStatus}"
                                        data-floor="2"
                                        data-type="${r2.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <!-- Số phòng + trạng thái -->
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="card-title mb-0">${r2.roomNumber}</h6>
                                                <c:choose>
                                                    <c:when test="${r2.roomStatus == 'Available'}">
                                                        <span class="badge bg-success">Đang trống</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomStatus == 'Occupied'}">
                                                        <span class="badge bg-danger">Đang có khách</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomStatus == 'Maintenance'}">
                                                        <span class="badge bg-warning text-dark">Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomStatus == 'Cleaning'}">
                                                        <span class="badge bg-info text-dark">Đang dọn dẹp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Loại phòng (nổi bật với icon + viền màu) -->
                                            <!-- Loại phòng (nổi bật với icon + viền màu) -->
                                            <p class="card-text fw-bold mb-2">
                                                <c:choose>
                                                    <c:when test="${r2.roomTypeName == 'Standard Room'}">
                                                        <i class="fas fa-bed text-primary me-1"></i>
                                                        <span class="text-primary">${r2.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomTypeName == 'Deluxe Room'}">
                                                        <i class="fas fa-bath text-success me-1"></i>
                                                        <span class="text-success">${r2.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomTypeName == 'Suite'}">
                                                        <i class="fas fa-couch text-danger me-1"></i>
                                                        <span class="text-danger">${r2.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r2.roomTypeName == 'Presidential Suite'}">
                                                        <i class="fas fa-crown text-warning me-1"></i>
                                                        <span class="text-warning">${r2.roomTypeName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle text-muted me-1"></i>
                                                        <span class="text-muted">${r2.roomTypeName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>


                                            <!-- Nút xem -->
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r2.id}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Modal để Xem và Cập nhật Trạng thái phòng -->
                                <div class="modal fade" id="viewRoomModal${r2.id}" tabindex="-1" aria-labelledby="viewRoomLabel${r2.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!-- Header -->
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewRoomLabel${r2.id}">
                                                    <i class="fas fa-door-open me-2"></i> Chi tiết phòng ${r2.roomNumber}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <!-- Body -->
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <!-- Số phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Số phòng</label>
                                                        <input type="text" class="form-control text-primary fw-bold" value="${r2.roomNumber}" readonly>
                                                    </div>

                                                    <!-- Loại phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Loại phòng</label>
                                                        <input type="text" class="form-control" value="${r2.roomTypeName}" readonly>
                                                    </div>

                                                    <!-- Tầng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Tầng</label>
                                                        <input type="text" class="form-control" value="${r2.floor}" readonly>
                                                    </div>

                                                    <!-- Sức chứa -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Sức chứa</label>
                                                        <input type="text" class="form-control" value="${r2.capacity} khách" readonly>
                                                    </div>

                                                    <!-- Giá phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Giá phòng</label>
                                                        <input type="text" class="form-control text-success fw-bold" value="${r2.roomPrice} VNĐ" readonly>
                                                    </div>

                                                    <!-- Trạng thái -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Trạng thái</label>
                                                        <input type="text" class="form-control fw-bold
                                                               ${r2.roomStatus == 'Occupied' ? 'text-danger' : 
                                                                 (r2.roomStatus == 'Available' ? 'text-success' : 
                                                                 (r2.roomStatus == 'Maintenance' ? 'text-warning' : 'text-primary'))}" 
                                                               value="${r2.roomStatus == 'Occupied' ? 'Đang có khách' : 
                                                                        (r2.roomStatus == 'Available' ? 'Đang trống' : 
                                                                        (r2.roomStatus == 'Maintenance' ? 'Bảo trì' : 'Đang dọn dẹp'))}" 
                                                               readonly>
                                                    </div>

                                                    <!-- Hình ảnh -->
                                                    <div class="col-md-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Hình ảnh</label>
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${r2.imageUrl}" width="150" class="rounded shadow-sm border" />
                                                        </div>
                                                    </div>

                                                    <!-- Mô tả -->
                                                    <div class="col-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Mô tả</label>
                                                        <div class="border rounded p-2" style="min-height: 100px;">
                                                            <c:out value="${r2.description}" escapeXml="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>
                        </div>
                    </div>

                    <!-- Floor 3 -->
                    <div class="floor-section">
                        <h5 class="mb-3"><i class="fas fa-building me-2"></i>3rd Floor</h5>
                        <div class="row g-3" id="floor3">
                            <c:forEach var="r3" items="${room3}">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div
                                        class="card room-card shadow-sm
                                        <c:choose>
                                            <c:when test="${r3.roomTypeName == 'Standard Room'}">border-primary bg-light</c:when>
                                            <c:when test="${r3.roomTypeName == 'Deluxe Room'}">border-success bg-light</c:when>
                                            <c:when test="${r3.roomTypeName == 'Suite'}">border-danger bg-light</c:when>
                                            <c:when test="${r3.roomTypeName == 'Presidential Suite'}">border-warning bg-light</c:when>
                                            <c:otherwise>border-secondary</c:otherwise>
                                        </c:choose>"
                                        data-room="${r3.roomNumber}"
                                        data-status="${r3.roomStatus}"
                                        data-floor="3"
                                        data-type="${r3.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <!-- Số phòng + trạng thái -->
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="card-title mb-0">${r3.roomNumber}</h6>
                                                <c:choose>
                                                    <c:when test="${r3.roomStatus == 'Available'}">
                                                        <span class="badge bg-success">Đang trống</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomStatus == 'Occupied'}">
                                                        <span class="badge bg-danger">Đang có khách</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomStatus == 'Maintenance'}">
                                                        <span class="badge bg-warning text-dark">Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomStatus == 'Cleaning'}">
                                                        <span class="badge bg-info text-dark">Đang dọn dẹp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Loại phòng -->
                                            <p class="card-text fw-bold mb-2">
                                                <c:choose>
                                                    <c:when test="${r3.roomTypeName == 'Standard Room'}">
                                                        <i class="fas fa-bed text-primary me-1"></i>
                                                        <span class="text-primary">${r3.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomTypeName == 'Deluxe Room'}">
                                                        <i class="fas fa-bath text-success me-1"></i>
                                                        <span class="text-success">${r3.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomTypeName == 'Suite'}">
                                                        <i class="fas fa-couch text-danger me-1"></i>
                                                        <span class="text-danger">${r3.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r3.roomTypeName == 'Presidential Suite'}">
                                                        <i class="fas fa-crown text-warning me-1"></i>
                                                        <span class="text-warning">${r3.roomTypeName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle text-muted me-1"></i>
                                                        <span class="text-muted">${r3.roomTypeName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>

                                            <!-- Nút xem -->
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r3.id}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Modal để Xem và Cập nhật Trạng thái phòng -->
                                <div class="modal fade" id="viewRoomModal${r3.id}" tabindex="-1" aria-labelledby="viewRoomLabel${r3.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!-- Header -->
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewRoomLabel${r3.id}">
                                                    <i class="fas fa-door-open me-2"></i> Chi tiết phòng ${r3.roomNumber}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <!-- Body -->
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <!-- Số phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Số phòng</label>
                                                        <input type="text" class="form-control text-primary fw-bold" value="${r3.roomNumber}" readonly>
                                                    </div>

                                                    <!-- Loại phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Loại phòng</label>
                                                        <input type="text" class="form-control" value="${r3.roomTypeName}" readonly>
                                                    </div>

                                                    <!-- Tầng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Tầng</label>
                                                        <input type="text" class="form-control" value="${r3.floor}" readonly>
                                                    </div>

                                                    <!-- Sức chứa -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Sức chứa</label>
                                                        <input type="text" class="form-control" value="${r3.capacity} khách" readonly>
                                                    </div>

                                                    <!-- Giá phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Giá phòng</label>
                                                        <input type="text" class="form-control text-success fw-bold" value="${r3.roomPrice} VNĐ" readonly>
                                                    </div>

                                                    <!-- Trạng thái -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Trạng thái</label>
                                                        <input type="text" class="form-control fw-bold
                                                               ${r3.roomStatus == 'Occupied' ? 'text-danger' : 
                                                                 (r3.roomStatus == 'Available' ? 'text-success' : 
                                                                 (r3.roomStatus == 'Maintenance' ? 'text-warning' : 'text-primary'))}" 
                                                               value="${r3.roomStatus == 'Occupied' ? 'Đang có khách' : 
                                                                        (r3.roomStatus == 'Available' ? 'Đang trống' : 
                                                                        (r3.roomStatus == 'Maintenance' ? 'Bảo trì' : 'Đang dọn dẹp'))}" 
                                                               readonly>
                                                    </div>

                                                    <!-- Hình ảnh -->
                                                    <div class="col-md-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Hình ảnh</label>
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${r3.imageUrl}" width="150" class="rounded shadow-sm border" />
                                                        </div>
                                                    </div>

                                                    <!-- Mô tả -->
                                                    <div class="col-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Mô tả</label>
                                                        <div class="border rounded p-2" style="min-height: 100px;">
                                                            <c:out value="${r3.description}" escapeXml="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>
                        </div>
                    </div>

                    <!-- Floor 4 -->
                    <div class="floor-section">
                        <h5 class="mb-3"><i class="fas fa-building me-2"></i>Tầng 4</h5>
                        <div class="row g-3" id="floor4">
                            <c:forEach var="r4" items="${room4}">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div
                                        class="card room-card shadow-sm
                                        <c:choose>
                                            <c:when test="${r4.roomTypeName == 'Standard Room'}">border-primary bg-light</c:when>
                                            <c:when test="${r4.roomTypeName == 'Deluxe Room'}">border-success bg-light</c:when>
                                            <c:when test="${r4.roomTypeName == 'Suite'}">border-danger bg-light</c:when>
                                            <c:when test="${r4.roomTypeName == 'Presidential Suite'}">border-warning bg-light</c:when>
                                            <c:otherwise>border-secondary</c:otherwise>
                                        </c:choose>"
                                        data-room="${r4.roomNumber}"
                                        data-status="${r4.roomStatus}"
                                        data-floor="4"
                                        data-type="${r4.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="card-title mb-0">${r4.roomNumber}</h6>
                                                <c:choose>
                                                    <c:when test="${r4.roomStatus == 'Available'}">
                                                        <span class="badge bg-success">Đang trống</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomStatus == 'Occupied'}">
                                                        <span class="badge bg-danger">Đang có khách</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomStatus == 'Maintenance'}">
                                                        <span class="badge bg-warning text-dark">Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomStatus == 'Cleaning'}">
                                                        <span class="badge bg-info text-dark">Đang dọn dẹp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="card-text fw-bold mb-2">
                                                <c:choose>
                                                    <c:when test="${r4.roomTypeName == 'Standard Room'}">
                                                        <i class="fas fa-bed text-primary me-1"></i>
                                                        <span class="text-primary">${r4.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomTypeName == 'Deluxe Room'}">
                                                        <i class="fas fa-bath text-success me-1"></i>
                                                        <span class="text-success">${r4.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomTypeName == 'Suite'}">
                                                        <i class="fas fa-couch text-danger me-1"></i>
                                                        <span class="text-danger">${r4.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r4.roomTypeName == 'Presidential Suite'}">
                                                        <i class="fas fa-crown text-warning me-1"></i>
                                                        <span class="text-warning">${r4.roomTypeName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle text-muted me-1"></i>
                                                        <span class="text-muted">${r4.roomTypeName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r4.id}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Modal để Xem và Cập nhật Trạng thái phòng -->
                                <div class="modal fade" id="viewRoomModal${r4.id}" tabindex="-1" aria-labelledby="viewRoomLabel${r4.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!-- Header -->
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewRoomLabel${r4.id}">
                                                    <i class="fas fa-door-open me-2"></i> Chi tiết phòng ${r4.roomNumber}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <!-- Body -->
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <!-- Số phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Số phòng</label>
                                                        <input type="text" class="form-control text-primary fw-bold" value="${r4.roomNumber}" readonly>
                                                    </div>

                                                    <!-- Loại phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Loại phòng</label>
                                                        <input type="text" class="form-control" value="${r4.roomTypeName}" readonly>
                                                    </div>

                                                    <!-- Tầng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Tầng</label>
                                                        <input type="text" class="form-control" value="${r4.floor}" readonly>
                                                    </div>

                                                    <!-- Sức chứa -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Sức chứa</label>
                                                        <input type="text" class="form-control" value="${r4.capacity} khách" readonly>
                                                    </div>

                                                    <!-- Giá phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Giá phòng</label>
                                                        <input type="text" class="form-control text-success fw-bold" value="${r4.roomPrice} VNĐ" readonly>
                                                    </div>

                                                    <!-- Trạng thái -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Trạng thái</label>
                                                        <input type="text" class="form-control fw-bold
                                                               ${r4.roomStatus == 'Occupied' ? 'text-danger' : 
                                                                 (r4.roomStatus == 'Available' ? 'text-success' : 
                                                                 (r4.roomStatus == 'Maintenance' ? 'text-warning' : 'text-primary'))}" 
                                                               value="${r4.roomStatus == 'Occupied' ? 'Đang có khách' : 
                                                                        (r4.roomStatus == 'Available' ? 'Đang trống' : 
                                                                        (r4.roomStatus == 'Maintenance' ? 'Bảo trì' : 'Đang dọn dẹp'))}" 
                                                               readonly>
                                                    </div>

                                                    <!-- Hình ảnh -->
                                                    <div class="col-md-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Hình ảnh</label>
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${r4.imageUrl}" width="150" class="rounded shadow-sm border" />
                                                        </div>
                                                    </div>

                                                    <!-- Mô tả -->
                                                    <div class="col-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Mô tả</label>
                                                        <div class="border rounded p-2" style="min-height: 100px;">
                                                            <c:out value="${r4.description}" escapeXml="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>
                        </div>
                    </div>

                    <!-- Floor 5 -->
                    <div class="floor-section">
                        <h5 class="mb-3"><i class="fas fa-building me-2"></i>Tầng 5</h5>
                        <div class="row g-3" id="floor5">
                            <c:forEach var="r5" items="${room5}">
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div
                                        class="card room-card shadow-sm
                                        <c:choose>
                                            <c:when test="${r5.roomTypeName == 'Standard Room'}">border-primary bg-light</c:when>
                                            <c:when test="${r5.roomTypeName == 'Deluxe Room'}">border-success bg-light</c:when>
                                            <c:when test="${r5.roomTypeName == 'Suite'}">border-danger bg-light</c:when>
                                            <c:when test="${r5.roomTypeName == 'Presidential Suite'}">border-warning bg-light</c:when>
                                            <c:otherwise>border-secondary</c:otherwise>
                                        </c:choose>"
                                        data-room="${r5.roomNumber}"
                                        data-status="${r5.roomStatus}"
                                        data-floor="5"
                                        data-type="${r5.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="card-title mb-0">${r5.roomNumber}</h6>
                                                <c:choose>
                                                    <c:when test="${r5.roomStatus == 'Available'}">
                                                        <span class="badge bg-success">Đang trống</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomStatus == 'Occupied'}">
                                                        <span class="badge bg-danger">Đang có khách</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomStatus == 'Maintenance'}">
                                                        <span class="badge bg-warning text-dark">Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomStatus == 'Cleaning'}">
                                                        <span class="badge bg-info text-dark">Đang dọn dẹp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="card-text fw-bold mb-2">
                                                <c:choose>
                                                    <c:when test="${r5.roomTypeName == 'Standard Room'}">
                                                        <i class="fas fa-bed text-primary me-1"></i>
                                                        <span class="text-primary">${r5.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomTypeName == 'Deluxe Room'}">
                                                        <i class="fas fa-bath text-success me-1"></i>
                                                        <span class="text-success">${r5.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomTypeName == 'Suite'}">
                                                        <i class="fas fa-couch text-danger me-1"></i>
                                                        <span class="text-danger">${r5.roomTypeName}</span>
                                                    </c:when>
                                                    <c:when test="${r5.roomTypeName == 'Presidential Suite'}">
                                                        <i class="fas fa-crown text-warning me-1"></i>
                                                        <span class="text-warning">${r5.roomTypeName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle text-muted me-1"></i>
                                                        <span class="text-muted">${r5.roomTypeName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r5.id}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Modal để Xem và Cập nhật Trạng thái phòng -->
                                <div class="modal fade" id="viewRoomModal${r5.id}" tabindex="-1" aria-labelledby="viewRoomLabel${r5.id}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!-- Header -->
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewRoomLabel${r5.id}">
                                                    <i class="fas fa-door-open me-2"></i> Chi tiết phòng ${r5.roomNumber}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>

                                            <!-- Body -->
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <!-- Số phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Số phòng</label>
                                                        <input type="text" class="form-control text-primary fw-bold" value="${r5.roomNumber}" readonly>
                                                    </div>

                                                    <!-- Loại phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Loại phòng</label>
                                                        <input type="text" class="form-control" value="${r5.roomTypeName}" readonly>
                                                    </div>

                                                    <!-- Tầng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Tầng</label>
                                                        <input type="text" class="form-control" value="${r5.floor}" readonly>
                                                    </div>

                                                    <!-- Sức chứa -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Sức chứa</label>
                                                        <input type="text" class="form-control" value="${r5.capacity} khách" readonly>
                                                    </div>

                                                    <!-- Giá phòng -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Giá phòng</label>
                                                        <input type="text" class="form-control text-success fw-bold" value="${r5.roomPrice} VNĐ" readonly>
                                                    </div>

                                                    <!-- Trạng thái -->
                                                    <div class="col-md-6">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Trạng thái</label>
                                                        <input type="text" class="form-control fw-bold
                                                               ${r5.roomStatus == 'Occupied' ? 'text-danger' : 
                                                                 (r5.roomStatus == 'Available' ? 'text-success' : 
                                                                 (r5.roomStatus == 'Maintenance' ? 'text-warning' : 'text-primary'))}" 
                                                               value="${r5.roomStatus == 'Occupied' ? 'Đang có khách' : 
                                                                        (r5.roomStatus == 'Available' ? 'Đang trống' : 
                                                                        (r5.roomStatus == 'Maintenance' ? 'Bảo trì' : 'Đang dọn dẹp'))}" 
                                                               readonly>
                                                    </div>

                                                    <!-- Hình ảnh -->
                                                    <div class="col-md-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Hình ảnh</label>
                                                        <div class="mb-2">
                                                            <img src="${pageContext.request.contextPath}/${r5.imageUrl}" width="150" class="rounded shadow-sm border" />
                                                        </div>
                                                    </div>

                                                    <!-- Mô tả -->
                                                    <div class="col-12">
                                                        <label class="form-label text-secondary fw-semibold text-uppercase small">Mô tả</label>
                                                        <div class="border rounded p-2" style="min-height: 100px;">
                                                            <c:out value="${r5.description}" escapeXml="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Room Details Modal -->
        <div class="modal fade" id="roomDetailsModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Room Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="roomDetailsContent">
                            <!-- Room details will be loaded here -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Update Status</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Status Update Modal -->
        <div class="modal fade" id="statusUpdateModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Room Status</h5>
                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="modal"
                            ></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label class="form-label">Room Number</label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="updateRoomNumber"
                                    readonly
                                    />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">New Status</label>
                                <select class="form-select" id="newStatus" required>
                                    <option value="">Select Status</option>
                                    <option value="Available">Available</option>
                                    <option value="Occupied">Occupied</option>
                                    <option value="Maintenance">Maintenance</option>
                                    <option value="Cleaning">Cleaning</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal"
                            >
                            Cancel
                        </button>
                        <button
                            type="button"
                            class="btn btn-primary"
                            onclick="saveStatusUpdate()"
                            >
                            Update Status
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                // Sidebar toggle functionality
                                document
                                        .getElementById("menu-toggle")
                                        .addEventListener("click", function () {
                                            document
                                                    .getElementById("sidebar-wrapper")
                                                    .classList.toggle("toggled");
                                        });

                                // Filter rooms function
                                function filterRooms() {
                                    const statusFilter = document.getElementById("statusFilter").value;
                                    const floorFilter = document.getElementById("floorFilter").value;
                                    const typeFilter = document.getElementById("typeFilter").value;

                                    const rooms = document.querySelectorAll(".room-card");

                                    rooms.forEach((room) => {
                                        const roomStatus = room.getAttribute("data-status");
                                        const roomFloor = room.getAttribute("data-floor");
                                        const roomType = room.getAttribute("data-type");

                                        let show = true;

                                        if (statusFilter && roomStatus !== statusFilter)
                                            show = false;
                                        if (floorFilter && roomFloor !== floorFilter)
                                            show = false;
                                        if (typeFilter && roomType !== typeFilter)
                                            show = false;

                                        room.parentElement.style.display = show ? "block" : "none";
                                    });
                                }

                                // View mode functions
                                function setViewMode(mode) {
                                    // Toggle active button
                                    document.querySelectorAll(".btn-group button").forEach((btn) => {
                                        btn.classList.remove("active");
                                    });
                                    event.target.classList.add("active");

                                    // Implementation for different view modes would go here
                                    console.log("View mode set to:", mode);
                                }

                                // Room action functions
                                function viewRoom(event) {
                                    // Lấy thông tin từ thuộc tính dữ liệu của thẻ phòng
                                    const roomCard = event.target.closest('.room-card');  // Lấy phần tử card chứa thông tin phòng
                                    const roomNumber = roomCard.getAttribute("data-room");
                                    const roomType = roomCard.getAttribute("data-type");
                                    const roomFloor = roomCard.getAttribute("data-floor");
                                    const roomStatus = roomCard.getAttribute("data-status");

                                    // Hiển thị thông tin chi tiết trong modal
                                    document.getElementById("roomDetailsContent").innerHTML = `
        <div class="row">
            <div class="col-md-6">
                <h6>Room Information</h6>
                <p><strong>Room Number:</strong> ${roomNumber}</p>
                <p><strong>Type:</strong> ${roomType}</p>
                <p><strong>Floor:</strong> ${roomFloor} Floor</p>
                <p><strong>Capacity:</strong> 2 Guests</p>
                <p><strong>Price:</strong> $120/night</p>
            </div>
            <div class="col-md-6">
                <h6>Current Status</h6>
                <p><strong>Status:</strong> <span class="badge ${roomStatus == 'Occupied' ? 'bg-danger' : 'bg-success'}">${roomStatus}</span></p>
                <p><strong>Last Cleaned:</strong> Today 10:30 AM</p>
                <p><strong>Last Maintenance:</strong> May 20, 2025</p>
                <p><strong>Next Booking:</strong> May 27, 2025</p>
            </div>
        </div>
        <hr>
        <h6>Amenities</h6>
        <div class="row">
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li><i class="fas fa-wifi text-success me-2"></i>WiFi</li>
                    <li><i class="fas fa-snowflake text-success me-2"></i>AC</li>
                    <li><i class="fas fa-tv text-success me-2"></i>TV</li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li><i class="fas fa-glass-martini text-success me-2"></i>Mini Bar</li>
                    <li><i class="fas fa-shield-alt text-success me-2"></i>Safe</li>
                    <li><i class="fas fa-phone text-success me-2"></i>Phone</li>
                </ul>
            </div>
        </div>
    `;

                                    // Hiển thị modal
                                    new bootstrap.Modal(document.getElementById("roomDetailsModal")).show();
                                }


                                function updateStatus(roomNumber) {
                                    document.getElementById("updateRoomNumber").value = roomNumber;
                                    new bootstrap.Modal(
                                            document.getElementById("statusUpdateModal")
                                            ).show();
                                }

                                function checkOut(roomNumber) {
                                    if (
                                            confirm(
                                                    `Are you sure you want to check out guest from Room ${roomNumber}?`
                                                    )
                                            ) {
                                        alert(
                                                `Guest checked out from Room ${roomNumber}. Room status updated to cleaning.`
                                                );
                                        // Implementation for actual checkout would go here
                                    }
                                }

                                function markClean(roomNumber) {
                                    if (confirm(`Mark Room ${roomNumber} as clean and available?`)) {
                                        alert(`Room ${roomNumber} marked as clean and available.`);
                                        // Implementation for actual status update would go here
                                    }
                                }

                                function markFixed(roomNumber) {
                                    if (confirm(`Mark Room ${roomNumber} maintenance as complete?`)) {
                                        alert(
                                                `Room ${roomNumber} maintenance completed. Room status updated to available.`
                                                );
                                        // Implementation for actual status update would go here
                                    }
                                }

                                function saveStatusUpdate() {
                                    const roomNumber = document.getElementById("updateRoomNumber").value;
                                    const newStatus = document.getElementById("newStatus").value;

                                    if (!newStatus) {
                                        alert("Please select a status");
                                        return;
                                    }

                                    alert(`Room ${roomNumber} status updated to ${newStatus}`);
                                    bootstrap.Modal.getInstance(
                                            document.getElementById("statusUpdateModal")
                                            ).hide();
                                    // Implementation for actual status update would go here
                                }

                                function refreshStatus() {
                                    alert("Room status refreshed");
                                    // Implementation for actual refresh would go here
                                }

                                function bulkUpdate() {
                                    alert("Bulk update feature coming soon");
                                    // Implementation for bulk update would go here
                                }
        </script>
    </body>
</html>
