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
                        <ol class="breadcrumb custom-breadcrumb">
                            <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Room Status
                            </li>
                        </ol>
                    </nav>

                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h3 mb-0">Danh sách phòng</h1>
                    </div>

                    <!-- Room Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Available</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Available'] != null ? statusCounts['Available'] : 0}</h2>
                                    <p class="card-text text-success">
                                        <i class="fas fa-check-circle me-1"></i> Ready for booking
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Occupied</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Occupied'] != null ? statusCounts['Occupied'] : 0}</h2>
                                    <p class="card-text text-warning">
                                        <i class="fas fa-user me-1"></i> Currently booked
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Maintenance</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Maintenance'] != null ? statusCounts['Maintenance'] : 0}</h2>
                                    <p class="card-text text-danger">
                                        <i class="fas fa-tools me-1"></i> Under maintenance
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Cleaning</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${statusCounts['Cleaning'] != null ? statusCounts['Cleaning'] : 0}</h2>
                                    <p class="card-text text-danger">
                                        <i class="fas fa-tools me-1"></i> Under maintenance
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Options -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Filter by Status</label>
                                    <select
                                        class="form-select"
                                        id="statusFilter"
                                        onchange="filterRooms()"
                                        >
                                        <option value="">All Status</option>
                                        <option value="Available">Available</option>
                                        <option value="Occupied">Occupied</option>
                                        <option value="Maintenance">Maintenance</option>
                                        <option value="Cleaning">Cleaning</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Filter by Floor</label>
                                    <select
                                        class="form-select"
                                        id="floorFilter"
                                        onchange="filterRooms()"
                                        >
                                        <option value="">All Floors</option>
                                        <option value="1">1st Floor</option>
                                        <option value="2">2nd Floor</option>
                                        <option value="3">3rd Floor</option>
                                        <option value="4">4th Floor</option>
                                        <option value="5">5th Floor</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Filter by Type</label>
                                    <select
                                        class="form-select"
                                        id="typeFilter"
                                        onchange="filterRooms()"
                                        >
                                        <option value="">All Types</option>
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
                                        class="card room-card room-available shadow-sm"
                                        data-room="${r.roomNumber}"
                                        data-status="${r.roomStatus}"
                                        data-floor="1"
                                        data-type="${r.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div
                                                class="d-flex justify-content-between align-items-center mb-2"
                                                >
                                                <h6 class="card-title mb-0">${r.roomNumber}</h6>
                                                <span class="badge bg-success">${r.roomStatus}</span>
                                            </div>
                                            <p class="card-text text-muted small mb-2">${r.roomTypeName}</p>
                                            <div
                                                class="d-flex justify-content-between align-items-center"
                                                >

                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r.id}">
                                                        <i class="fas fa-eye"></i> View Details
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
                                            <form action="updateStatusRoom" method="post">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="viewRoomLabel${r.id}">Room Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="roomId" value="${r.id}" />

                                                    <div class="row g-3">
                                                        <!-- Room Number -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Number</label>
                                                            <p class="form-control-plaintext">${r.roomNumber}</p>
                                                        </div>

                                                        <!-- Room Type -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Type</label>
                                                            <p class="form-control-plaintext">${r.roomTypeName}</p>
                                                        </div>

                                                        <!-- Floor -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Floor</label>
                                                            <p class="form-control-plaintext">${r.floor} Floor</p>
                                                        </div>

                                                        <!-- Capacity -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Capacity</label>
                                                            <p class="form-control-plaintext">${r.capacity} Guests</p>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Price</label>
                                                            <p class="form-control-plaintext">${r.roomPrice}</p>
                                                        </div>

                                                        <!-- cho phép chỉnh sửa trạng thái) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Status</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" ${r.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                <option value="Occupied" ${r.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                <option value="Maintenance" ${r.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                <option value="Cleaning" ${r.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                            </select>
                                                        </div>

                                                        <!-- Image -->
                                                        <div class="col-md-12">
                                                            <label class="form-label">Image</label>
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${r.imageUrl}" width="100" class="rounded" />
                                                            </div>
                                                        </div>

                                                        <!-- Description -->
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <p class="form-control-plaintext">${r.description}</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                </div>
                                            </form>
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
                                        class="card room-card room-maintenance shadow-sm"
                                        data-room="${r2.roomNumber}"
                                        data-status="${r2.roomStatus}"
                                        data-floor="2"
                                        data-type="${r2.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div
                                                class="d-flex justify-content-between align-items-center mb-2"
                                                >
                                                <h6 class="card-title mb-0">${r2.roomNumber}</h6>
                                                <span class="badge bg-danger">${r2.roomStatus}</span>
                                            </div>
                                            <p class="card-text text-muted small mb-2">${r2.roomTypeName}</p>
                                            <div
                                                class="d-flex justify-content-between align-items-center"
                                                >
                                                <small class="text-muted">Issue: AC repair</small>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r2.id}">
                                                        <i class="fas fa-eye"></i> View Details
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
                                            <form action="updateStatusRoom" method="post">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="viewRoomLabel${r2.id}">Room Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="roomId" value="${r2.id}" />

                                                    <div class="row g-3">
                                                        <!-- Room Number -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Number</label>
                                                            <p class="form-control-plaintext">${r2.roomNumber}</p>
                                                        </div>

                                                        <!-- Room Type -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Type</label>
                                                            <p class="form-control-plaintext">${r2.roomTypeName}</p>
                                                        </div>

                                                        <!-- Floor -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Floor</label>
                                                            <p class="form-control-plaintext">${r2.floor} Floor</p>
                                                        </div>

                                                        <!-- Capacity -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Capacity</label>
                                                            <p class="form-control-plaintext">${r2.capacity} Guests</p>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Price</label>
                                                            <p class="form-control-plaintext">${r2.roomPrice}</p>
                                                        </div>

                                                        <!-- cho phép chỉnh sửa trạng thái) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Status</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" ${r2.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                <option value="Occupied" ${r2.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                <option value="Maintenance" ${r2.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                <option value="Cleaning" ${r2.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                            </select>
                                                        </div>

                                                        <!-- Image -->
                                                        <div class="col-md-12">
                                                            <label class="form-label">Image</label>
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${r2.imageUrl}" width="100" class="rounded" />
                                                            </div>
                                                        </div>

                                                        <!-- Description -->
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <p class="form-control-plaintext">${r2.description}</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                </div>
                                            </form>
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
                                        class="card room-card room-maintenance shadow-sm"
                                        data-room="${r3.roomNumber}"
                                        data-status="${r3.roomStatus}"
                                        data-floor="3"
                                        data-type="${r3.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div
                                                class="d-flex justify-content-between align-items-center mb-2"
                                                >
                                                <h6 class="card-title mb-0">${r3.roomNumber}</h6>
                                                <span class="badge bg-danger">${r3.roomStatus}</span>
                                            </div>
                                            <p class="card-text text-muted small mb-2">${r3.roomTypeName}</p>
                                            <div
                                                class="d-flex justify-content-between align-items-center"
                                                >
                                                <small class="text-muted">Issue: AC repair</small>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r3.id}">
                                                        <i class="fas fa-eye"></i> View Details
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
                                            <form action="updateStatusRoom" method="post">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="viewRoomLabel${r3.id}">Room Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="roomId" value="${r3.id}" />

                                                    <div class="row g-3">
                                                        <!-- Room Number -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Number</label>
                                                            <p class="form-control-plaintext">${r3.roomNumber}</p>
                                                        </div>

                                                        <!-- Room Type -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Type</label>
                                                            <p class="form-control-plaintext">${r3.roomTypeName}</p>
                                                        </div>

                                                        <!-- Floor -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Floor</label>
                                                            <p class="form-control-plaintext">${r3.floor} Floor</p>
                                                        </div>

                                                        <!-- Capacity -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Capacity</label>
                                                            <p class="form-control-plaintext">${r3.capacity} Guests</p>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Price</label>
                                                            <p class="form-control-plaintext">${r3.roomPrice}</p>
                                                        </div>

                                                        <!-- cho phép chỉnh sửa trạng thái) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Status</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" ${r3.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                <option value="Occupied" ${r3.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                <option value="Maintenance" ${r3.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                <option value="Cleaning" ${r3.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                            </select>
                                                        </div>

                                                        <!-- Image -->
                                                        <div class="col-md-12">
                                                            <label class="form-label">Image</label>
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${r3.imageUrl}" width="100" class="rounded" />
                                                            </div>
                                                        </div>

                                                        <!-- Description -->
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <p class="form-control-plaintext">${r3.description}</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                </div>
                                            </form>
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
                                        class="card room-card room-maintenance shadow-sm"
                                        data-room="${r4.roomNumber}"
                                        data-status="${r4.roomStatus}"
                                        data-floor="4"
                                        data-type="${r4.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div
                                                class="d-flex justify-content-between align-items-center mb-2"
                                                >
                                                <h6 class="card-title mb-0">${r4.roomNumber}</h6>
                                                <span class="badge bg-danger">${r4.roomStatus}</span>
                                            </div>
                                            <p class="card-text text-muted small mb-2">${r4.roomTypeName}</p>
                                            <div
                                                class="d-flex justify-content-between align-items-center"
                                                >
                                                <small class="text-muted">Issue: AC repair</small>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r4.id}">
                                                        <i class="fas fa-eye"></i> View Details
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
                                            <form action="updateStatusRoom" method="post">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="viewRoomLabel${r4.id}">Room Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="roomId" value="${r4.id}" />

                                                    <div class="row g-3">
                                                        <!-- Room Number -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Number</label>
                                                            <p class="form-control-plaintext">${r4.roomNumber}</p>
                                                        </div>

                                                        <!-- Room Type -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Type</label>
                                                            <p class="form-control-plaintext">${r4.roomTypeName}</p>
                                                        </div>

                                                        <!-- Floor -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Floor</label>
                                                            <p class="form-control-plaintext">${r4.floor} Floor</p>
                                                        </div>

                                                        <!-- Capacity -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Capacity</label>
                                                            <p class="form-control-plaintext">${r4.capacity} Guests</p>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Price</label>
                                                            <p class="form-control-plaintext">${r4.roomPrice}</p>
                                                        </div>

                                                        <!-- cho phép chỉnh sửa trạng thái) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Status</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" ${r4.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                <option value="Occupied" ${r4.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                <option value="Maintenance" ${r4.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                <option value="Cleaning" ${r4.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                            </select>
                                                        </div>

                                                        <!-- Image -->
                                                        <div class="col-md-12">
                                                            <label class="form-label">Image</label>
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${r4.imageUrl}" width="100" class="rounded" />
                                                            </div>
                                                        </div>

                                                        <!-- Description -->
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <p class="form-control-plaintext">${r4.description}</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                </div>
                                            </form>
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
                                        class="card room-card room-maintenance shadow-sm"
                                        data-room="${r5.roomNumber}"
                                        data-status="${r5.roomStatus}"
                                        data-floor="5"
                                        data-type="${r5.roomTypeName}"
                                        >
                                        <div class="card-body">
                                            <div
                                                class="d-flex justify-content-between align-items-center mb-2"
                                                >
                                                <h6 class="card-title mb-0">${r5.roomNumber}</h6>
                                                <span class="badge bg-danger">${r5.roomStatus}</span>
                                            </div>
                                            <p class="card-text text-muted small mb-2">${r5.roomTypeName}</p>
                                            <div
                                                class="d-flex justify-content-between align-items-center"
                                                >
                                                <small class="text-muted">Issue: AC repair</small>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#viewRoomModal${r5.id}">
                                                        <i class="fas fa-eye"></i> View Details
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
                                            <form action="updateStatusRoom" method="post">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="viewRoomLabel${r5.id}">Room Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="roomId" value="${r5.id}" />

                                                    <div class="row g-3">
                                                        <!-- Room Number -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Number</label>
                                                            <p class="form-control-plaintext">${r5.roomNumber}</p>
                                                        </div>

                                                        <!-- Room Type -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Room Type</label>
                                                            <p class="form-control-plaintext">${r5.roomTypeName}</p>
                                                        </div>

                                                        <!-- Floor -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Floor</label>
                                                            <p class="form-control-plaintext">${r5.floor} Floor</p>
                                                        </div>

                                                        <!-- Capacity -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Capacity</label>
                                                            <p class="form-control-plaintext">${r5.capacity} Guests</p>
                                                        </div>

                                                        <!-- Price -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Price</label>
                                                            <p class="form-control-plaintext">${r5.roomPrice}</p>
                                                        </div>

                                                        <!-- cho phép chỉnh sửa trạng thái) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label">Status</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" ${r5.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                <option value="Occupied" ${r5.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                <option value="Maintenance" ${r5.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                <option value="Cleaning" ${r5.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                            </select>
                                                        </div>

                                                        <!-- Image -->
                                                        <div class="col-md-12">
                                                            <label class="form-label">Image</label>
                                                            <div class="mb-2">
                                                                <img src="${pageContext.request.contextPath}/${r5.imageUrl}" width="100" class="rounded" />
                                                            </div>
                                                        </div>

                                                        <!-- Description -->
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <p class="form-control-plaintext">${r5.description}</p>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                </div>
                                            </form>
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
