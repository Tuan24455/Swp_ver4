<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Room List - Hotel Management System</title>
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
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
    </head>
    <body>
        <div class="d-flex" id="wrapper" >
            <jsp:include page="includes/sidebar.jsp">
                <jsp:param name="activePage" value="roomlist" />
            </jsp:include>

            <!-- Main Content -->
            <div id="page-content-wrapper" class="flex-fill">
                <!-- Top Navigation -->
                <nav 
                    class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm"
                    >
                    <div class="container-fluid">
                        <button class="btn btn-outline-secondary" id="menu-toggle">
                            <i class="fas fa-bars"></i>
                        </button>
                    </div>
                </nav>

                <div class="container-fluid py-4" >
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb custom-breadcrumb">
                            <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Room List
                            </li>
                        </ol>
                    </nav>

                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h3 mb-0">Room Management</h1>
                        <button
                            class="btn btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#addRoomModal"
                            >
                            <i class="fas fa-plus me-2"></i>Thêm phòng mới
                        </button>
                    </div>

                    <!-- Room Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card kpi-card shadow-sm">
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">Total Rooms</h6>
                                    <h2 class="card-title display-6 fw-bold mb-1">${totalRooms}</h2>
                                    <p class="card-text text-info">
                                        <i class="fas fa-bed me-1"></i> All room types
                                    </p>
                                </div>
                            </div>
                        </div>
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
                    </div>

                    <!-- Filter Section -->
                    <form method="get" action="roomList" class="row g-3 mb-4">
                        <input type="hidden" name="page" value="1" />
                        <div class="col-md-3">
                            <label class="form-label">Loại phòng</label>
                            <select name="roomType" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="rt" items="${roomTypes}">
                                    <option value="${rt.roomType}" ${param.roomType == rt.roomType ? 'selected' : ''}>
                                        ${rt.roomType}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Tình trạng</label>
                            <select name="roomStatus" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="Available" ${param.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                <option value="Occupied" ${param.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                <option value="Maintenance" ${param.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                <option value="Cleaning" ${param.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">Tầng</label>
                            <select name="floor" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach begin="1" end="5" var="i">
                                    <option value="${i}" ${param.floor == i ? 'selected' : ''}>Tầng ${i}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2 align-self-end">
                            <button type="submit" class="btn btn-primary w-100">Lọc</button>
                        </div>
                    </form>
                    <!-- Rooms Table -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0">All Rooms</h5>
                        </div>
                        <div class="card-body">
                            <div
                                class="d-flex justify-content-between align-items-center mb-3 flex-wrap"
                                >

                                <div
                                    class="input-group search-table-input"
                                    style="width: 250px"
                                    >
                                    <span class="input-group-text"
                                          ><i class="fas fa-search"></i
                                        ></span>
                                    <input
                                        type="text"
                                        class="form-control"
                                        placeholder="Search rooms..."
                                        />
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Image</th>
                                            <th>Room Number</th>
                                            <th>Room Type</th>
                                            <th>Floor</th>
                                            <th>Capacity</th>
                                            <th>Price/Night</th>
                                            <th>Status</th>
                                            <th>Last Cleaned</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <c:forEach var="r" items="${rooms}">
                                        <tbody>                               
                                            <tr>
                                                <td>
                                                    <img src="${r.imageUrl}" alt="Room Image" width="80" height="60" style="object-fit:cover; border-radius: 6px;" />
                                                </td>
                                                <td><strong>${r.roomNumber}</strong></td>
                                                <td>${r.roomTypeName}</td>
                                                <td>${r.floor}</td>
                                                <td>${r.capacity}</td>
                                                <td>$${r.roomPrice}</td>
                                                <td>
                                                    <span class="badge
                                                          ${r.roomStatus == 'Available' ? 'bg-light text-dark' : 
                                                            (r.roomStatus == 'Occupied' ? 'bg-warning text-dark' : 
                                                            (r.roomStatus == 'Maintenance' ? 'bg-danger' :
                                                            (r.roomStatus == 'Cleaning' ? 'bg-info text-dark' : 'bg-secondary')))}">
                                                              ${r.roomStatus}
                                                          </span>
                                                    </td>
                                                    <td>2025-05-25</td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <button
                                                                class="btn btn-sm btn-outline-warning"
                                                                title="Edit"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#editRoomModal${r.id}">
                                                                <i class="fas fa-edit"></i>
                                                            </button>

                                                            <form action="${pageContext.request.contextPath}/deleteRoom" method="POST" style="display:inline;" onsubmit="return confirmDelete(${r.roomNumber});">
                                                                <input type="hidden" name="roomId" value="${r.id}" />
                                                                <input type="hidden" name="action" value="delete" />
                                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>          
                                            </tbody>  
                                            <div class="modal fade" id="editRoomModal${r.id}" tabindex="-1" aria-labelledby="updateRoomLabel${r.id}" aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <form action="updateRoom" method="post" enctype="multipart/form-data">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="updateRoomLabel${r.id}">Cập nhật phòng</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>

                                                            <div class="modal-body">
                                                                <input type="hidden" name="roomId" value="${r.id}" />
                                                                <input type="hidden" name="oldImageUrl" value="${r.imageUrl}" />

                                                                <div class="row g-3">
                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Room Number</label>
                                                                        <input type="text" class="form-control" name="roomNumber" value="${r.roomNumber}" required />
                                                                    </div>

                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Room Type</label>
                                                                        <select name="roomType" class="form-select" required>
                                                                            <option value="Standard Room" ${r.roomTypeName == 'Standard Room' ? 'selected' : ''}>Standard Room</option>
                                                                            <option value="Deluxe Room" ${r.roomTypeName == 'Deluxe Room' ? 'selected' : ''}>Deluxe Room</option>
                                                                            <option value="Suite" ${r.roomTypeName == 'Suite' ? 'selected' : ''}>Suite</option>
                                                                            <option value="Presidential Suite" ${r.roomTypeName == 'Presidential Suite' ? 'selected' : ''}>Presidential Suite</option>
                                                                        </select>
                                                                    </div>

                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Floor</label>
                                                                        <select class="form-select" name="floor" required>
                                                                            <option value="1" <c:if test="${r.floor == 1}">selected</c:if>>1st Floor</option>
                                                                            <option value="2" <c:if test="${r.floor == 2}">selected</c:if>>2nd Floor</option>
                                                                            <option value="3" <c:if test="${r.floor == 3}">selected</c:if>>3rd Floor</option>
                                                                            <option value="4" <c:if test="${r.floor == 4}">selected</c:if>>4th Floor</option>
                                                                            <option value="5" <c:if test="${r.floor == 5}">selected</c:if>>5th Floor</option>
                                                                            </select>
                                                                        </div>

                                                                        <div class="col-md-6">
                                                                            <label class="form-label">Capacity</label>
                                                                            <select class="form-select" name="capacity" required>
                                                                                <option value="1" ${r.capacity == 1 ? 'selected' : ''}>1 Guest</option>
                                                                            <option value="2" ${r.capacity == 2 ? 'selected' : ''}>2 Guests</option>
                                                                            <option value="3" ${r.capacity == 3 ? 'selected' : ''}>3 Guests</option>
                                                                            <option value="4" ${r.capacity == 4 ? 'selected' : ''}>4 Guests</option>
                                                                            <option value="6" ${r.capacity == 6 ? 'selected' : ''}>6 Guests</option>
                                                                        </select>
                                                                    </div>

                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Price</label>
                                                                        <input type="number" class="form-control" step="0.01" name="price" value="${r.roomPrice}" required />
                                                                    </div>

                                                                    <div class="col-md-6">
                                                                        <label class="form-label">Status</label>
                                                                        <select name="status" class="form-select" required>
                                                                            <option value="Available" ${r.roomStatus == 'Available' ? 'selected' : ''}>Available</option>
                                                                            <option value="Occupied" ${r.roomStatus == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                                                            <option value="Maintenance" ${r.roomStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                                                            <option value="Cleaning" ${r.roomStatus == 'Cleaning' ? 'selected' : ''}>Cleaning</option>
                                                                        </select>
                                                                    </div>

                                                                    <div class="col-md-12">
                                                                        <label class="form-label">Image</label>
                                                                        <div class="mb-2">
                                                                            <img src="${pageContext.request.contextPath}/${r.imageUrl}" width="100" class="rounded" />
                                                                        </div>
                                                                        <input type="file" class="form-control" name="roomImage" accept="image/*" />
                                                                    </div>

                                                                    <div class="col-12">
                                                                        <label class="form-label">Description</label>
                                                                        <textarea name="description" class="form-control" id="editDescription${r.id}" rows="3" required>${r.description}</textarea>
                                                                        <script>
                                                                            CKEDITOR.replace('editDescription${r.id}');
                                                                        </script>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary">Update Room</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>                                                                  
                                        </c:forEach>

                                    </table>
                                </div>
                                <c:set var="startEntry" value="${(currentPage - 1) * pageSize + 1}" />
                                <c:set var="endEntry" value="${startEntry + rooms.size() - 1}" />

                                <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                                    <small class="text-muted mb-2 mb-md-0">
                                        Showing ${startEntry} to ${endEntry} of ${totalRooms} entries
                                    </small>

                                    <nav aria-label="Room pagination">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${currentPage - 1}">
                                                    Previous
                                                </a>
                                            </li>

                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                       href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${p}">
                                                        ${p}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="roomList?roomType=${paramRoomType}&roomStatus=${paramRoomStatus}&floor=${paramFloor}&page=${currentPage + 1}">
                                                    Next
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>



                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <script>
                function confirmDelete(roomName) {
                    return confirm('Are you sure you want to delete the room "' + roomName + '"?');
                }
            </script>

            <!-- Add Room Modal -->
            <div class="modal fade" id="addRoomModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm phòng mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/addRoom" method="post" enctype="multipart/form-data">
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Room Number</label>
                                        <input type="text" class="form-control" name="roomNumber" required />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Room Type</label>
                                        <select class="form-select" name="roomType" required>
                                            <option value="">Select Room Type</option>
                                            <option value="Standard Room">Standard Room</option>
                                            <option value="Deluxe Room">Deluxe Room</option>
                                            <option value="Suite">Suite</option>
                                            <option value="Presidential Suite">Presidential Suite</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Floor</label>
                                        <select class="form-select" name="floor" required>
                                            <option value="">Select Floor</option>
                                            <option value="1">1st Floor</option>
                                            <option value="2">2nd Floor</option>
                                            <option value="3">3rd Floor</option>
                                            <option value="4">4th Floor</option>
                                            <option value="5">5th Floor</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Capacity</label>
                                        <select class="form-select" name="capacity" required>
                                            <option value="">Select Capacity</option>
                                            <option value="1">1 Guest</option>
                                            <option value="2">2 Guests</option>
                                            <option value="3">3 Guests</option>
                                            <option value="4">4 Guests</option>
                                            <option value="6">6 Guests</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Price per Night</label>
                                        <input type="number" class="form-control" name="price" step="0.01" required />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Status</label>
                                        <select class="form-select" name="status" required>
                                            <option value="Available">Available</option>
                                            <option value="Occupied">Occupied</option>
                                            <option value="Maintenance">Maintenance</option>
                                            <option value="Cleaning">Cleaning</option>
                                        </select>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">Room Image</label>
                                        <input type="file" class="form-control" name="roomImage" accept="image/*" required />
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Room Description</label>
                                        <textarea class="form-control" name="description" id="addDescription" rows="3"
                                                  placeholder="Enter room features and amenities..." required></textarea>
                                        <script>
                                            CKEDITOR.replace('addDescription');
                                        </script>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    Cancel
                                </button>
                                <button type="submit" class="btn btn-primary">Add Room</button>
                            </div>
                        </form>
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
            </script>
        </body>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </html>
