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
                  <h2 class="card-title display-6 fw-bold mb-1">150</h2>
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
                  <h2 class="card-title display-6 fw-bold mb-1">87</h2>
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
                  <h2 class="card-title display-6 fw-bold mb-1">45</h2>
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
                  <h2 class="card-title display-6 fw-bold mb-1">18</h2>
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
                <div class="d-flex align-items-center mb-2 mb-md-0">
                  <span class="me-2 text-muted">Show</span>
                  <select
                    class="form-select form-select-sm"
                    style="width: auto"
                  >
                    <option value="10">10</option>
                    <option value="25">25</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                  </select>
                  <span class="ms-2 text-muted">entries</span>
                </div>
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
                    <tr>
                      <td><strong>101</strong></td>
                      <td>Standard Room</td>
                      <td>1st Floor</td>
                      <td>2 Guests</td>
                      <td>$120.00</td>
                      <td><span class="badge bg-success">Available</span></td>
                      <td>2025-05-25</td>
                      <td>
                        <div class="btn-group" role="group">
                          <button
                            class="btn btn-sm btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-warning"
                            title="Edit"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-info"
                            title="Set Maintenance"
                          >
                            <i class="fas fa-tools"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>102</strong></td>
                      <td>Deluxe Room</td>
                      <td>1st Floor</td>
                      <td>3 Guests</td>
                      <td>$180.00</td>
                      <td><span class="badge bg-warning">Occupied</span></td>
                      <td>2025-05-24</td>
                      <td>
                        <div class="btn-group" role="group">
                          <button
                            class="btn btn-sm btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-warning"
                            title="Edit"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-secondary"
                            title="Check Out"
                            disabled
                          >
                            <i class="fas fa-sign-out-alt"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>201</strong></td>
                      <td>Suite</td>
                      <td>2nd Floor</td>
                      <td>4 Guests</td>
                      <td>$350.00</td>
                      <td><span class="badge bg-danger">Maintenance</span></td>
                      <td>2025-05-23</td>
                      <td>
                        <div class="btn-group" role="group">
                          <button
                            class="btn btn-sm btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-warning"
                            title="Edit"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-success"
                            title="Mark Available"
                          >
                            <i class="fas fa-check"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><strong>301</strong></td>
                      <td>Presidential Suite</td>
                      <td>3rd Floor</td>
                      <td>6 Guests</td>
                      <td>$750.00</td>
                      <td><span class="badge bg-success">Available</span></td>
                      <td>2025-05-25</td>
                      <td>
                        <div class="btn-group" role="group">
                          <button
                            class="btn btn-sm btn-outline-primary"
                            title="View Details"
                          >
                            <i class="fas fa-eye"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-warning"
                            title="Edit"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            class="btn btn-sm btn-outline-info"
                            title="Set Maintenance"
                          >
                            <i class="fas fa-tools"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div
                class="d-flex justify-content-between align-items-center mt-3 flex-wrap"
              >
                <small class="text-muted mb-2 mb-md-0"
                  >Showing 1 to 4 of 150 entries</small
                >
                <nav aria-label="Page navigation">
                  <ul class="pagination pagination-sm mb-0">
                    <li class="page-item disabled">
                      <a class="page-link" href="#">Previous</a>
                    </li>
                    <li class="page-item active">
                      <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">2</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">3</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">Next</a>
                    </li>
                  </ul>
                </nav>
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
                <div class="col-12">
                  <label class="form-label">Amenities</label>
                  <div class="row">
                    <div class="col-md-4">
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="wifi"
                        />
                        <label class="form-check-label" for="wifi">WiFi</label>
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="ac"
                        />
                        <label class="form-check-label" for="ac"
                          >Air Conditioning</label
                        >
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="tv"
                        />
                        <label class="form-check-label" for="tv">TV</label>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="minibar"
                        />
                        <label class="form-check-label" for="minibar"
                          >Mini Bar</label
                        >
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="balcony"
                        />
                        <label class="form-check-label" for="balcony"
                          >Balcony</label
                        >
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="safe"
                        />
                        <label class="form-check-label" for="safe">Safe</label>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="jacuzzi"
                        />
                        <label class="form-check-label" for="jacuzzi"
                          >Jacuzzi</label
                        >
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="kitchenette"
                        />
                        <label class="form-check-label" for="kitchenette"
                          >Kitchenette</label
                        >
                      </div>
                      <div class="form-check">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          id="workspace"
                        />
                        <label class="form-check-label" for="workspace"
                          >Work Space</label
                        >
                      </div>
                    </div>
                  </div>
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
