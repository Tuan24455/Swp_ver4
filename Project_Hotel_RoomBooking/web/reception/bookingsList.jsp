<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
         prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Bookings Management - Hotel Management System</title>
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
                <jsp:param name="activePage" value="bookings" />
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

                <div
                    class="mb-4"
                    style="
                    background-image: url('https://images.squarespace-cdn.com/content/v1/5aadf482aa49a1d810879b88/1626698419120-J7CH9BPMB2YI728SLFPN/1.jpg');
                    background-size: cover;
                    background-position: center center;
                    background-repeat: no-repeat;
                    padding: 20px 30px;
                    border-radius: 0.25rem;
                    color: white;
                    box-shadow: inset 0 0 0 1000px rgba(0,0,0,0.4);
                    "
                    >
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb custom-breadcrumb" style="color: white;">
                            <li class="breadcrumb-item"><a href="dashboard.jsp" style="color: #ddd;">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page" style="color: #fff;">
                                Bookings
                            </li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="h3 mb-0">Bookings Management</h1>
                        <button
                            class="btn btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#addBookingModal"
                            >
                            <i class="fas fa-plus me-2"></i>Add New Booking
                        </button>
                    </div>
                </div>



                <!-- Filter Section -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select">
                                    <option value="">All Status</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="pending">Pending</option>
                                    <option value="cancelled">Cancelled</option>
                                    <option value="completed">Completed</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" />
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

                <!-- Bookings Table -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0">All Bookings</h5>
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
                                    placeholder="Search bookings..."
                                    />
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Guest Name</th>
                                        <th>Room Type</th>
                                        <th>Check In</th>
                                        <th>Check Out</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>#BK001</td>
                                        <td>John Doe</td>
                                        <td>Deluxe Room</td>
                                        <td>2025-05-26</td>
                                        <td>2025-05-28</td>
                                        <td>$450.00</td>
                                        <td><span class="badge bg-success">Confirmed</span></td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    class="btn btn-sm btn-outline-primary"
                                                    title="View"
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
                                                    class="btn btn-sm btn-outline-danger"
                                                    title="Cancel"
                                                    >
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>#BK002</td>
                                        <td>Jane Smith</td>
                                        <td>Standard Room</td>
                                        <td>2025-05-27</td>
                                        <td>2025-05-30</td>
                                        <td>$320.00</td>
                                        <td><span class="badge bg-warning">Pending</span></td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    class="btn btn-sm btn-outline-primary"
                                                    title="View"
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
                                                    class="btn btn-sm btn-outline-danger"
                                                    title="Cancel"
                                                    >
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>#BK003</td>
                                        <td>Mike Johnson</td>
                                        <td>Suite</td>
                                        <td>2025-05-25</td>
                                        <td>2025-05-27</td>
                                        <td>$680.00</td>
                                        <td><span class="badge bg-primary">Completed</span></td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button
                                                    class="btn btn-sm btn-outline-primary"
                                                    title="View"
                                                    >
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button
                                                    class="btn btn-sm btn-outline-secondary"
                                                    title="Receipt"
                                                    >
                                                    <i class="fas fa-receipt"></i>
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
                                   >Showing 1 to 3 of 50 entries</small
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

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Booking</h5>
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
                                <label class="form-label">Guest Name</label>
                                <input type="text" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone</label>
                                <input type="tel" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Room Type</label>
                                <select class="form-select" required>
                                    <option value="">Select Room Type</option>
                                    <option value="standard">Standard Room</option>
                                    <option value="deluxe">Deluxe Room</option>
                                    <option value="suite">Suite</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Number of Guests</label>
                                <select class="form-select" required>
                                    <option value="">Select</option>
                                    <option value="1">1 Guest</option>
                                    <option value="2">2 Guests</option>
                                    <option value="3">3 Guests</option>
                                    <option value="4">4 Guests</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Total Amount</label>
                                <input
                                    type="number"
                                    class="form-control"
                                    step="0.01"
                                    required
                                    />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Special Requests</label>
                                <textarea class="form-control" rows="3"></textarea>
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
                    <button type="button" class="btn btn-primary">
                        Create Booking
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
