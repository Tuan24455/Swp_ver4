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
    </head>
    <body>
        <div class="d-flex" id="wrapper">
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

                <div class="container-fluid py-4">
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
                            <i class="fas fa-plus me-2"></i>Add New Room
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
                    <div class="card shadow-sm mb-4">
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Room Type</label>
                                    <select class="form-select">
                                        <option value="">All Types</option>
                                        <option value="standard">Standard</option>
                                        <option value="deluxe">Deluxe</option>
                                        <option value="suite">Suite</option>
                                        <option value="presidential">Presidential</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Status</label>
                                    <select class="form-select">
                                        <option value="">All Status</option>
                                        <option value="available">Available</option>
                                        <option value="occupied">Occupied</option>
                                        <option value="maintenance">Maintenance</option>
                                        <option value="cleaning">Cleaning</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Floor</label>
                                    <select class="form-select">
                                        <option value="">All Floors</option>
                                        <option value="1">1st Floor</option>
                                        <option value="2">2nd Floor</option>
                                        <option value="3">3rd Floor</option>
                                        <option value="4">4th Floor</option>
                                        <option value="5">5th Floor</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid">
                                        <button class="btn btn-outline-primary">
                                            <i class="fas fa-search me-2"></i>Filter
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

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
                                    <tbody>
                                        <c:forEach var="r" items="${room}">
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
                                                          ${r.roomStatus == 'Available' ? 'bg-success' : 
                                                            (r.roomStatus == 'Occupied' ? 'bg-warning text-dark' : 
                                                            (r.roomStatus == 'Maintenance' ? 'bg-danger' : 'bg-secondary'))}">
                                                              ${r.roomStatus}
                                                          </span>
                                                    </td>
                                                    <td>2025-05-25</td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-warning" title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-info" title="Set Maintenance">
                                                                <i class="fas fa-tools"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Room Modal -->
            <div class="modal fade" id="addRoomModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Add New Room</h5>
                            <button
                                type="button"
                                class="btn-close"
                                data-bs-dismiss="modal"
                                ></button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Room Number</label>
                                        <input type="text" class="form-control" required />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Room Type</label>
                                        <select class="form-select" required>
                                            <option value="">Select Room Type</option>
                                            <option value="standard">Standard Room</option>
                                            <option value="deluxe">Deluxe Room</option>
                                            <option value="suite">Suite</option>
                                            <option value="presidential">Presidential Suite</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Floor</label>
                                        <select class="form-select" required>
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
                                        <select class="form-select" required>
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
                                        <input
                                            type="number"
                                            class="form-control"
                                            step="0.01"
                                            required
                                            />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Status</label>
                                        <select class="form-select" required>
                                            <option value="available">Available</option>
                                            <option value="maintenance">Maintenance</option>
                                            <option value="cleaning">Cleaning</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Room Description</label>
                                        <textarea
                                            class="form-control"
                                            rows="3"
                                            placeholder="Enter room features and amenities..."
                                            ></textarea>
                                    </div>
                           
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
                            <button type="button" class="btn btn-primary">Add Room</button>
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
            </script>
        </body>
    </html>
